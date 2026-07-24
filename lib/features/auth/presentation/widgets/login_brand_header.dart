import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/app_colors.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';

class LoginBrandHeader extends StatelessWidget {
  const LoginBrandHeader({super.key, required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.home_repair_service_rounded,
          size: 96.r,
          color: colors.authBrandRed,
        ),
        Gaps.vGap8,
        Text(
          'splashTitle'.tr,
          textAlign: TextAlign.center,
          style: TextStyles.bold28(color: colors.authBrandRed),
        ),
        Gaps.vGap4,
        Text(
          'splashSubtitle'.tr,
          textAlign: TextAlign.center,
          style: TextStyles.medium14(color: colors.onboardingBody),
        ),
      ],
    );
  }
}
