import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:xtrends/ux/shared/models/ui_models.dart';
import 'package:xtrends/ux/shared/resources/app_constants.dart';

class SavedTrendsRepository {
  Future<List<SavedTrend>> getSavedTrends() async {
    final pref = await SharedPreferences.getInstance();
    final trendsJson = pref.getStringList(AppConstants.savedTrendsKey) ?? [];
    return trendsJson
        .map((json) => SavedTrend.fromJson(jsonDecode(json)))
        .toList()
      ..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  Future<bool> isTrendSaved(String trendId) async {
    final savedTrends = await getSavedTrends();
    return savedTrends.any((trend) => trend.id == trendId);
  }

  Future<void> saveTrend(SavedTrend trend) async {
    final pref = await SharedPreferences.getInstance();
    final savedTrends = await getSavedTrends();

    if (!savedTrends.any((t) => t.id == trend.id)) {
      savedTrends.add(trend);
      final trendsJson =
          savedTrends.map((trend) => jsonEncode(trend.toJson())).toList();
      await pref.setStringList(AppConstants.savedTrendsKey, trendsJson);
    }
  }

  Future<void> removeTrend(String trendId) async {
    final pref = await SharedPreferences.getInstance();
    final savedTrends = await getSavedTrends();
    savedTrends.removeWhere((trend) => trend.id == trendId);
    final trendsJson =
        savedTrends.map((trend) => jsonEncode(trend.toJson())).toList();
    await pref.setStringList(AppConstants.savedTrendsKey, trendsJson);
  }
}
