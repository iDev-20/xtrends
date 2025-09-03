import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  AppConstants._();

  static const firstNameKey = 'first.name';
  static const firstTimeKey = 'first.time';
  static final apiKey = dotenv.env['RAPIDAPI_KEY'];
  static final apiHost = dotenv.env['RAPIDAPI_KEY'];
  static const woeidCacheKey = 'woeid.cache';
  static const locationKey = 'location';
}
