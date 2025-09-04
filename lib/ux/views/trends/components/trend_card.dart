import 'package:flutter/material.dart';
import 'package:xtrends/ux/navigation/navigation.dart';
import 'package:xtrends/ux/shared/components/app_material.dart';
import 'package:xtrends/ux/shared/components/icon_box.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';
import 'package:xtrends/ux/views/trends/trend_details_screen.dart';

class TrendCard extends StatelessWidget {
  const TrendCard(
      {super.key,
      required this.index,
      required this.trend,
      required this.noOfTweets});

  final int index;
  final String trend;
  final String noOfTweets;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppMaterial(
        elevation: 0.5,
        borderRadius: BorderRadius.circular(12),
        inkwellBorderRadius: BorderRadius.circular(12),
        color: AppColors.white,
        onTap: () {
          Navigation.navigateToScreen(
              context: context, screen: TrendDetailsScreen(index: index));
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                (index + 1).toString(),
                style: const TextStyle(
                    color: AppColors.grey250,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trend,
                      style: const TextStyle(
                          color: AppColors.darkBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      noOfTweets,
                      style: const TextStyle(color: AppColors.grey300),
                    ),
                  ],
                ),
              ),
              const IconBox(
                icon: Text(
                  '#',
                  style: TextStyle(color: AppColors.darkBlueText, fontSize: 20),
                ),
                backgroundColor: AppColors.primary50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
