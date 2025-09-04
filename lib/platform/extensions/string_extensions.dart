import 'package:intl/intl.dart';

class StringExtension {
  StringExtension._();

  static String toTweetCount(int? count) {
    if (count == null || count == 0) return "N/A";
    return NumberFormat('#,###').format(count); // ✅ formats 1000 → 1,000
  }
}
