import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtrends/platform/extensions/string_extensions.dart';
import 'package:xtrends/platform/utils/general_utils.dart';
import 'package:xtrends/ux/shared/components/app_page.dart';
import 'package:xtrends/ux/shared/models/ui_models.dart';
import 'package:xtrends/ux/shared/resources/app_strings.dart';
import 'package:xtrends/ux/view_models.dart/trends_view_model.dart';
import 'package:xtrends/ux/views/trends/components/trend_details_card.dart';

class TrendDetailsScreen extends StatelessWidget {
  const TrendDetailsScreen({super.key, required this.index})
      : savedTrend = null;

  const TrendDetailsScreen.fromSavedTrend({super.key, this.savedTrend})
      : index = null;

  final int? index;
  final SavedTrend? savedTrend;

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: AppStrings.trendDetails,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            if (savedTrend != null) ...[
              TrendDetailsCard(
                domain: savedTrend?.domain ?? '',
                rank: savedTrend?.rank ?? 0,
                trendName:
                    Utils.formatTrendName(trend: savedTrend?.trendName ?? ''),
                noOfTweets: savedTrend?.noOfTweets ?? '',
                tweetWebUrl: savedTrend?.tweetWebUrl ?? '',
                tweetMobileUrl: savedTrend?.tweetMobileUrl ?? '',
                savedAt: savedTrend?.savedAt,
              )
            ] else ...[
              Consumer<TrendsViewModel>(
                builder: (context, viewModel, _) {
                  final trend = viewModel.trends[index ?? 0];
                  return TrendDetailsCard(
                    domain: trend.domain,
                    rank: trend.rank,
                    trendName: Utils.formatTrendName(trend: trend.trendName),
                    noOfTweets:
                        '${StringExtension.toTweetCount(trend.postCount)} Tweets',
                    tweetWebUrl: trend.webUrl,
                    tweetMobileUrl: trend.mobileIntent,
                  );
                },
              ),
            ]
          ],
        ),
      ),
    );
  }
}
