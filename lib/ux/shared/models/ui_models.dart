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
  final String country;
  final String name;
  final int woeid;

  TrendLocation({
    required this.country,
    required this.name,
    required this.woeid,
  });

  factory TrendLocation.fromJson(Map<String, dynamic> json) {
    return TrendLocation(
      country: json['country'] ?? '',
      name: json['name'] ?? '',
      woeid: json['woeid'] ?? 1,
    );
  }
}

class Trend {
  final String trendName;
  final String domain;
  final int postCount;
  final int tweetVolume;
  final int rank;
  final String mobileIntent;
  final String webUrl;

  Trend({
    required this.trendName,
    required this.domain,
    required this.postCount,
    required this.tweetVolume,
    required this.rank,
    required this.mobileIntent,
    required this.webUrl,
  });

  factory Trend.fromJson(Map<String, dynamic> json) {
    return Trend(
      trendName: json['name'] ?? '',
      domain: json['domain'] ?? '',
      postCount: json['postCount'] ?? 0,
      tweetVolume: json['tweet_volume'] ?? 0,
      rank: json['rank'] ?? 0,
      mobileIntent: json['mobileIntent'] ?? '',
      webUrl: json['webUrl'] ?? '',
    );
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
}
