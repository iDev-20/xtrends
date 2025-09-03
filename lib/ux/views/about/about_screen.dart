import 'package:flutter/material.dart';
import 'package:xtrends/ux/model/ui_models.dart';
import 'package:xtrends/ux/shared/components/app_page.dart';
import 'package:xtrends/ux/shared/resources/app_images.dart';
import 'package:xtrends/ux/shared/resources/app_strings.dart';
import 'package:xtrends/ux/views/about/components/about_card.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static List<AboutItem> items = [
    AboutItem(
        icon: AppImages.svgCircleQuestioMark,
        title: AppStrings.whatsTrending,
        detail: AppStrings.whatsTrendingDetails),
    AboutItem(
        icon: AppImages.svgHowItWorksIcon,
        title: AppStrings.howItWorks,
        detail: AppStrings.howItWorksDetails),
    AboutItem(
        icon: AppImages.svgPrivacyIcon,
        title: AppStrings.privacy,
        detail: AppStrings.privacyDetails),
  ];

  @override
  Widget build(BuildContext context) {
    return AppPage(
      hideAppBar: true,
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemCount: 3,
        itemBuilder: (context, index) {
          final item = items[index];
          return AboutCard(item: item);
        },
      ),
    );
  }
}
