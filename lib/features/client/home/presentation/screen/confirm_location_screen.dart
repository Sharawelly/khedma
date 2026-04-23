import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/app_centered_header_bar.dart';
import '/core/widgets/gaps.dart';
import '/core/widgets/my_default_button.dart';
import '/injection_container.dart';

class ConfirmLocationScreen extends StatelessWidget {
  const ConfirmLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        minimum: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
        child: SizedBox(
          height: 52.h,
          child: MyDefaultButton(
            btnText: 'home_confirm_location_cta',
            onPressed: () => context.pushNamed(Routes.chooseDateTimeRoute),
            color: colors.errorColor,
            borderColor: colors.errorColor,
            borderRadius: 18,
            height: 52,
            textStyle: TextStyles.bold22(color: colors.whiteColor),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    color: colors.onboardingSurfaceMuted,
                    child: Center(
                      child: Icon(
                        Icons.location_on_rounded,
                        size: 66.r,
                        color: colors.errorColor.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  AppCenteredHeaderBar(
                    title: 'home_confirm_location_header_title'.tr,
                    onBack: context.pop,
                    trailing: SizedBox(width: 48.w),
                    showBottomBorder: false,
                    backgroundColor: Colors.transparent,
                    contentPadding: EdgeInsetsDirectional.fromSTEB(
                      8.w,
                      8.h,
                      16.w,
                      8.h,
                    ),
                  ),
                  PositionedDirectional(
                    start: 16.w,
                    end: 16.w,
                    top: 84.h,
                    child: Container(
                      height: 52.h,
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 14.w,
                      ),
                      decoration: BoxDecoration(
                        color: colors.whiteColor,
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: colors.shadowCardLight,
                            blurRadius: 12.r,
                            offset: Offset(0, 4.h),
                          ),
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.search_rounded,
                            color: colors.errorColor,
                            size: 22.r,
                          ),
                          Gaps.hGap10,
                          Expanded(
                            child: Text(
                              'home_confirm_location_search_value'.tr,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.medium18(
                                color: colors.onboardingHeadline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsetsDirectional.fromSTEB(20.w, 20.h, 20.w, 20.h),
              decoration: BoxDecoration(
                color: colors.whiteColor,
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(24.r),
                  topEnd: Radius.circular(24.r),
                ),
                border: Border(
                  top: BorderSide(color: colors.onboardingBorderNeutral),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'home_confirm_location_title'.tr,
                    style: TextStyles.bold24(color: colors.onboardingHeadline),
                  ),
                  Gaps.vGap12,
                  Container(
                    padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: colors.onboardingSurfaceMuted,
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(color: colors.onboardingBorderNeutral),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.location_on_rounded,
                          color: colors.errorColor,
                          size: 20.r,
                        ),
                        Gaps.hGap10,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'home_confirm_location_value_title'.tr,
                                style: TextStyles.bold18(
                                  color: colors.onboardingHeadline,
                                ).copyWith(height: 1.h),
                              ),
                              Text(
                                'home_confirm_location_value_subtitle'.tr,
                                style: TextStyles.medium12(
                                  color: colors.lightTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'home_service_location_change'.tr,
                          style: TextStyles.bold18(color: colors.errorColor),
                        ),
                      ],
                    ),
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
