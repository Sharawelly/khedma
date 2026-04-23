import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/app_colors.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';

class LoginSecureFooter extends StatelessWidget {
  const LoginSecureFooter({super.key, required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.lock_outline_rounded,
          size: 18.r,
          color: colors.onboardingCaption,
        ),
        Gaps.hGap6,
        Flexible(
          child: Text(
            'loginSecureEnterprise'.tr,
            textAlign: TextAlign.center,
            style: TextStyles.medium14(color: colors.onboardingCaption),
          ),
        ),
      ],
    );
  }
}
