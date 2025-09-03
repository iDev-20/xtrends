import 'package:flutter/material.dart';
import 'package:xtrends/ux/shared/components/app_material.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';

class IconBox extends StatelessWidget {
  const IconBox({super.key, required this.icon, this.backgroundColor});

  final Widget icon;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AppMaterial(
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.grey100,
            shape: BoxShape.circle),
        child: icon,
      ),
    );
  }
}
