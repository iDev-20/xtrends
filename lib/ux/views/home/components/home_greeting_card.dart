import 'package:flutter/material.dart';
import 'package:xtrends/ux/shared/components/app_dropdown_field.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';
import 'package:xtrends/ux/shared/resources/app_images.dart';
import 'package:xtrends/ux/shared/resources/app_strings.dart';

class HomeGreetingCard extends StatelessWidget {
  const HomeGreetingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.hello,
                      style: TextStyle(color: AppColors.grey400),
                    ),
                    Text(
                      '${AppStrings.sampleAppUser}!',
                      style: TextStyle(
                          color: AppColors.darkBlueText,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                AppImages.svgGreetingIcon
              ],
            ),
            const SizedBox(height: 16),
            CustomAppDropDownField(
              labelText: AppStrings.selectLocation,
              valueHolder: 'Ghana',
              stringItems: true,
              items: const ['Ghana', 'United States', 'Nigeria'],
              onChanged: (p0) {},
            ),
          ],
        ),
      ),
    );
  }
}
