import 'package:flutter/material.dart';
import 'package:xtrends/ux/services/location_service.dart';
import 'package:xtrends/ux/shared/models/ui_models.dart';
import 'package:xtrends/ux/view_models.dart/location_view_model.dart';

class TrendsRepository {
  final LocationViewModel locationsViewModel = LocationViewModel();

  Future<String> fetchPlaceID({String? countryName}) async {
    try {
      final country = await resolveCountryName(countryName);

      if (isInvalidCountry(country)) {
        return handleNoCountryFound();
      }

      await ensureLocationsLoaded();

      return findPlaceIDForCountry(country ?? '');
    } catch (e) {
      return handleFetchError(e);
    }
  }

  Future<String?> resolveCountryName(String? countryName) async {
    return countryName ?? await LocationService().getCountryName();
  }

  bool isInvalidCountry(String? country) {
    return country == null || country.isEmpty;
  }

  String handleNoCountryFound() {
    debugPrint('No country name found');
    return '';
  }

  Future<void> ensureLocationsLoaded() async {
    if (locationsViewModel.locations.isEmpty) {
      await locationsViewModel.fetchLocations();
    }
  }

  String findPlaceIDForCountry(String country) {
    final location = locationsViewModel.findLocationByName(country);

    return location != null
        ? handleLocationFound(country, location)
        : handleLocationNotFound(country);
  }

  String handleLocationFound(String country, TrendLocation location) {
    debugPrint('Place ID found for $country: ${location.placeID}');
    return location.placeID;
  }

  String handleLocationNotFound(String country) {
    debugPrint('No location found for country $country');
    logAvailableLocations();
    return '';
  }

  void logAvailableLocations() {
    final availableLocations =
        locationsViewModel.locations.map((loc) => loc.name).join(', ');
    debugPrint('Available locations: $availableLocations');
  }

  String handleFetchError(dynamic error) {
    debugPrint('Error fetching placeID: $error');
    return '';
  }

  Future<List<TrendLocation>> getAvailableLocations() async {
    await ensureLocationsLoaded();
    return locationsViewModel.locations;
  }
}
