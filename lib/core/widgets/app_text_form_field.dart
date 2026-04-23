import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../injection_container.dart';
import '../utils/validator.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValidatorType? validatorType;
  final VoidCallback? onTap;
  final String? labelText;
  final String? hintText;
  final int? maxLines;
  final int? minLines;
  final double? radius;
  final String? Function(String?)? validator;
  final void Function(String? val)? onSaved;
  final void Function(String? val)? onChanged;
  final void Function(String val)? onSubmit;
  final bool obscureText;
  final Widget? suffix;
  final Widget? prefixWidget;
  final IconData? prefix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? isPhone;
  final bool? isEdit;
  final bool readOnly;
  final TextInputType? keyboardType;
  final bool arLang;
  final TextInputAction? textInputAction;
  final TextAlign textAlign;
  final Color? backgroundColor;
  final List<TextInputFormatter>? inputFormatters;
  final Color? borderColor;
  final Color? hintColor;
  final Iterable<String>? autofillHints;
  final bool wrapWithElasticAnimation;
  final TextStyle? textFieldStyle;
  final TextStyle? hintTextStyle;
  final EdgeInsetsGeometry? contentPadding;
  final TextCapitalization textCapitalization;
  final TextAlignVertical? textAlignVertical;
  final double enabledBorderWidth;
  final double? focusedBorderWidth;

  const AppTextFormField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.validatorType,
    this.validator,
    required this.hintText,
    this.onSaved,
    this.onChanged,
    this.onSubmit,
    this.textAlign = TextAlign.start,
    this.labelText,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
    this.prefix,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixWidget,
    this.isPhone = false,
    this.isEdit = false,
    this.maxLines,
    this.minLines,
    this.readOnly = false,
    this.onTap,
    this.arLang = false,
    this.textInputAction,
    this.backgroundColor,
    this.inputFormatters,
    this.radius,
    this.borderColor,
    this.hintColor,
    this.autofillHints,
    this.wrapWithElasticAnimation = true,
    this.textFieldStyle,
    this.hintTextStyle,
    this.contentPadding,
    this.textCapitalization = TextCapitalization.none,
    this.textAlignVertical,
    this.enabledBorderWidth = 1.0,
    this.focusedBorderWidth,
  });

  @override
  Widget build(BuildContext context) {
    final FocusNode node = focusNode!;
    Color color = labelText != null
        ? colors.textColor
        : node.hasFocus
        ? colors.textColor
        : colors.textColor;
    Color labelColor = node.hasFocus ? colors.textColor : colors.textColor;
    TextTheme theme = Theme.of(context).textTheme;
    double myFontSize = 14.sp;
    final double cornerRadius = (radius ?? 12).r;
    final OutlineInputBorder baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
      borderSide: BorderSide(
        color: borderColor ?? colors.textColor,
        width: enabledBorderWidth,
      ),
    );
    final field = TextFormField(
      controller: controller,
      maxLines: maxLines ?? 1,
      autofillHints: autofillHints,
      textDirection: arLang ? TextDirection.rtl : null,
      minLines: minLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction ?? TextInputAction.done,
      textCapitalization: textCapitalization,
      textAlignVertical: textAlignVertical,
      validator: validatorType != null
          ? (String? value) =>
                Validator.call(value: value, type: validatorType!)
          : validator,
      readOnly: readOnly,
      textAlign: textAlign,
      obscureText: obscureText,
      cursorColor: colors.textColor,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        suffix: suffix,
        prefix: isPhone == true
            ? prefixWidget
            : prefix != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Icon(prefix, size: 16, color: Colors.grey),
              )
            : null,
        fillColor: backgroundColor ?? colors.backGround,
        filled: true,
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
          borderSide: BorderSide(
            color: colors.main,
            width: focusedBorderWidth ?? 1.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
          borderSide: BorderSide(color: colors.errorColor, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
          borderSide: BorderSide(color: colors.errorColor, width: 1.0),
        ),
        floatingLabelBehavior: labelText != null
            ? FloatingLabelBehavior.auto
            : FloatingLabelBehavior.never,
        hintText: hintText,
        labelText: labelText,
        errorMaxLines: 2,
        contentPadding:
            contentPadding ??
            EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
        labelStyle: theme.bodyMedium!.copyWith(
          color: labelColor,
          fontSize: myFontSize,
        ),
        errorStyle: theme.bodySmall!.copyWith(
          color: Colors.red,
          fontSize: myFontSize - 4,
        ),
        hintStyle:
            hintTextStyle ??
            theme.bodyMedium!.copyWith(
              color: hintColor ?? Colors.grey,
              fontSize: myFontSize,
            ),
      ),
      style:
          textFieldStyle ??
          theme.bodyMedium!.copyWith(color: color, fontSize: myFontSize),
      focusNode: focusNode,
      onSaved: onSaved,
      onTap: onTap,
      onChanged: onChanged,
      onFieldSubmitted: onSubmit == null ? null : (String v) => onSubmit!(v),
      onTapOutside: (_) {
        FocusScope.of(context).unfocus();
      },
    );

    if (!wrapWithElasticAnimation) {
      return field;
    }
    return ElasticIn(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      child: field,
    );
  }
}
