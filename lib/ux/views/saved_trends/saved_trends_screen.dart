import 'package:flutter/material.dart';
import 'package:xtrends/ux/shared/components/app_page.dart';
import 'package:xtrends/ux/shared/resources/app_strings.dart';
import 'package:xtrends/ux/views/saved_trends/components/saved_trend_card.dart';

class SavedTrendsScreen extends StatelessWidget {
  const SavedTrendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      hideAppBar: true,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return const SavedTrendCard(
            trend: AppStrings.techTuesday,
            trendLocation: AppStrings.sampleTrendLocation,
          );
        },
      ),
    );
  }
}
