import 'package:shared_preferences/shared_preferences.dart';
import 'package:xtrends/ux/shared/resources/app_constants.dart';

class SharedPref {
  static Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.firstTimeKey) ?? true;
  }

  static Future<void> setOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.firstTimeKey, false);
  }
}
