import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xtrends/ux/shared/components/app_material.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';

class TrendsCardShimmer extends StatelessWidget {
  const TrendsCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppMaterial(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.grey100, width: 0.5),
            ),
          ),
          child: Shimmer.fromColors(
            baseColor: AppColors.grey100,
            highlightColor: Colors.white10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                shimmerContainer(height: 12, width: 80),
                const SizedBox(height: 8),
                shimmerContainer(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container shimmerContainer({required double height, double? width}) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
