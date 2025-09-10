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
    _loading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = 'trends_cache_${country ?? "default"}';

      bool shouldShowCachedData = false;
      bool shouldFetchFreshData = true;

      // Check if cached trends exist
      final cachedData = prefs.getString(cacheKey);
      if (cachedData != null) {
        final cachedMap = jsonDecode(cachedData) as Map<String, dynamic>;
        final lastFetched = DateTime.parse(cachedMap['timestamp']);
        final now = DateTime.now();

        final isNewDay = !_isSameDay(lastFetched, now);

        final cacheAge = now.difference(lastFetched);
        final isCacheRecent = cacheAge.inHours < 2;

        if (isNewDay) {
          shouldShowCachedData = true;
          shouldFetchFreshData = true;
          debugPrint('New day detected - fetching fresh trends');
        } else if (isCacheRecent) {
          shouldShowCachedData = true;
          shouldFetchFreshData = false;
          debugPrint('Using cached trends (${cacheAge.inMinutes} minutes old)');
        } else {
          shouldShowCachedData = true;
          shouldFetchFreshData = true;
          debugPrint('Cache is old (${cacheAge.inHours} hours) - refreshing');
        }

        if (shouldShowCachedData) {
          _trends = (cachedMap['trends'] as List)
              .map((e) => Trend.fromJson(e))
              .toList();

          if (!shouldFetchFreshData) {
            _loading = false;
          }
          notifyListeners();

          if (!shouldFetchFreshData) {
            return;
          }
        }
      }

      if (shouldFetchFreshData) {
        await _fetchFreshTrends(country, cacheKey);
      }
    } catch (e) {
      debugPrint("Error fetching trends: $e");
      _trends = [];
    }

    _loading = false;
    notifyListeners();
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> _fetchFreshTrends(String? country, String cacheKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final placeID = await _repo.fetchPlaceID(countryName: country);

      if (placeID.isEmpty || placeID == 'error') {
        debugPrint('Invalid placeID received');
        return;
      }

      NetworkHelper networkHelper = NetworkHelper(
          url: AppConstants.apiHost ?? '',
          path: '/location/$placeID',
          headers: {
            'x-rapidapi-host': AppConstants.apiHost,
            'x-rapidapi-key': AppConstants.apiKey
          },
          errorMessage: 'Failed to fetch trends');

      debugPrint(
          "Fetching fresh trends from: https://${AppConstants.apiHost}/location/$placeID");

      final trendsResult = await networkHelper.getData();

      if (trendsResult != null) {
        final trendingResponse = TrendingResponse.fromJson(trendsResult);
        _trends = trendingResponse.trends;

        // Save to cache
        prefs.setString(
          cacheKey,
          jsonEncode({
            'timestamp': DateTime.now().toIso8601String(),
            'trends': _trends.map((e) => e.toJson()).toList(),
          }),
        );

        debugPrint("Fresh trends fetched and cached");
      }
    } catch (e) {
      debugPrint("Error fetching fresh trends: $e");
    }
  }

  Future<void> clearCache({String? country}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = 'trends_cache_${country ?? "default"}';
      await prefs.remove(cacheKey);
      debugPrint('Cache cleared for key: $cacheKey');
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }
  }

  Future<void> refreshTrends({String? country}) async {
    try {
      debugPrint('Refreshing trends for country: ${country ?? "default"}');
      await clearCache(country: country);
      await fetchTrends(country: country);
    } catch (e) {
      debugPrint('Error refreshing trends: $e');
    }
  }
}
