import 'package:flutter/material.dart';
import 'package:xtrends/ux/shared/resources/app_strings.dart';
import 'package:xtrends/ux/views/trends/components/trend_card.dart';

class TrendsScreen extends StatefulWidget {
  const TrendsScreen({super.key});

  @override
  State<TrendsScreen> createState() => _TrendsScreenState();
}

class _TrendsScreenState extends State<TrendsScreen> {
  final int index = 1;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 7,
      itemBuilder: (context, index) {
        return TrendCard(
          index: index,
          trend: AppStrings.futureOfAI,
          noOfTweets: AppStrings.sampleTweetNo,
        );
      },
    );
  }
}
