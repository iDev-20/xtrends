import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtrends/platform/extensions/string_extensions.dart';
import 'package:xtrends/platform/utils/general_utils.dart';
import 'package:xtrends/ux/shared/components/loading_widget.dart';
import 'package:xtrends/ux/view_models.dart/home_view_model.dart';
import 'package:xtrends/ux/view_models.dart/trends_view_model.dart';
import 'package:xtrends/ux/views/trends/components/trend_card.dart';

class TrendsScreen extends StatefulWidget {
  const TrendsScreen({super.key});

  @override
  State<TrendsScreen> createState() => _TrendsScreenState();
}

class _TrendsScreenState extends State<TrendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeViewModel, TrendsViewModel>(
      builder: (context, homeVM, viewModel, _) {
        if (homeVM.isLoadingLocation || viewModel.isLoading) {
          return const LoadingWidget(
              message: 'Fetching latest trends for your location...');
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: viewModel.trends.length,
          itemBuilder: (context, index) {
            final trend = viewModel.trends[index];
            return TrendCard(
              index: index,
              trend: Utils.formatTrendName(trend: trend.trendName),
              noOfTweets:
                  '${StringExtension.toTweetCount(trend.postCount)} Tweets',
            );
          },
        );
      },
    );
  }
}
