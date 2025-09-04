import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtrends/ux/navigation/navigation.dart';
import 'package:xtrends/ux/shared/components/icon_box.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';
import 'package:xtrends/ux/shared/resources/app_images.dart';
import 'package:xtrends/ux/shared/resources/app_strings.dart';
import 'package:xtrends/ux/view_models.dart/home_view_model.dart';
import 'package:xtrends/ux/view_models.dart/trends_view_model.dart';
import 'package:xtrends/ux/views/home/search_screen.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final homeVM = Provider.of<HomeViewModel>(context, listen: false);
    final trendsVM = Provider.of<TrendsViewModel>(context, listen: false);
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
          IconBox(
            icon: AppImages.svgSearchIcon,
            onTap: () {
              Navigation.navigateToScreen(
                  context: context, screen: const SearchScreen());
            },
          ),
          const SizedBox(width: 8),
          IconBox(
            icon: AppImages.svgRefreshIcon,
            onTap: () async {
              homeVM.resetLocation();
              await homeVM.loadLocation();
              await trendsVM.fetchTrends();
            },
          ),
        ],
      ),
    );
  }
}
