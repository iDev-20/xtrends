import 'package:flutter/material.dart';
import 'package:xtrends/ux/services/location_service.dart';
import 'package:xtrends/ux/shared/models/ui_models.dart';
import 'package:xtrends/ux/view_models.dart/location_view_model.dart';

class TrendsRepository {
  final LocationViewModel _locationsViewModel = LocationViewModel();

  Future<String> fetchPlaceID({String? countryName}) async {
    try {
      final country = countryName ?? await LocationService().getCountryName();

      if (country == null || country.isEmpty) {
        debugPrint("No country name found");
        return '';
      }

      if (_locationsViewModel.locations.isEmpty) {
        await _locationsViewModel.fetchLocations();
      }

      final location = _locationsViewModel.findLocationByName(country);

      if (location != null) {
        debugPrint("Place ID found for $country: ${location.placeID}");
        return location.placeID;
      } else {
        debugPrint("No location found for country: $country");
        debugPrint(
            "Available locations: ${_locationsViewModel.locations.map((l) => l.name).join(', ')}");
        return '';
      }
    } catch (e) {
      debugPrint("Error fetching placeID: $e");
      return 'error';
    }
  }

  /// Get all available locations
  Future<List<TrendLocation>> getAvailableLocations() async {
    if (_locationsViewModel.locations.isEmpty) {
      await _locationsViewModel.fetchLocations();
    }
    return _locationsViewModel.locations;
  }
}
