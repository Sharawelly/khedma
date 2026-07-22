import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/injection_container.dart';

/// Placeholder for Schedule / Wallet / Profile until those flows exist.
class ProviderStubTabScreen extends StatelessWidget {
  const ProviderStubTabScreen({super.key, required this.messageKey});

  final String messageKey;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w),
        child: Text(
          messageKey.tr,
          textAlign: TextAlign.center,
          style: TextStyles.semiBold16(color: colors.onboardingBody),
        ),
      ),
    );
  }
}
