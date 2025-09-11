import 'package:flutter/material.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';

class SavedTrendsEmptyState extends StatelessWidget {
  const SavedTrendsEmptyState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star_border_rounded,
            size: 64,
            color: AppColors.grey300,
          ),
          SizedBox(height: 16),
          Text(
            'No saved trends yet',
            style: TextStyle(
              color: AppColors.grey300,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start saving trends to see them here',
            style: TextStyle(
              color: AppColors.grey400,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
