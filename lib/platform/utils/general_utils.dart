import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static Future copyText({required String text}) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  static String convertToX(String url) {
    if (url.contains("twitter.com")) {
      return url.replaceFirst("twitter.com", "x.com");
    }
    return url;
  }

  static Future<void> openUrl({required String url}) async {
    try {
      final fixedUrl = url.replaceAll('twitter.com', 'x.com');

      final isTwitter =
          fixedUrl.contains('x.com') || fixedUrl.contains('twitter.com');
      Uri? appUri;

      if (isTwitter) {
        final path = fixedUrl.split('.com').last;
        appUri = Uri.parse("twitter://$path");
      }

      if (appUri != null && await canLaunchUrl(appUri)) {
        await launchUrl(appUri, mode: LaunchMode.externalApplication);
        return;
      }

      final webUri =
          Uri.tryParse(fixedUrl) ?? Uri.parse(Uri.encodeFull(fixedUrl));
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $fixedUrl';
      }
    } catch (e) {
      debugPrint('Error opening URL: $e');
      rethrow;
    }
  }

  static String formatTrendName({required String trend}) {
    if (trend.trim().startsWith('#')) {
      return trend.trim();
    }
    return '#${trend.trim()}';
  }
}
