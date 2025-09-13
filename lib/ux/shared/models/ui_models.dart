import 'package:flutter_svg/svg.dart';

class Carousel {
  final SvgPicture image;
  final String title;
  final String subtitle;

  Carousel({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

class AboutItem {
  final SvgPicture icon;
  final String title;
  final String detail;

  AboutItem({required this.icon, required this.title, required this.detail});
}

class TrendLocation {
  final String name;
  final String placeID;
  final String locationType;

  TrendLocation({
    required this.name,
    required this.placeID,
    required this.locationType,
  });

  factory TrendLocation.fromJson(Map<String, dynamic> json) {
    return TrendLocation(
      name: json['name'] ?? '',
      placeID: json['placeID'] ?? '',
      locationType: json['locationType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'placeID': placeID,
      'locationType': locationType,
    };
  }
}

class Trend {
  final String trendName;
  final String domain;
  final int postCount;
  final int rank;
  final String mobileIntent;
  final String webUrl;

  Trend({
    required this.trendName,
    required this.domain,
    required this.postCount,
    required this.rank,
    required this.mobileIntent,
    required this.webUrl,
  });

  factory Trend.fromJson(Map<String, dynamic> json) {
    return Trend(
      trendName: json['name'] ?? '',
      domain: json['domain'] ?? '',
      postCount: json['postCount'] ?? 0,
      rank: json['rank'] ?? 0,
      mobileIntent: json['mobileIntent'] ?? '',
      webUrl: json['webUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': trendName,
      'domain': domain,
      'postCount': postCount,
      'rank': rank,
      'mobileIntent': mobileIntent,
      'webUrl': webUrl,
    };
  }
}

class TrendingResponse {
  final String status;
  final String message;
  final String name;
  final String placeId;
  final String locationType;
  final List<Trend> trends;

  TrendingResponse({
    required this.status,
    required this.message,
    required this.name,
    required this.placeId,
    required this.locationType,
    required this.trends,
  });

  factory TrendingResponse.fromJson(Map<String, dynamic> json) {
    final trending = json['trending'] ?? {};
    final trendsList = (trending['trends'] as List? ?? [])
        .map((e) => Trend.fromJson(e))
        .toList();

    return TrendingResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      name: trending['name'] ?? '',
      placeId: trending['placeID'] ?? '',
      locationType: trending['locationType'] ?? '',
      trends: trendsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'trending': {
        'name': name,
        'placeID': placeId,
        'locationType': locationType,
        'trends': trends.map((trend) => trend.toJson()).toList(),
      }
    };
  }
}

class SavedTrend {
  final String id;
  final String trendName;
  final String domain;
  final String country;
  final int rank;
  final String noOfTweets;
  final String tweetWebUrl;
  final String tweetMobileUrl;
  final DateTime savedAt;

  SavedTrend({
    required this.id,
    required this.trendName,
    required this.domain,
    required this.country,
    required this.rank,
    required this.noOfTweets,
    required this.tweetWebUrl,
    required this.tweetMobileUrl,
    required this.savedAt,
  });

  factory SavedTrend.fromJson(Map<String, dynamic> json) {
    return SavedTrend(
      id: json['id'] ?? '',
      trendName: json['trendName'] ?? '',
      domain: json['domain'] ?? '',
      country: json['country'] ?? '',
      rank: json['rank'] ?? 0,
      noOfTweets: json['noOfTweets'] ?? '',
      tweetWebUrl: json['tweetWebUrl'] ?? '',
      tweetMobileUrl: json['tweetMobileUrl'] ?? '',
      savedAt:
          DateTime.parse(json['savedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'domain': domain,
      'country': country,
      'rank': rank,
      'trendName': trendName,
      'noOfTweets': noOfTweets,
      'tweetWebUrl': tweetWebUrl,
      'tweetMobileUrl': tweetMobileUrl,
      'savedAt': savedAt.toIso8601String(),
    };
  }

  static String generateId(String trendName, String domain) {
    return '${trendName.toLowerCase()}_${domain.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  String toString() {
    return 'SavedTrend(id: $id, trendName: $trendName, domain: $domain, '
        'country: $country, rank: $rank, noOfTweets: $noOfTweets, '
        'tweetWebUrl: $tweetWebUrl, tweetMobileUrl: $tweetMobileUrl, '
        'savedAt: $savedAt)';
  }
}
