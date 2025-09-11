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
    setLoadingState(true);

    try {
      final cachedLocations = await tryLoadFromCache();

      if (cachedLocations != null) {
        updateLocations(cachedLocations);
        return;
      }

      await fetchAndCacheLocations();
    } catch (e) {
      handleFetchError(e);
    }
  }

  void setLoadingState(bool loading) {
    _loading = true;
    _errorMessage = null;
    notifyListeners();
  }

  Future<List<TrendLocation>?> tryLoadFromCache() async {
    final cachedData = await getCachedData();

    if (cachedData == null) {
      debugPrint('No cached data found');
      return null;
    }

    if (isCachedExpired(cachedData)) {
      debugPrint('Cache expired');
      return null;
    }

    final locations = parseCachedLocations(cachedData);
    debugPrint('Loaded ${locations.length} locations from cache');
    return locations;
  }

  Future<Map<String, dynamic>?> getCachedData() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final cachedDataString = pref.getString(AppConstants.locationCacheKey);

      return cachedDataString != null
          ? jsonDecode(cachedDataString) as Map<String, dynamic>
          : null;
    } catch (e) {
      debugPrint('Error reading cache: $e');
      return null;
    }
  }

  bool isCachedExpired(Map<String, dynamic> cachedData) {
    try {
      final lastFetched = DateTime.parse(cachedData['timestamp']);
      final cacheAge = DateTime.now().difference(lastFetched);
      return cacheAge.inDays >= _cacheValidityDays;
    } catch (e) {
      debugPrint('Error parsing cache timestamp: $e');
      return true;
    }
  }

  List<TrendLocation> parseCachedLocations(Map<String, dynamic> cachedData) {
    try {
      return (cachedData['locations'] as List)
          .map((json) => TrendLocation.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error parsing cached locations: $e');
      return [];
    }
  }

  Future<void> fetchAndCacheLocations() async {
    final locations = await fetchLocationsFromAPI();

    if (locations.isNotEmpty) {
      final sortedLocations = sortLocationsByName(locations);
      updateLocations(sortedLocations);
      await cacheLocations(sortedLocations);
      debugPrint('Fetched and cached ${sortedLocations.length} locations');
    } else {
      throw Exception('No locations received from API');
    }
  }

  Future<List<TrendLocation>> fetchLocationsFromAPI() async {
    final netwoekHelper = createNetworkHelper();
    debugPrint(
        'Fetching locations from: https://${AppConstants.apiHost}/locations');

    final result = await netwoekHelper.getData();
    return parseAPIResponse(result);
  }

  NetworkHelper createNetworkHelper() {
    return NetworkHelper(
        url: AppConstants.apiHost ?? '',
        path: '/locations',
        headers: buildAPIHeaders(),
        errorMessage: 'Failed to fetch locations');
  }

  Map<String, dynamic> buildAPIHeaders() {
    return {
      'x-rapidapi-host': AppConstants.apiHost,
      'x-rapidapi-key': AppConstants.apiKey
    };
  }

  List<TrendLocation> parseAPIResponse(dynamic result) {
    if (result?['locations'] == null) {
      debugPrint('API returned null or invalid response');
      return [];
    }

    try {
      final locationsList =
          List<Map<String, dynamic>>.from(result['locations']);
      return locationsList.map((loc) => TrendLocation.fromJson(loc)).toList();
    } catch (e) {
      debugPrint('Error parsing API response: $e');
      return [];
    }
  }

  List<TrendLocation> sortLocationsByName(List<TrendLocation> locations) {
    final sortedList = List<TrendLocation>.from(locations);
    sortedList.sort((a, b) => a.name.compareTo(b.name));
    return sortedList;
  }

  void updateLocations(List<TrendLocation> locations) {
    _locations = locations;
    _loading = false;
    notifyListeners();
  }

  Future<void> cacheLocations(List<TrendLocation> locations) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final cacheData = createCacheData(locations);

      await pref.setString(
          AppConstants.locationCacheKey, jsonEncode(cacheData));
      debugPrint('Locations cached successfully');
    } catch (e) {
      debugPrint('Error caching locations: $e');
    }
  }

  Map<String, dynamic> createCacheData(List<TrendLocation> locations) {
    return {
      'timestamp': DateTime.now().toIso8601String(),
      'locations': locations.map((e) => e.toJson()).toList(),
    };
  }

  void handleFetchError(dynamic error) {
    debugPrint('Error fetching locations: $error');
    _errorMessage = 'Failed to load locations';
    _locations = [];
    _loading = false;
    notifyListeners();
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

  // TrendLocation? findLocationByPlaceID(String placeID) {
  //   try {
  //     return _locations.firstWhere(
  //       (loc) => loc.placeID == placeID,
  //     );
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // List<TrendLocation> getLocationsByType(String locationType) {
  //   return _locations
  //       .where((loc) =>
  //           loc.locationType.toLowerCase() == locationType.toLowerCase())
  //       .toList();
  // }
}
