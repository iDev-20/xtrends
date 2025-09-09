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

      // Check if cached trends exist
      final cachedData = prefs.getString(cacheKey);
      if (cachedData != null) {
        final cachedMap = jsonDecode(cachedData) as Map<String, dynamic>;
        final lastFetched = DateTime.parse(cachedMap['timestamp']);

        // Use cached data if it's less than 10 minutes old
        if (DateTime.now().difference(lastFetched).inMinutes < 10) {
          _trends = (cachedMap['trends'] as List)
              .map((e) => Trend.fromJson(e))
              .toList();
          _loading = false;
          notifyListeners();
          return;
        }
      }

      final placeID = await _repo.fetchPlaceID(countryName: country);

      NetworkHelper networkHelper = NetworkHelper(
          url: AppConstants.apiHost ?? '',
          path: '/location/$placeID',
          headers: {
            'x-rapidapi-host': AppConstants.apiHost,
            'x-rapidapi-key': AppConstants.apiKey
          },
          errorMessage: 'Failed to fetch trends');

      print(
          "Fetching trends from: https://${AppConstants.apiHost}/location/$placeID");

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
      }
    } catch (e) {
      debugPrint("Error fetching trends: $e");
      _trends = [];
    }

    _loading = false;
    notifyListeners();
  }
}
