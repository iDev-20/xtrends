import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xtrends/ux/services/networking.dart';
import 'package:xtrends/ux/shared/models/ui_models.dart';
import 'package:xtrends/ux/shared/resources/app_constants.dart';

class LocationViewModel extends ChangeNotifier {
  static const int _cacheValidityDays = 7;

  List<TrendLocation> _locations = [];
  bool _loading = false;
  String? _errorMessage;

  List<TrendLocation> get locations => _locations;
  bool get isLoading => _loading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchLocations() async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final pref = await SharedPreferences.getInstance();

      final cachedData = pref.getString(AppConstants.locationCacheKey);
      if (cachedData != null) {
        final cachedMap = jsonDecode(cachedData) as Map<String, dynamic>;
        final lastFetched = DateTime.parse(cachedMap['timestamp']);
        final cacheAge = DateTime.now().difference(lastFetched);

        if (cacheAge.inDays < _cacheValidityDays) {
          _locations = (cachedMap['locations'] as List)
              .map((json) => TrendLocation.fromJson(json))
              .toList();

          debugPrint('Loaded ${_locations.length} locations from cache');
          _loading = false;
          notifyListeners();
          return;
        } else {
          debugPrint('Cached locations are ${cacheAge.inDays} days old');
        }
      }

      await _fetchFreshLocations();
    } catch (e) {
      debugPrint('Error fetching locations: $e');
      _errorMessage = 'Failed to load locations';
      _locations = [];
    }
  }

  Future<void> _fetchFreshLocations() async {
    try {
      NetworkHelper networkHelper = NetworkHelper(
          url: AppConstants.apiHost ?? '',
          path: '/locations',
          headers: {
            'x-rapidapi-host': AppConstants.apiHost,
            'x-rapidapi-key': AppConstants.apiKey
          },
          errorMessage: 'Failed to fetch locations');
      debugPrint(
          "Fetching placeID from: https://${AppConstants.apiHost}/location");

      final locationResult = await networkHelper.getData();

      if (locationResult != null && locationResult['locations'] != null) {
        final locationsList =
            List<Map<String, dynamic>>.from(locationResult['locations']);

        _locations =
            locationsList.map((loc) => TrendLocation.fromJson(loc)).toList();

        _locations.sort((a, b) => a.name.compareTo(b.name));

        await _cacheLocations();

        debugPrint('Fetched and cached ${_locations.length} locations');
      } else {
        throw Exception('API returned no locations');
      }
    } catch (e) {
      debugPrint('Error fetching fresh locations: $e');
    }
  }

  Future<void> _cacheLocations() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final cacheData = {
        'timestamp': DateTime.now().toIso8601String(),
        'locations': _locations.map((e) => e.toJson()).toList(),
      };

      await pref.setString(
          AppConstants.locationCacheKey, jsonEncode(cacheData));
      debugPrint('Locations cached successfully');
    } catch (e) {
      debugPrint('Error caching locations: $e');
    }
  }

  TrendLocation? findLocationByName(String name) {
    try {
      return _locations.firstWhere(
        (loc) => loc.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  TrendLocation? findLocationByPlaceID(String placeID) {
    try {
      return _locations.firstWhere(
        (loc) => loc.placeID == placeID,
      );
    } catch (e) {
      return null;
    }
  }

  List<TrendLocation> getLocationsByType(String locationType) {
    return _locations
        .where((loc) =>
            loc.locationType.toLowerCase() == locationType.toLowerCase())
        .toList();
  }
}
