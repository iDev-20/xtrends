import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:xtrends/ux/shared/components/app_form_fields.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';
import 'package:xtrends/ux/shared/resources/app_images.dart';
import 'package:xtrends/ux/shared/resources/app_strings.dart';
import 'package:xtrends/ux/view_models.dart/home_view_model.dart';
import 'package:xtrends/ux/view_models.dart/location_view_model.dart';
import 'package:xtrends/ux/view_models.dart/trends_view_model.dart';

class HomeGreetingCard extends StatefulWidget {
  const HomeGreetingCard({super.key});

  @override
  State<HomeGreetingCard> createState() => _HomeGreetingCardState();
}

class _HomeGreetingCardState extends State<HomeGreetingCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationViewModel>().fetchLocations();
    });
  }

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
                Consumer<LocationViewModel>(
                  builder: (context, locationViewModel, _) {
                    final locations = locationViewModel.locations;
                    return CustomSearchTextFormField(
                      hintText: 'Search country',
                      suggestions: locations
                          .map((location) => SearchFieldListItem<String>(
                              location.name,
                              item: location.name))
                          .toList(),
                      onSuggestionTap: (suggestion) async {
                        vm.setLocation(suggestion.searchKey);
                        await trendsVM.fetchTrends(
                            country: suggestion.searchKey);
                      },
                      onSubmit: (value) async {
                        vm.setLocation(value);
                        await trendsVM.fetchTrends(country: value);
                      },
                    );
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
