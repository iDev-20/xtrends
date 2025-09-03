import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xtrends/ux/services/networking.dart';
import 'package:xtrends/ux/services/trends_repository.dart';
import 'package:xtrends/ux/shared/models/ui_models.dart';
import 'package:xtrends/ux/shared/resources/app_constants.dart';

class TrendsViewModel extends ChangeNotifier {
  final TrendsRepository _repo = TrendsRepository();

  List<dynamic> _trends = [];
  bool _loading = false;

  List<dynamic> get trends => _trends;
  bool get isLoading => _loading;

  Future<void> fetchTrends() async {
    _loading = true;
    notifyListeners();

    try {
      final woeid = await _repo.fetchWOEID();

      NetworkHelper networkHelper = NetworkHelper(
          url: AppConstants.apiHost ?? '',
          path: '/location/$woeid',
          headers: {
            'x-rapidapi-host': AppConstants.apiHost,
            'x-rapidapi-key': AppConstants.apiKey
          },
          // queryParams: {'woeid': woeid.toString()},
          errorMessage: 'Failed to fetch trends');

      final trendsResult = await networkHelper.getData();
      final data = jsonDecode(trendsResult.body);

      final trendingResponse = TrendingResponse.fromJson(data);
      _trends = trendingResponse.trends;
    } catch (e) {
      debugPrint("Error fetching trends: $e");
      _trends = [];
    }

    _loading = false;
    notifyListeners();
  }
}
