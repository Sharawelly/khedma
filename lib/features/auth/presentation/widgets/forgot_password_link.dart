import 'package:flutter/material.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/injection_container.dart';

class ForgotPasswordLink extends StatelessWidget {
  final VoidCallback? onPressed;

  const ForgotPasswordLink({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed:
            onPressed ??
            () {
              // Navigate to forgot password screen
              // Navigator.pushNamed(context, Routes.forgotPasswordRoute);
            },
        child: Text(
          'forgot_password_text'.tr,
          style: TextStyles.regular14(color: colors.lightTextColor),
        ),
      ),
    );
  }
}
