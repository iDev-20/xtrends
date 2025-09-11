import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xtrends/ux/shared/models/ui_models.dart';

class SavedTrendsViewModel extends ChangeNotifier {
  static const String _savedTrendsKey = 'saved_trends';

  List<SavedTrend> _savedTrends = [];
  bool _isLoading = false;

  List<SavedTrend> get savedTrends => _savedTrends;
  bool get isLoading => _isLoading;

  Future<void> loadSavedTrends() async {
    await setLoadingState(true);

    try {
      final savedTrendsData = await getSavedTrendsFromStorage();
      _savedTrends = parseSavedTrends(savedTrendsData);
      sortTrendsByDate();
    } catch (e) {
      debugPrint('Error loading saved trends: $e');
      _savedTrends = [];
    } finally {
      await setLoadingState(false);
    }
  }

  Future<void> setLoadingState(bool loading) async {
    _isLoading = loading;
    notifyListeners();
  }

  Future<String?> getSavedTrendsFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_savedTrendsKey);
  }

  List<SavedTrend> parseSavedTrends(String? savedTrendsData) {
    if (savedTrendsData == null) return [];

    try {
      final List<dynamic> trendsJson = jsonDecode(savedTrendsData);
      return trendsJson.map((json) => SavedTrend.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error parsing saved trends: $e');
      return [];
    }
  }

  void sortTrendsByDate() {
    _savedTrends.sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  Future<bool> saveTrend({
    required String domain,
    required int rank,
    required String trendName,
    required String noOfTweets,
    required String tweetWebUrl,
    required String tweetMobileUrl,
  }) async {
    if (isTrendAlreadySaved(trendName, domain)) {
      return false;
    }

    final savedTrend = createSavedTrend(
      domain: domain,
      rank: rank,
      trendName: trendName,
      noOfTweets: noOfTweets,
      tweetWebUrl: tweetWebUrl,
      tweetMobileUrl: tweetMobileUrl,
    );

    return await addTrendToStorage(savedTrend);
  }

  bool isTrendAlreadySaved(String trendName, String domain) {
    return _savedTrends.any((trend) =>
        trend.trendName.toLowerCase() == trendName.toLowerCase() &&
        trend.domain.toLowerCase() == domain.toLowerCase());
  }

  SavedTrend createSavedTrend({
    required String domain,
    required int rank,
    required String trendName,
    required String noOfTweets,
    required String tweetWebUrl,
    required String tweetMobileUrl,
  }) {
    return SavedTrend(
      id: SavedTrend.generateId(trendName, domain),
      domain: domain,
      rank: rank,
      trendName: trendName,
      noOfTweets: noOfTweets,
      tweetWebUrl: tweetWebUrl,
      tweetMobileUrl: tweetMobileUrl,
      savedAt: DateTime.now(),
    );
  }

  Future<bool> addTrendToStorage(SavedTrend savedTrend) async {
    try {
      _savedTrends.insert(0, savedTrend);
      await persistTrendsToStorage();
      notifyListeners();
      debugPrint('Saved Trend');
      return true;
    } catch (e) {
      debugPrint('Error saving trend: $e');
      _savedTrends.removeWhere((trend) => trend.id == savedTrend.id);
      return false;
    }
  }

  Future<bool> removeTrend(String trendName, String domain) async {
    final trendIndex = findTrendIndex(trendName, domain);

    if (trendIndex == -1) return false;

    return await removeTrendFromStorage(trendIndex);
  }

  int findTrendIndex(String trendName, String domain) {
    return _savedTrends.indexWhere((trend) =>
        trend.trendName.toLowerCase() == trendName.toLowerCase() &&
        trend.domain.toLowerCase() == domain.toLowerCase());
  }

  Future<bool> removeTrendFromStorage(int trendIndex) async {
    try {
      _savedTrends.removeAt(trendIndex);
      await persistTrendsToStorage();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error removing trend: $e');
      return false;
    }
  }

  Future<void> persistTrendsToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final trendsJson = _savedTrends.map((trend) => trend.toJson()).toList();
    await prefs.setString(_savedTrendsKey, jsonEncode(trendsJson));
  }

  bool isTrendSaved(String trendName, String domain) {
    return _savedTrends.any((trend) =>
        trend.trendName.toLowerCase() == trendName.toLowerCase() &&
        trend.domain.toLowerCase() == domain.toLowerCase());
  }

  Future<bool> toggleTrendSaved({
    required String domain,
    required int rank,
    required String trendName,
    required String noOfTweets,
    required String tweetWebUrl,
    required String tweetMobileUrl,
  }) async {
    if (isTrendSaved(trendName, domain)) {
      return await removeTrend(trendName, domain);
    } else {
      return await saveTrend(
        domain: domain,
        rank: rank,
        trendName: trendName,
        noOfTweets: noOfTweets,
        tweetWebUrl: tweetWebUrl,
        tweetMobileUrl: tweetMobileUrl,
      );
    }
  }

  void clearAllSavedTrends() async {
    _savedTrends.clear();
    await persistTrendsToStorage();
    notifyListeners();
  }

  String formatSavedTime(DateTime savedAt) {
    final now = DateTime.now();
    final difference = now.difference(savedAt);

    if (difference.inDays <= 5) {
      return formatRelativeTime(difference);
    }

    return formatAbsoluteTime(savedAt, now);
  }

  String formatRelativeTime(Duration difference) {
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  String formatAbsoluteTime(DateTime savedAt, DateTime now) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    final day = savedAt.day.toString().padLeft(2, '0');
    final month = months[savedAt.month - 1];

    if (savedAt.year == now.year) {
      return '$day $month';
    }

    final year = (savedAt.year % 100).toString().padLeft(2, '0');
    return '$day $month, $year';
  }
}
