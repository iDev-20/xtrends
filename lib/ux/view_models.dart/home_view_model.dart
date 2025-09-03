import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xtrends/ux/shared/resources/app_constants.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required this.pref});

  final SharedPreferences pref;

  String get firstName => pref.getString(AppConstants.firstNameKey) ?? '';
}
