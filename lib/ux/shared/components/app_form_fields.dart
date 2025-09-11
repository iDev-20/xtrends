import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:searchfield/searchfield.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';
import 'package:xtrends/ux/shared/resources/app_images.dart';
import 'package:xtrends/ux/shared/resources/app_strings.dart';

class CustomAppTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;
  final int? maxLength;
  final bool? obscureText;
  final bool optional;
  final bool autofocus;
  final bool enabled;
  final TextCapitalization? textCapitalization;
  final bool hasBottomPadding;

  const CustomAppTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixWidget,
    this.suffixWidget,
    this.onChanged,
    this.validator,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.autofocus = false,
    this.maxLength,
    this.obscureText,
    this.onTap,
    this.enabled = true,
    this.optional = false,
    this.textCapitalization,
    this.hasBottomPadding = true,
  });

  @override
  State<CustomAppTextFormField> createState() => _CustomAppTextFormFieldState();
}

class _CustomAppTextFormFieldState extends State<CustomAppTextFormField> {
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode()
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = focusNode.hasFocus;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: widget.labelText != null,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                widget.labelText ?? '',
                style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SizedBox(
            height: 52,
            child: TextFormField(
              enabled: widget.enabled,
              autofocus: widget.autofocus,
              focusNode: focusNode,
              cursorColor: AppColors.black,
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                filled: true,
                fillColor: (widget.enabled && isFocused)
                    ? AppColors.primary50
                    : AppColors.grey100,
                suffixIcon: widget.suffixWidget,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  color: AppColors.grey200,
                  fontSize: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.transparent),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryColor),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(
                      color: AppColors.transparent, width: 2.0),
                ),
              ),
              inputFormatters: widget.inputFormatters,
              keyboardType: widget.keyboardType,
              validator: widget.validator,
              controller: widget.controller,
              onChanged: widget.onChanged,
              textCapitalization:
                  widget.textCapitalization ?? TextCapitalization.none,
              textInputAction: widget.textInputAction,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomSearchTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final void Function(SearchFieldListItem<dynamic>)? onSuggestionTap;
  final void Function(String)? onSubmit;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? maxLength;
  final bool? obscureText;
  final bool autofocus;
  final bool enabled;
  final List<SearchFieldListItem<dynamic>> suggestions;
  final void Function(String)? onSuggestionSelected;
  final SearchFieldListItem<dynamic>? initialValue;

  const CustomSearchTextFormField(
      {super.key,
      this.controller,
      this.labelText = '',
      this.hintText = '',
      this.prefixWidget,
      this.suffixWidget,
      this.onSuggestionTap,
      this.validator,
      this.inputFormatters,
      this.keyboardType,
      this.maxLines = 1,
      this.autofocus = false,
      this.maxLength,
      this.obscureText,
      this.onTap,
      this.onSubmit,
      this.enabled = true,
      required this.suggestions,
      this.onSuggestionSelected,
      this.initialValue});

  @override
  State<CustomSearchTextFormField> createState() =>
      _CustomSearchTextFormFieldState();
}

class _CustomSearchTextFormFieldState extends State<CustomSearchTextFormField> {
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode()
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = focusNode.hasFocus;

    return Container(
      decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: isFocused
              ? const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )
              : BorderRadius.circular(10)),
      child: SearchField(
        initialValue: widget.initialValue,
        focusNode: focusNode,
        suggestions: widget.suggestions,
        onSuggestionTap: (suggestion) {
          widget.onSuggestionTap?.call(suggestion);
          focusNode.unfocus();
        },
        autofocus: widget.autofocus,
        suggestionsDecoration: SuggestionDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        onSubmit: widget.onSubmit,
        searchStyle: const TextStyle(
            fontFamily: 'PlusJakartaSans', color: AppColors.darkBlueText),
        searchInputDecoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          hintText: widget.hintText ?? AppStrings.searchHintText,
          hintStyle: const TextStyle(
            color: AppColors.grey200,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          prefixIconConstraints:
              const BoxConstraints(maxHeight: 36, maxWidth: 36),
          suffixIconConstraints:
              const BoxConstraints(maxHeight: 36, maxWidth: 36),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(6),
            child: AppImages.svgSearchIcon,
          ),
        ),
        textCapitalization: TextCapitalization.sentences,
        inputFormatters: widget.inputFormatters,
        controller: widget.controller,
        textInputAction: TextInputAction.search,
      ),
    );
  }
}

class CustomAppLongTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final bool? obscureText;
  final bool autofocus;
  final bool enabled;
  final TextCapitalization? textCapitalization;

  const CustomAppLongTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixWidget,
    this.suffixWidget,
    this.onChanged,
    this.validator,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction,
    this.minLines = 5,
    this.maxLines,
    this.autofocus = false,
    this.maxLength,
    this.obscureText,
    this.onTap,
    this.enabled = true,
    this.textCapitalization,
  });

  @override
  State<CustomAppLongTextFormField> createState() =>
      _CustomAppLongTextFormFieldState();
}

class _CustomAppLongTextFormFieldState
    extends State<CustomAppLongTextFormField> {
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode()
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = focusNode.hasFocus;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: widget.labelText != null,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                widget.labelText ?? '',
                style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          TextFormField(
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            autofocus: widget.autofocus,
            focusNode: focusNode,
            cursorColor: AppColors.black,
            style: const TextStyle(
                color: AppColors.black, fontSize: 14, height: 1.5),
            decoration: InputDecoration(
              filled: true,
              fillColor: (widget.enabled && isFocused)
                  ? AppColors.primary50
                  : AppColors.grey,
              suffixIcon: widget.suffixWidget,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 21),
              hintText: widget.hintText,
              hintMaxLines: 3,
              hintStyle: const TextStyle(
                color: AppColors.grey200,
                fontSize: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.transparent),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primaryColor),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: AppColors.transparent),
              ),
            ),
            inputFormatters: widget.inputFormatters,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            controller: widget.controller,
            onChanged: widget.onChanged,
            textCapitalization:
                widget.textCapitalization ?? TextCapitalization.none,
            textInputAction: widget.textInputAction,
          ),
        ],
      ),
    );
  }
}
