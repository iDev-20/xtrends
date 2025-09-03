import 'package:flutter/material.dart';
import 'package:xtrends/ux/shared/components/app_page.dart';
import 'package:xtrends/ux/shared/resources/app_strings.dart';
import 'package:xtrends/ux/views/trends/components/trend_details_card.dart';

class TrendDetailsScreen extends StatelessWidget {
  const TrendDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPage(
      title: AppStrings.trendDetails,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            TrendDetailsCard(
              header: '1. Trending in Politics',
              rank: 1,
              trendName: AppStrings.futureOfAI,
              noOfTweets: AppStrings.sampleTweetNo,
              tweetUrl: AppStrings.sampleTweetURL,
            ),
          ],
        ),
      ),
    );
  }
}
