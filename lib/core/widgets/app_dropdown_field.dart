import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class AppDropdownField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final void Function(T?) onChanged;
  final String Function(T) displayText;
  final String? Function(T?)? validator;
  final bool isExpanded;
  final Color? valueColor;
  final Color? labelColor;
  final Color? borderColor;
  final double? borderWidth;
  final Color? fillColor;
  final Color? dropdownColor;
  final Color? iconColor;
  final Widget? icon;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final double? iconSize;
  final double? menuMaxHeight;

  const AppDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.displayText,
    this.validator,
    this.isExpanded = true,
    this.valueColor,
    this.labelColor,
    this.borderColor,
    this.borderWidth,
    this.fillColor,
    this.dropdownColor,
    this.iconColor,
    this.icon,
    this.labelStyle,
    this.valueStyle,
    this.iconSize,
    this.menuMaxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              labelStyle ??
              TextStyles.medium24(color: labelColor ?? colors.main),
        ),
        Gaps.vGap4,
        DropdownButtonFormField<T>(
          style:
              valueStyle ??
              TextStyles.medium14(color: valueColor ?? colors.textColor),
          // initialValue: value,
          icon:
              icon ??
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: iconColor ?? colors.main,
              ),
          iconEnabledColor: iconColor ?? colors.main,
          initialValue: value,
          iconDisabledColor: iconColor ?? colors.main,
          dropdownColor: dropdownColor ?? colors.whiteColor,
          validator: validator,
          decoration: _getDropdownDecoration(),
          isExpanded: isExpanded,
          menuMaxHeight: menuMaxHeight,
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    displayText(item),
                    style: TextStyles.medium14(
                      color: valueColor ?? colors.textColor,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  InputDecoration _getDropdownDecoration() {
    final Color effectiveBorderColor = borderColor ?? colors.main;
    final double effectiveBorderWidth = borderWidth ?? 1.0;
    return InputDecoration(
      fillColor: fillColor ?? colors.whiteColor,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
        borderSide: BorderSide(
          color: effectiveBorderColor,
          width: effectiveBorderWidth,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
        borderSide: BorderSide(
          color: effectiveBorderColor,
          width: effectiveBorderWidth,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
        borderSide: BorderSide(
          color: colors.errorColor,
          width: effectiveBorderWidth,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
        borderSide: BorderSide(
          color: colors.errorColor,
          width: effectiveBorderWidth,
        ),
      ),
      errorMaxLines: 2,
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
    );
  }
}
