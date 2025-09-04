import 'package:flutter/material.dart';
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
      final placeID = await _repo.fetchPlaceID(countryName: country);

      NetworkHelper networkHelper = NetworkHelper(
          url: AppConstants.apiHost ?? '',
          path: '/location/$placeID',
          headers: {
            'x-rapidapi-host': AppConstants.apiHost,
            'x-rapidapi-key': AppConstants.apiKey
          },
          errorMessage: 'Failed to fetch trends');

      // print(
      //     "Fetching trends from: https://${AppConstants.apiHost}/location/$placeID");

      final trendsResult = await networkHelper.getData();

      if (trendsResult != null) {
        final trendingResponse = TrendingResponse.fromJson(trendsResult);
        _trends = trendingResponse.trends;
      }
    } catch (e) {
      debugPrint("Error fetching trends: $e");
      _trends = [];
    }

    _loading = false;
    notifyListeners();
  }
}
