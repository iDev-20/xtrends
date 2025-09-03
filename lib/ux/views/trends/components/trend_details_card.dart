import 'package:flutter/material.dart';
import 'package:xtrends/ux/shared/components/app_material.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';
import 'package:xtrends/ux/shared/resources/app_images.dart';
import 'package:xtrends/ux/shared/resources/app_strings.dart';

class TrendDetailsCard extends StatelessWidget {
  const TrendDetailsCard(
      {super.key,
      required this.header,
      required this.rank,
      required this.trendName,
      required this.noOfTweets,
      required this.tweetUrl});

  final String header;
  final int rank;
  final String trendName;
  final String noOfTweets;
  final String tweetUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                header,
                style: const TextStyle(
                    color: AppColors.grey250, fontWeight: FontWeight.w600),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    AppImages.svgRankIcon,
                    const SizedBox(width: 8),
                    Text(
                      'Rank $rank',
                      style: const TextStyle(
                          color: AppColors.darkBlueText,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '#$trendName',
            style: const TextStyle(
                color: AppColors.darkBlueText,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            noOfTweets,
            style: const TextStyle(
                color: AppColors.grey400, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            tweetUrl,
            style: const TextStyle(
                color: AppColors.darkBlueText, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              TrendDetailActionButton(
                icon: const Icon(
                  Icons.copy_rounded,
                  color: AppColors.darkBlue,
                  size: 20,
                ),
                action: AppStrings.copy,
                onTap: () {},
              ),
              const SizedBox(width: 10),
              TrendDetailActionButton(
                icon: const Icon(
                  Icons.star_border_rounded,
                  color: AppColors.gold,
                  size: 20,
                ),
                action: AppStrings.save,
                onTap: () {},
              ),
              const SizedBox(width: 10),
              TrendDetailActionButton(
                icon: SizedBox(
                  height: 20,
                  width: 20,
                  child: Image(image: AppImages.xLogo),
                ),
                action: AppStrings.open,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TrendDetailActionButton extends StatelessWidget {
  const TrendDetailActionButton(
      {super.key,
      required this.icon,
      required this.action,
      required this.onTap});

  final Widget icon;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppMaterial(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(8),
        inkwellBorderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              Text(
                action,
                style: const TextStyle(
                    color: AppColors.darkBlueText, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
