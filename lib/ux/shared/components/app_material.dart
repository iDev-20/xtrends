import 'package:flutter/material.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';

class AppMaterial extends StatelessWidget {
  const AppMaterial(
      {super.key,
      required this.child,
      this.color,
      this.onTap,
      this.elevation,
      this.borderRadius,
      this.inkwellBorderRadius,
      this.customBorder,
      this.overlayColor});

  final Widget child;
  final Color? color;
  final VoidCallback? onTap;
  final double? elevation;
  final BorderRadiusGeometry? borderRadius;
  final BorderRadius? inkwellBorderRadius;
  final ShapeBorder? customBorder;
  final Color? overlayColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? AppColors.transparent,
      elevation: elevation ?? 0,
      borderRadius: borderRadius,
      shadowColor: AppColors.shadowColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: inkwellBorderRadius,
        customBorder: customBorder,
        overlayColor: MaterialStateColor.resolveWith(
            (states) => overlayColor ?? AppColors.grey.withOpacity(0.3)),
        child: child,
      ),
    );
  }
}
