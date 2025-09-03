import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xtrends/ux/shared/resources/app_constants.dart';

class UserNameViewModel extends ChangeNotifier {
  String firstName = '';

  void updateFirstName(String value) {
    firstName = value;
    notifyListeners();
  }

  void saveFirstNameToCache() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(AppConstants.firstNameKey, firstName);
  }

  bool get isButtonEnabled => firstName.isNotEmpty;
}
