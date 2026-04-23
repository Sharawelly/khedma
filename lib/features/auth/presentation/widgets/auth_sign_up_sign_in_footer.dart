import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/config/routes/app_routes.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/injection_container.dart';

class AuthSignUpSignInFooter extends StatelessWidget {
  const AuthSignUpSignInFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Text(
          'auth_sign_up_already_account'.tr,
          style: TextStyles.regular15(color: colors.onboardingBody),
        ),
        InkWell(
          onTap: () {
            context.push(Routes.loginScreenRoute);
          },
          borderRadius: BorderRadius.circular(4.r),
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 2.w, vertical: 2.h),
            child: Text(
              'auth_sign_up_sign_in'.tr,
              style: TextStyles.semiBold15(color: colors.authBrandRed),
            ),
          ),
        ),
      ],
    );
  }
}
