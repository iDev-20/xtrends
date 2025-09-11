import 'package:flutter/material.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor)),
          if (message != null) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Text(
                message ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.darkBlueText, fontWeight: FontWeight.w500),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
