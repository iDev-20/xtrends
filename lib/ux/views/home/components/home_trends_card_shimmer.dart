import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xtrends/ux/shared/components/app_material.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';

class HomeTrendsCardShimmer extends StatelessWidget {
  const HomeTrendsCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppMaterial(
      color: AppColors.white,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12),
      ),
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
