import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/app_centered_header_bar.dart';
import '/core/widgets/app_outlined_button.dart';
import '/core/widgets/gaps.dart';
import '/core/widgets/my_default_button.dart';
import '/features/client/home/presentation/widgets/provider_found_provider_card.dart';
import '/injection_container.dart';

class ProviderFoundScreen extends StatelessWidget {
  const ProviderFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            AppCenteredHeaderBar(
              title: 'home_provider_tracking_brand'.tr,
              onBack: context.pop,
              trailing: SizedBox(width: 48.w),
              showBottomBorder: false,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsetsDirectional.fromSTEB(16.w, 14.h, 16.w, 16.h),
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 78.r,
                      height: 78.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.main,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: colors.main.withValues(alpha: 0.25),
                            blurRadius: 14.r,
                            offset: Offset(0, 6.h),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        size: 42.r,
                        color: colors.whiteColor,
                      ),
                    ),
                  ),
                  Gaps.vGap16,
                  Center(
                    child: Text(
                      'home_provider_found_title'.tr,
                      style: TextStyles.bold32(
                        color: colors.onboardingHeadline,
                      ),
                    ),
                  ),
                  Gaps.vGap16,
                  Divider(color: colors.onboardingBorderNeutral, height: 1.h),
                  Gaps.vGap16,
                  const ProviderFoundProviderCard(),
                  Gaps.vGap18,
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: AppOutlinedButton(
                          text: 'home_provider_found_chat'.tr,
                          onPressed: () {},
                          buttonRadius: 20.r,
                          borderColor: colors.onboardingBorderNeutral,
                          textStyle: TextStyles.bold18(
                            color: colors.onboardingHeadline,
                          ),
                          icon: Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 18.r,
                            color: colors.onboardingHeadline,
                          ),
                        ),
                      ),
                      Gaps.hGap12,
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 48.h,
                          child: MyDefaultButton(
                            btnText: 'home_provider_found_track_live',
                            onPressed: () =>
                                context.pushNamed(Routes.trackLiveRoute),
                            color: colors.errorColor,
                            borderColor: colors.errorColor,
                            borderRadius: 20,
                            height: 48,
                            textStyle: TextStyles.bold22(
                              color: colors.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
