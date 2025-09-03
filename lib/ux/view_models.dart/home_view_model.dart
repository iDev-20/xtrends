import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xtrends/ux/services/location_service.dart';
import 'package:xtrends/ux/shared/resources/app_constants.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required this.pref});

  final SharedPreferences pref;

  String get firstName => pref.getString(AppConstants.firstNameKey) ?? '';

  String? _currentLocation;

  String? get currentLocation => _currentLocation;

  Future<void> loadLocation() async {
    _currentLocation = pref.get(AppConstants.locationKey) as String?;

    final country = await LocationService().getCountryName();
    _currentLocation = country;

    await pref.setString(AppConstants.locationKey, country ?? '');
    notifyListeners();
  }
}
