import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtrends/platform/utils/general_utils.dart';
import 'package:xtrends/ux/shared/components/app_material.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';
import 'package:xtrends/ux/shared/resources/app_images.dart';
import 'package:xtrends/ux/shared/resources/app_strings.dart';
import 'package:xtrends/ux/view_models.dart/saved_trends_view_model.dart';
import 'package:xtrends/ux/views/trends/components/trend_details_card.dart';

class TrendDetailsActionButtons extends StatefulWidget {
  const TrendDetailsActionButtons({super.key, required this.trendDetails});

  final TrendDetailsCard trendDetails;

  @override
  State<TrendDetailsActionButtons> createState() =>
      _TrendDetailsActionButtonsState();
}

class _TrendDetailsActionButtonsState extends State<TrendDetailsActionButtons> {
  bool isProcessing = false;
  Future<void> handleSaveAction(SavedTrendsViewModel viewModel) async {
    if (isProcessing) return;

    setState(() => isProcessing = true);

    try {
      final success = await viewModel.toggleTrendSaved(
        domain: widget.trendDetails.domain,
        rank: widget.trendDetails.rank,
        trendName: widget.trendDetails.trendName,
        noOfTweets: widget.trendDetails.noOfTweets,
        tweetWebUrl: widget.trendDetails.tweetWebUrl,
        tweetMobileUrl: widget.trendDetails.tweetMobileUrl,
      );

      if (!success) {
        showErrorMessage();
      }
    } catch (e) {
      debugPrint('Error toggling save state: $e');
      showErrorMessage();
    } finally {
      setState(() => isProcessing = false);
    }
  }

  void showErrorMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to update saved state'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SavedTrendsViewModel>(builder: (context, viewModel, _) {
      final isSaved = viewModel.isTrendSaved(
          widget.trendDetails.trendName, widget.trendDetails.domain);

      return Row(
        children: [
          ActionButton(
            icon: const Icon(
              Icons.copy_rounded,
              color: AppColors.darkBlue,
              size: 20,
            ),
            action: AppStrings.copy,
            onTap: () {
              final text = Utils.convertToX(widget.trendDetails.tweetWebUrl);
              Utils.copyText(text: text);
            },
          ),
          const SizedBox(width: 10),
          ActionButton(
            icon: Icon(
              isSaved ? Icons.star_rounded : Icons.star_border_rounded,
              color: AppColors.gold,
              size: 20,
            ),
            action: AppStrings.save,
            onTap: () {
              handleSaveAction(viewModel);
            },
          ),
          const SizedBox(width: 10),
          ActionButton(
            icon: SizedBox(
              height: 20,
              width: 20,
              child: Image(image: AppImages.xLogo),
            ),
            action: AppStrings.open,
            onTap: () async {
              await Utils.openUrl(url: widget.trendDetails.tweetMobileUrl);
            },
          ),
        ],
      );
    });
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton(
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
