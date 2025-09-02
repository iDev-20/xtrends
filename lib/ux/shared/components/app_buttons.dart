import 'package:flutter/material.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';

class CustomAppButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final Color? overlayColor;
  final bool enabled;
  final EdgeInsets? contentPadding;
  final bool expand;

  const CustomAppButton({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor = AppColors.primaryColor,
    this.foregroundColor = AppColors.white,
    this.borderColor = AppColors.transparent,
    this.overlayColor,
    this.enabled = true,
    this.expand = true,
    this.contentPadding,
  });

  ButtonStyle getStyle() {
    return ButtonStyle(
      fixedSize: MaterialStateProperty.all(
        const Size.fromHeight(58),
      ),
      enableFeedback: true,
      overlayColor: MaterialStateColor.resolveWith((states) =>
          overlayColor ?? AppColors.backgroundGrey.withOpacity(0.2)),
      padding: MaterialStateProperty.all(
        contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14.5),
      ),
      textStyle: MaterialStateProperty.all(
        const TextStyle(
            color: AppColors.white,
            fontFamily: 'PlusJakartaSans',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 1.5),
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: borderColor,
          ),
        ),
      ),
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.grey200;
        }
        return backgroundColor;
      }),
      foregroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.white;
        }
        return foregroundColor;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        expand
            ? Expanded(
                child: TextButton(
                    style: getStyle(),
                    onPressed: enabled
                        ? () {
                            onTap?.call();
                          }
                        : null,
                    child: child),
              )
            : TextButton(
                style: getStyle(),
                onPressed: enabled
                    ? () {
                        onTap?.call();
                      }
                    : null,
                child: child)
      ],
    );
  }
}

class CustomAppOutlinedButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final Color? overlayColor;
  final bool enabled;
  final EdgeInsets? contentPadding;
  final bool expand;

  const CustomAppOutlinedButton({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor = AppColors.white,
    this.foregroundColor = AppColors.primaryColor,
    this.borderColor = AppColors.primaryColor,
    this.overlayColor,
    this.enabled = true,
    this.expand = true,
    this.contentPadding,
  });

  ButtonStyle getStyle() {
    return ButtonStyle(
      fixedSize: MaterialStateProperty.all(
        const Size.fromHeight(58),
      ),
      enableFeedback: true,
      overlayColor: MaterialStateColor.resolveWith((states) =>
          overlayColor ?? AppColors.backgroundGrey.withOpacity(0.2)),
      padding: MaterialStateProperty.all(
        contentPadding ??
            const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
      ),
      textStyle: MaterialStateProperty.all(
        const TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: borderColor,
          ),
        ),
      ),
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.grey200;
        }
        return backgroundColor;
      }),
      foregroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.white;
        }
        return foregroundColor;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        expand
            ? Expanded(
                child: TextButton(
                    style: getStyle(),
                    onPressed: enabled
                        ? () {
                            onTap?.call();
                          }
                        : null,
                    child: child),
              )
            : TextButton(
                style: getStyle(),
                onPressed: enabled
                    ? () {
                        onTap?.call();
                      }
                    : null,
                child: child)
      ],
    );
  }
}
