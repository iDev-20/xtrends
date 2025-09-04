import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtrends/platform/extensions/string_extensions.dart';
import 'package:xtrends/ux/shared/components/app_page.dart';
import 'package:xtrends/ux/shared/resources/app_strings.dart';
import 'package:xtrends/ux/view_models.dart/trends_view_model.dart';
import 'package:xtrends/ux/views/trends/components/trend_details_card.dart';

class TrendDetailsScreen extends StatelessWidget {
  const TrendDetailsScreen({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: AppStrings.trendDetails,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Consumer<TrendsViewModel>(
              builder: (context, viewModel, _) {
                final trend = viewModel.trends[index];
                return TrendDetailsCard(
                  header: '${index + 1}. Trending in ${trend.domain}',
                  rank: trend.rank,
                  trendName: trend.trendName,
                  noOfTweets:
                      '${StringExtension.toTweetCount(trend.postCount)} Tweets',
                  tweetUrl: trend.webUrl,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
