import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xtrends/ux/services/location_service.dart';
import 'package:xtrends/ux/shared/resources/app_constants.dart';
import 'package:xtrends/ux/view_models.dart/trends_view_model.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required this.pref});

  final SharedPreferences pref;
  static const int locationCacheValidityHours = 24;

  String get firstName => pref.getString(AppConstants.firstNameKey) ?? '';

  String? _currentLocation;
  bool _loadingLocation = false;
  bool _isInitialLoad = true;
  bool isHardRefresh = false;

  String? get currentLocation => _currentLocation;
  bool get isLoadingLocation => _loadingLocation;
  bool get hasLocation =>
      _currentLocation != null && _currentLocation!.isNotEmpty;

  Future<void> loadLocation() async {
    await loadCachedLocation();

    await fetchFreshLocationIfNeeded();
  }

  Future<void> loadCachedLocation() async {
    try {
      final cachedLocation = pref.getString(AppConstants.locationKey);

      if (cachedLocation != null && cachedLocation.isNotEmpty) {
        _currentLocation = cachedLocation;
        debugPrint('Loaded cached location: $cachedLocation');

        if (_isInitialLoad) {
          _isInitialLoad = false;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint("Error loading cached location: $e");
    }
  }

  Future<void> fetchFreshLocationIfNeeded() async {
    if (!shouldFetchFreshLocation()) {
      debugPrint('Using cached location, no fresh fetch needed');
      return;
    }

    await fetchFreshLocation();
  }

  bool shouldFetchFreshLocation() {
    if (_currentLocation == null || _currentLocation!.isEmpty) {
      return true;
    }

    return isCacheExpired();
  }

  bool isCacheExpired() {
    try {
      final lastFetchTime = pref.getInt(AppConstants.lastLocationFetchKey);
      if (lastFetchTime == null) return true;

      final lastFetch = DateTime.fromMillisecondsSinceEpoch(lastFetchTime);
      final now = DateTime.now();
      final hourSinceLastFetch = now.difference(lastFetch).inHours;

      return hourSinceLastFetch >= locationCacheValidityHours;
    } catch (e) {
      debugPrint('Error checking cache expiry: $e');
      return true;
    }
  }

  Future<void> fetchFreshLocation() async {
    setLoadingState(true);

    try {
      debugPrint('Fetching fresh location...');
      final freshLocation = await LocationService().getCountryName();

      await handleFreshLocation(freshLocation);
    } catch (e) {
      debugPrint('Error fetching fresh location: $e');
    } finally {
      setLoadingState(false);
    }
  }

  Future<void> handleFreshLocation(String? freshLocation) async {
    if (freshLocation == null || freshLocation.isEmpty) {
      debugPrint('Fresh location is null/empty, keeping cached location');
      return;
    }

    if (_currentLocation != freshLocation) {
      debugPrint(
          'Location updated from "$_currentLocation" to "$freshLocation"');
      await updateLocation(freshLocation);
    } else {
      debugPrint('Fresh Location same as cached, updating timestamp only');
      await updateLastFetchTime();
    }
  }

  Future<void> updateLocation(String newLocation) async {
    _currentLocation = newLocation;

    await Future.wait([
      pref.setString(AppConstants.locationKey, newLocation),
      updateLastFetchTime(),
    ]);

    notifyListeners();
  }

  Future<void> updateLastFetchTime() async {
    await pref.setInt(AppConstants.lastLocationFetchKey,
        DateTime.now().millisecondsSinceEpoch);
  }

  void setLoadingState(bool loading) {
    _loadingLocation = loading;
    notifyListeners();
  }

  Future<void> refreshLocation() async {
    debugPrint('Force refreshing location...');
    await fetchFreshLocation();
  }

  Future<void> setLocation(String value) async {
    if (_currentLocation == value) return;

    _currentLocation = value;

    await Future.wait([
      pref.setString(AppConstants.locationKey, value),
      updateLastFetchTime(),
    ]);

    notifyListeners();
    debugPrint('Location manually set to: $value');
  }

  Future<void> clearLocationCache() async {
    _currentLocation = null;
    _isInitialLoad = true;

    await Future.wait([
      pref.remove(AppConstants.locationKey),
      pref.remove(AppConstants.lastLocationFetchKey),
    ]);

    notifyListeners();
    debugPrint('Location cache cleared');
  }

  Map<String, dynamic> getCacheInfo() {
    final lastFetchTime = pref.getInt(AppConstants.lastLocationFetchKey);
    final cachedLocation = pref.getString(AppConstants.locationKey);

    return {
      'cachedLocation': cachedLocation,
      'lastFetchTime': lastFetchTime != null
          ? DateTime.fromMillisecondsSinceEpoch(lastFetchTime).toString()
          : 'Never',
      'cacheExpired': isCacheExpired(),
      'currenLocation': _currentLocation
    };
  }

  Future<void> onHardRefresh(TrendsViewModel viewModel) async {
    if (isHardRefresh) return;
    isHardRefresh = true;
    notifyListeners();

    try {
      await refreshLocation();
      if (hasLocation) {
        await viewModel.refreshTrends(country: currentLocation);
      }
    } catch (e) {
      debugPrint('Error during hard refresh $e');
    } finally {
      isHardRefresh = false;
      notifyListeners();
    }
  }
}
