import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xtrends/ux/services/location_service.dart';
import 'package:xtrends/ux/services/networking.dart';
import 'package:xtrends/ux/shared/resources/app_constants.dart';

class TrendsRepository {
  Future<int> fetchWOEID() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final country = await LocationService().getCountryName();

      //Check cache first
      final cachedData = pref.get(AppConstants.woeidCacheKey);
      if (cachedData != null) {
        final cachedMap =
            jsonDecode(cachedData as String) as Map<String, dynamic>;
        if (cachedMap.containsKey(country)) {
          return cachedMap[country];
        }
      }

      //If not cached, fetch from API
      NetworkHelper networkHelper = NetworkHelper(
          url: AppConstants.apiHost ?? '',
          path: '/locations',
          headers: {
            'x-rapidapi-host': AppConstants.apiHost,
            'x-rapidapi-key': AppConstants.apiKey
          },
          errorMessage: 'Failed to fetch trends');

      final locationResult = await networkHelper.getData();

      final locations = jsonDecode(locationResult.body);

      final location = locations.firtWhere(
        (loc) => loc['country'] == country,
        orElse: () => {'woeid': 1},
      );
      final woeid = location['woeid'];

      final newCache = cachedData != null
          ? jsonDecode(cachedData as String) as Map<String, dynamic>
          : <String, dynamic>{};

      newCache[country ?? ''] = woeid;
      await pref.setString(AppConstants.woeidCacheKey, jsonEncode(newCache));

      return woeid;
    } catch (e) {
      debugPrint("Error fetching WOEID: $e");
      return 1;
    }
  }
}
