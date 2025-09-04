import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtrends/platform/utils/general_utils.dart';
import 'package:xtrends/ux/navigation/navigation.dart';
import 'package:xtrends/ux/shared/components/app_material.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';
import 'package:xtrends/ux/shared/resources/app_strings.dart';
import 'package:xtrends/ux/view_models.dart/home_view_model.dart';
import 'package:xtrends/ux/view_models.dart/trends_view_model.dart';
import 'package:xtrends/ux/views/trends/trend_details_screen.dart';

class HomeTrendingWidget extends StatelessWidget {
  const HomeTrendingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    final location = viewModel.currentLocation ?? '';
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '${AppStrings.trendingIn} ${location.isNotEmpty ? location : 'your area'}',
              style: const TextStyle(
                  color: AppColors.darkBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Consumer<TrendsViewModel>(builder: (context, vm, _) {
            if (vm.isLoading) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              );
            }

            if (vm.trends.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  location.isEmpty
                      ? 'We couldn’t detect your location.'
                      : 'No trending topics found for $location.',
                  style: const TextStyle(
                    color: AppColors.grey300,
                    fontSize: 14,
                  ),
                ),
              );
            }

            final topTrends = vm.trends.take(10).toList();
            return Column(
              children: List.generate(
                topTrends.length,
                (i) {
                  final trend = vm.trends[i];
                  return HomeTrendsCard(
                    index: i,
                    category: trend.domain,
                    trend: Utils.formatTrendName(trend: trend.trendName),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

class HomeTrendsCard extends StatelessWidget {
  const HomeTrendsCard(
      {super.key,
      required this.index,
      required this.category,
      required this.trend});

  final int index;
  final String category;
  final String trend;

  @override
  Widget build(BuildContext context) {
    return AppMaterial(
      color: AppColors.white,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12),
      ),
      inkwellBorderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12),
      ),
      onTap: () {
        Navigation.navigateToScreen(
            context: context, screen: TrendDetailsScreen(index: index));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.grey100, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Text(
              (index + 1).toString(),
              style: const TextStyle(
                color: AppColors.grey250,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      color: AppColors.grey300,
                    ),
                  ),
                  Text(
                    trend,
                    style: const TextStyle(
                      color: AppColors.darkBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.grey200)
          ],
        ),
      ),
    );
  }
}
