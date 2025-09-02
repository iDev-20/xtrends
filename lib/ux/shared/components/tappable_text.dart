import 'package:flutter/material.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';

class TappableText extends StatelessWidget {
  const TappableText(
      {super.key, required this.text, required this.onTap, this.textStyle});

  final String text;
  final VoidCallback onTap;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: textStyle ??
            const TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500),
      ),
    );
  }
}
