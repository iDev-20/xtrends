import 'package:flutter/material.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';
import 'package:xtrends/ux/shared/resources/app_images.dart';

class CustomAppDropDownField extends StatelessWidget {
  const CustomAppDropDownField(
      {super.key,
      this.items,
      this.stringItems = true,
      this.dropdownItems,
      this.onChanged,
      this.hintText,
      this.prefixWidget,
      this.fillColor,
      this.hasFill = false,
      this.validator,
      this.valueHolder,
      this.labelText,
      this.itemsIcon});

  final List<String>? items;
  final List<DropdownMenuItem<dynamic>>? dropdownItems;
  final bool stringItems;
  final void Function(dynamic)? onChanged;
  final String? Function(dynamic)? validator;
  final String? hintText;
  final String? labelText;
  final dynamic valueHolder;
  final Widget? prefixWidget;
  final Color? fillColor;
  final bool hasFill;
  final Widget? itemsIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: labelText != null,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              labelText ?? '',
              style: const TextStyle(
                  color: AppColors.black, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        DropdownButtonFormField<dynamic>(
          isExpanded: true,
          validator: validator,
          value: valueHolder,
          // icon: AppImages.svgDropdDownIcon,
          style: const TextStyle(
              fontFamily: 'Raleway',
              color: AppColors.black,
              overflow: TextOverflow.ellipsis),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.grey,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 17),
            hintText: hintText,
            hintStyle: const TextStyle(
                color: AppColors.grey200,
                fontSize: 14,
                fontWeight: FontWeight.w400),
            enabledBorder: inputBorder(),
            disabledBorder: inputBorder(),
            focusedBorder: inputBorder(),
            border: inputBorder(borderRadius: 4),
          ),
          items: stringItems == true
              ? (items ?? [])
                  .map(
                    (e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList()
              : (dropdownItems ?? []),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

InputBorder inputBorder({double? borderRadius}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius ?? 8),
    borderSide: const BorderSide(color: AppColors.transparent),
  );
}
