import 'package:intl/intl.dart';

class StringExtension {
  StringExtension._();

  static String toTweetCount(int? count) {
    if (count == null || count == 0) return "0";
    return NumberFormat('#,###').format(count);
  }
}
