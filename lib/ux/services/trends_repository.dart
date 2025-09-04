import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xtrends/ux/services/location_service.dart';
import 'package:xtrends/ux/services/networking.dart';
import 'package:xtrends/ux/shared/resources/app_constants.dart';

class TrendsRepository {
  Future<String> fetchPlaceID({String? countryName}) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final country = countryName ?? await LocationService().getCountryName();

      if (country == null || country.isEmpty) {
        debugPrint("No country name found");
        return '';
      }

      //Check cache first
      final cachedData = pref.get(AppConstants.placeIDCacheKey);
      if (cachedData != null) {
        final cachedMap =
            jsonDecode(cachedData.toString()) as Map<String, dynamic>;
        if (cachedMap.containsKey(country)) {
          debugPrint("Place ID fetched from cache for $country");
          return cachedMap[country].toString();
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
          errorMessage: 'Failed to fetch placeID');

      // print("Fetching placeID from: https://${AppConstants.apiHost}/location");

      final locationResult = await networkHelper.getData();

      if (locationResult == null || locationResult['locations'] == null) {
        debugPrint("API returned no locations");
        return '';
      }
      final locations =
          List<Map<String, dynamic>>.from(locationResult['locations']);

      final location = locations.firstWhere(
        (loc) => loc['name'].toString().toLowerCase() == country.toLowerCase(),
        orElse: () => {},
      );
      final placeID = location['placeID']?.toString() ?? '';

      final newCache = cachedData != null
          ? jsonDecode(cachedData.toString()) as Map<String, dynamic>
          : <String, dynamic>{};

      newCache[country] = placeID;
      await pref.setString(AppConstants.placeIDCacheKey, jsonEncode(newCache));
      // print('country ==> $country');
      // print('placeId ==> $placeID');

      return placeID;
    } catch (e) {
      debugPrint("Error fetching placeID: $e");
      return 'error';
    }
  }
}
