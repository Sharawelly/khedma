import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/config/routes/app_routes.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/core/widgets/my_default_button.dart';
import 'package:khedma/injection_container.dart';

class ProviderJobDetailsActionButtons extends StatelessWidget {
  const ProviderJobDetailsActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: 55.h,
          child: MyDefaultButton(
            onPressed: () => context.push(Routes.providerTrackLiveRoute),
            color: colors.authBrandRed,
            borderColor: colors.authBrandRed,
            borderRadius: 18,
            height: 55.h,
            icon: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.rocket_launch_rounded,
                  size: 22.r,
                  color: colors.whiteColor,
                ),
                Gaps.hGap8,
                Text(
                  'provider_job_details_start_tracking'.tr,
                  style: TextStyles.bold22(color: colors.whiteColor),
                ),
              ],
            ),
          ),
        ),
        Gaps.vGap12,
        SizedBox(
          height: 55.h,
          child: MyDefaultButton(
            onPressed: () {},
            btnText: 'provider_job_details_cancel',
            color: colors.whiteColor,
            borderColor: colors.onboardingBorderNeutral,
            borderRadius: 18,
            height: 55.h,
            textStyle: TextStyles.semiBold22(color: colors.authBrandRed),
          ),
        ),
      ],
    );
  }
}
