import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/injection_container.dart';

class AuthSignUpTitleSection extends StatelessWidget {
  const AuthSignUpTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'auth_sign_up_join_title'.tr,
          textAlign: TextAlign.center,
          style: TextStyles.bold22(color: colors.onboardingTextStrong),
        ),
        Gaps.vGap8,
        Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w),
          child: Text(
            'auth_sign_up_subtitle'.tr,
            textAlign: TextAlign.center,
            style: TextStyles.regular16(color: colors.onboardingBody),
          ),
        ),
      ],
    );
  }
}
