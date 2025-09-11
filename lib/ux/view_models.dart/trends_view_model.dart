import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xtrends/ux/services/networking.dart';
import 'package:xtrends/ux/services/trends_repository.dart';
import 'package:xtrends/ux/shared/models/ui_models.dart';
import 'package:xtrends/ux/shared/resources/app_constants.dart';

class TrendsViewModel extends ChangeNotifier {
  final TrendsRepository _repo = TrendsRepository();

  List<Trend> _trends = [];
  bool _loading = false;

  List<Trend> get trends => _trends;
  bool get isLoading => _loading;

  Future<void> fetchTrends({String? country}) async {
    setLoadingState(true);

    try {
      final cacheKey = buildCacheKey(country);
      final cacheStrategy = await determineCacheStategy(cacheKey);

      await handleCacheStrategy(cacheStrategy, country, cacheKey);
    } catch (e) {
      handleError(e);
    }

    _loading = false;
    notifyListeners();
  }

  void setLoadingState(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  String buildCacheKey(String? country) {
    return 'trends_cache_${country ?? "default"}';
  }

  Future<CacheStrategy> determineCacheStategy(String cacheKey) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(cacheKey);

    if (cachedData == null) {
      return CacheStrategy.fetchFreshOnly;
    }

    final cacheInfo = parseCachedData(cachedData);
    return decideCacheStrategy(cacheInfo);
  }

  CacheInfo parseCachedData(String cachedData) {
    final cachedMap = jsonDecode(cachedData) as Map<String, dynamic>;
    final lastFetched = DateTime.parse(cachedMap['timestamp']);
    final now = DateTime.now();
    final cacheAge = now.difference(lastFetched);
    final isNewDay = !isSameDay(lastFetched, now);

    return CacheInfo(
        data: cachedMap,
        lastFetched: lastFetched,
        cacheAge: cacheAge,
        isNewDay: isNewDay);
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  CacheStrategy decideCacheStrategy(CacheInfo cacheInfo) {
    if (cacheInfo.isNewDay) {
      debugPrint('New day detected - fetching fresh trends');
      return CacheStrategy.showCachedThenFetch;
    }

    if (cacheInfo.cacheAge.inHours < 2) {
      debugPrint(
          'Using cached trends (${cacheInfo.cacheAge.inMinutes}) minutes old');
      return CacheStrategy.cachedOnly;
    }

    debugPrint(
        'Cache is old (${cacheInfo.cacheAge.inHours} hours) - refreshing');
    return CacheStrategy.showCachedThenFetch;
  }

  Future<void> handleCacheStrategy(
      CacheStrategy strategy, String? country, String cacheKey) async {
    switch (strategy) {
      case CacheStrategy.fetchFreshOnly:
        await fetchFreshTrends(country, cacheKey);
        break;

      case CacheStrategy.cachedOnly:
        await loadCachedTrends(cacheKey);
        setLoadingState(false);
        break;

      case CacheStrategy.showCachedThenFetch:
        await loadCachedTrends(cacheKey);
        await fetchFreshTrends(country, cacheKey);
        break;
    }
  }

  Future<void> loadCachedTrends(String cacheKey) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(cacheKey);

    if (cachedData == null) return;
    final cachedMap = jsonDecode(cachedData) as Map<String, dynamic>;
    _trends =
        (cachedMap['trends'] as List).map((e) => Trend.fromJson(e)).toList();

    notifyListeners();
  }

  void handleError(dynamic error) {
    debugPrint('Error fetching trends: $error');
    _trends = [];
  }

  Future<void> fetchFreshTrends(String? country, String cacheKey) async {
    try {
      if (await hasCachedTrends(country)) {
        await clearCache(country: country);
      }

      final placeID = await getValidPlaceID(country);
      final trendsData = await fetchTrendsFromAPI(placeID);
      await processFreshTrends(trendsData ?? {}, cacheKey);
    } catch (e) {
      handleFreshTrendsError(e);
    }
  }

