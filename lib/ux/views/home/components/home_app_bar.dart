import 'package:flutter/material.dart';
import 'package:xtrends/ux/shared/components/icon_box.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';
import 'package:xtrends/ux/shared/resources/app_images.dart';
import 'package:xtrends/ux/shared/resources/app_strings.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.grey100),
        ),
      ),
      child: Row(
        children: [
          AppImages.svgTrendIconWithStar,
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              AppStrings.appName,
              style: TextStyle(
                  color: AppColors.darkBlueText,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          IconBox(icon: AppImages.svgSearchIcon),
          const SizedBox(width: 8),
          IconBox(icon: AppImages.svgRefreshIcon),
        ],
      ),
    );
  }
}
