import 'package:flutter/material.dart';
import 'package:xtrends/ux/navigation/navigation.dart';
import 'package:xtrends/ux/shared/components/app_material.dart';
import 'package:xtrends/ux/shared/components/icon_box.dart';
import 'package:xtrends/ux/shared/models/ui_models.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';
import 'package:xtrends/ux/shared/resources/app_images.dart';
import 'package:xtrends/ux/views/trends/trend_details_screen.dart';

class SavedTrendCard extends StatelessWidget {
  const SavedTrendCard({super.key, required this.savedTrend});

  final SavedTrend savedTrend;

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
              context: context,
              screen:
                  TrendDetailsScreen.fromSavedTrend(savedTrend: savedTrend));
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      savedTrend.trendName,
                      style: const TextStyle(
                          color: AppColors.darkBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        AppImages.svglocationIcon,
                        const SizedBox(width: 2),
                        Text(
                          savedTrend.country,
                          style: const TextStyle(color: AppColors.grey300),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const IconBox(
                backgroundColor: AppColors.primary50,
                icon: Icon(
                  Icons.star_rounded,
                  color: AppColors.gold,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
