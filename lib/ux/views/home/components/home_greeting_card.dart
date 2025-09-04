import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtrends/ux/shared/components/app_dropdown_field.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';
import 'package:xtrends/ux/shared/resources/app_images.dart';
import 'package:xtrends/ux/shared/resources/app_strings.dart';
import 'package:xtrends/ux/view_models.dart/home_view_model.dart';
import 'package:xtrends/ux/view_models.dart/trends_view_model.dart';

class HomeGreetingCard extends StatefulWidget {
  const HomeGreetingCard({super.key});

  @override
  State<HomeGreetingCard> createState() => _HomeGreetingCardState();
}

class _HomeGreetingCardState extends State<HomeGreetingCard> {
  static const supportedCountries = ['Ghana', 'United States', 'Nigeria'];

  @override
  Widget build(BuildContext context) {
    final trendsVM = Provider.of<TrendsViewModel>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Consumer<HomeViewModel>(
          builder: (context, vm, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          AppStrings.hello,
                          style: TextStyle(color: AppColors.grey400),
                        ),
                        Text(
                          '${vm.firstName}!',
                          style: const TextStyle(
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
                  valueHolder: supportedCountries.contains(vm.currentLocation)
                      ? vm.currentLocation
                      : null,
                  stringItems: true,
                  items: supportedCountries,
                  onChanged: (value) async {
                    if (value == null) return;
                    vm.setLocation(value);
                    await trendsVM.fetchTrends(country: value);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
