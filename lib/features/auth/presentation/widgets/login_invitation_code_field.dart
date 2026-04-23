import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/app_text_form_field.dart';
import 'package:khedma/injection_container.dart';

class LoginInvitationCodeField extends StatelessWidget {
  const LoginInvitationCodeField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final Future<void> Function() onFieldSubmitted;

  TextStyle _codeStyle({required bool isHint}) {
    return TextStyles.bold24(
      color: isHint ? colors.invitationPlaceholder : colors.onboardingHeadline,
    ).copyWith(letterSpacing: 2.4.sp);
  }

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      wrapWithElasticAnimation: false,
      controller: controller,
      focusNode: focusNode,
      hintText: 'loginInvitationPlaceholder'.tr,
      textAlign: TextAlign.center,
      textAlignVertical: TextAlignVertical.center,
      textCapitalization: TextCapitalization.characters,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      textFieldStyle: _codeStyle(isHint: false),
      hintTextStyle: _codeStyle(isHint: true),
      backgroundColor: colors.whiteColor,
      borderColor: colors.invitationInputBorder,
      radius: 14,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      focusedBorderWidth: 1.5.r,
      validator: (value) {
        final v = value?.trim() ?? '';
        if (v.isEmpty) {
          return 'loginInvitationRequired'.tr;
        }
        return null;
      },
      onSubmit: (_) {
        unawaited(onFieldSubmitted());
      },
    );
  }
}
