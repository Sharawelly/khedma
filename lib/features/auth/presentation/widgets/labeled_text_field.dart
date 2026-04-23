import 'package:flutter/material.dart';

import '/core/utils/values/text_styles.dart';
import '/core/utils/validator.dart';
import '/core/widgets/app_text_form_field.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class LabeledTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValidatorType? validatorType;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;

  const LabeledTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.focusNode,
    required this.keyboardType,
    required this.textInputAction,
    this.validatorType,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyles.medium24(color: colors.main)),
        Gaps.vGap4,
        AppTextFormField(
          borderColor: colors.main,
          backgroundColor: colors.whiteColor,
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validatorType: validatorType,
          obscureText: obscureText,
          hintText: '',
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          validator: validator,
        ),
      ],
    );
  }
}