  Future<String> getValidPlaceID(String? country) async {
    final placeID = await _repo.fetchPlaceID(countryName: country);

    if (isInvalidPlaceID(placeID)) {
      throw TrendsException('Invalid placeID received: $placeID');
    }

    return placeID;
  }

  bool isInvalidPlaceID(String placeID) {
    return placeID.isEmpty || placeID == 'error';
  }

  Future<Map<String, dynamic>?> fetchTrendsFromAPI(String placeID) async {
    final networkHelper = createNetworkHelper(placeID);

    debugPrint(
        'Fetching fresh trends from: https://${AppConstants.apiHost}/location/$placeID');

    final result = await networkHelper.getData();

    if (result == null) {
      throw TrendsException('API returned null response');
    }

    return result;
  }

  NetworkHelper createNetworkHelper(String placeID) {
    return NetworkHelper(
      url: AppConstants.apiHost ?? '',
      path: '/location/$placeID',
      headers: buildAPIHeaders(),
      errorMessage: 'Failed to fetch trends',
    );
  }

  Map<String, dynamic> buildAPIHeaders() {
    return {
      'x-rapidapi-host': AppConstants.apiHost,
      'x-rapidapi-key': AppConstants.apiKey
    };
  }

  Future<void> processFreshTrends(
      Map<String, dynamic> trendsData, String cacheKey) async {
    final trendingResponse = parseTrendsResponse(trendsData);
    updateTrendsData(trendingResponse.trends);
    await cacheFreshTrends(cacheKey);

    debugPrint('Fresh trends fetched and cached');
  }

  TrendingResponse parseTrendsResponse(Map<String, dynamic> data) {
    try {
      return TrendingResponse.fromJson(data);
    } catch (e) {
      throw TrendsException('Failed to parse trends response: $e');
    }
  }

  void updateTrendsData(List<Trend> newTrends) {
    _trends = newTrends;
    notifyListeners();
  }

  Future<void> cacheFreshTrends(String cacheKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await saveToCache(prefs, cacheKey);
    } catch (e) {
      debugPrint('Warning: Failed to cache trends: $e');
    }
  }

  Future<void> saveToCache(SharedPreferences prefs, String cacheKey) async {
    final cachedData = buildCacheData();
    await prefs.setString(cacheKey, jsonEncode(cachedData));
  }

  Map<String, dynamic> buildCacheData() {
    return {
      'timestamp': DateTime.now().toIso8601String(),
      'trends': _trends.map((e) => e.toJson()).toList(),
    };
  }

  void handleFreshTrendsError(dynamic error) {
    final erroMessage = error is TrendsException
        ? error.message
        : 'Unknown error fetching fresh trends: $error';

    debugPrint('Error fetch fresh trends: $erroMessage');

    if (_trends.isEmpty) {
      _trends = [];
      notifyListeners();
    }
  }

  Future<void> clearCache({String? country}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = buildCacheKey(country);
      await prefs.remove(cacheKey);
      debugPrint('Cache cleared for key: $cacheKey');
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }
  }

  Future<void> refreshTrends({String? country}) async {
    try {
      debugPrint('Refreshing trends for country: ${country ?? "default"}');
      final cacheKey = buildCacheKey(country);
      await fetchFreshTrends(country, cacheKey);
    } catch (e) {
      debugPrint('Error refreshing trends: $e');
    }
  }

  Future<bool> hasCachedTrends(String? country) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = buildCacheKey(country);
    return prefs.containsKey(cacheKey);
  }
}

class CacheInfo {
  final Map<String, dynamic> data;
  final DateTime lastFetched;
  final Duration cacheAge;
  final bool isNewDay;

  CacheInfo({
    required this.data,
    required this.lastFetched,
    required this.cacheAge,
    required this.isNewDay,
  });
}

enum CacheStrategy { fetchFreshOnly, cachedOnly, showCachedThenFetch }

class TrendsException implements Exception {
  final String message;
  TrendsException(this.message);

  @override
  String toString() => 'TrendsException: $message';
}
