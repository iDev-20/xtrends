import 'package:flutter/material.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';

class SlideIndicator extends StatelessWidget {
  const SlideIndicator(
      {super.key, required this.selectedIndex, required this.slideList});

  final int selectedIndex;
  final List slideList;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 66,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: slideList.asMap().entries.map((entry) {
          return Container(
            width: selectedIndex == entry.key ? 20 : 7,
            height: 7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: selectedIndex == entry.key
                  ? AppColors.primaryColor
                  : AppColors.grey,
            ),
          );
        }).toList(),
      ),
    );
  }
}
