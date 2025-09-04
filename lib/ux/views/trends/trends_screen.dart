import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    return Consumer<TrendsViewModel>(
      builder: (context, viewModel, _) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: viewModel.trends.length,
          itemBuilder: (context, index) {
            final trend = viewModel.trends[index];
            return TrendCard(
              index: index + 1,
              trend: trend.trendName,
              noOfTweets: '${trend.postCount} Tweets',
            );
          },
        );
      },
    );
  }
}
