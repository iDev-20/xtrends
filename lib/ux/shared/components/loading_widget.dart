import 'package:flutter/material.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(color: AppColors.primaryColor),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 70),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: AppColors.darkBlueText, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
