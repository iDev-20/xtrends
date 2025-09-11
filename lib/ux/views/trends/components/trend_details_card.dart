import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';
import 'package:xtrends/ux/shared/resources/app_images.dart';
import 'package:xtrends/ux/view_models.dart/saved_trends_view_model.dart';
import 'package:xtrends/ux/views/trends/components/trend_detail_action_buttons.dart';

class TrendDetailsCard extends StatefulWidget {
  const TrendDetailsCard({
    super.key,
    required this.domain,
    required this.rank,
    required this.trendName,
    required this.noOfTweets,
    required this.tweetWebUrl,
    required this.tweetMobileUrl,
    this.savedAt,
  });

  final String domain;
  final int rank;
  final String trendName;
  final String noOfTweets;
  final String tweetWebUrl;
  final String tweetMobileUrl;
  final DateTime? savedAt;

  @override
  State<TrendDetailsCard> createState() => _TrendDetailsCardState();
}

class _TrendDetailsCardState extends State<TrendDetailsCard> {
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.domain.isNotEmpty
                        ? 'Trending in ${widget.domain}'
                        : 'Trending now',
                    style: const TextStyle(
                        color: AppColors.grey250, fontWeight: FontWeight.w600),
                  ),
                  if (widget.savedAt != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      Provider.of<SavedTrendsViewModel>(context, listen: false)
                          .formatSavedTime(widget.savedAt ?? DateTime.now()),
                      style: const TextStyle(
                          color: AppColors.grey250,
                          fontSize: 13,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ],
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
                      'Rank ${widget.rank}',
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
          const SizedBox(height: 20),
          Text(
            widget.trendName,
            style: const TextStyle(
                color: AppColors.darkBlueText,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            widget.noOfTweets,
            style: const TextStyle(
                color: AppColors.grey400, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            widget.tweetWebUrl,
            style: const TextStyle(
                color: AppColors.darkBlueText, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          TrendDetailsActionButtons(trendDetails: widget),
        ],
      ),
    );
  }
}
