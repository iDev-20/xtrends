import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xtrends/ux/services/location_service.dart';
import 'package:xtrends/ux/shared/resources/app_constants.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required this.pref});

  final SharedPreferences pref;

  String get firstName => pref.getString(AppConstants.firstNameKey) ?? '';

  String? _currentLocation;
  bool _loadingLocation = false;

  String? get currentLocation => _currentLocation;
  bool get isLoadingLocation => _loadingLocation;

  Future<void> loadLocation() async {
    if (_currentLocation != null) return;

    _loadingLocation = true;
    notifyListeners();

    try {
      _currentLocation = pref.get(AppConstants.locationKey) as String?;

      final country = await LocationService().getCountryName();
      if (country != null && country.isNotEmpty) {
        _currentLocation = country;
        await pref.setString(AppConstants.locationKey, country);
      }
    } catch (e) {
      debugPrint("Error loading location: $e");
    } finally {
      _loadingLocation = false;
      notifyListeners();
    }
  }

  void setLocation(String value) {
    _currentLocation = value;
    pref.setString(AppConstants.locationKey, value);
    notifyListeners();
  }
}
