import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/config/routes/app_routes.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/features/provider/home/presentation/widgets/provider_customer_info_row.dart';
import 'package:khedma/injection_container.dart';

class ProviderRequestDetailsSheet extends StatelessWidget {
  const ProviderRequestDetailsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.fromSTEB(24.w, 12.h, 24.w, 22.h),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(30.r),
          topEnd: Radius.circular(30.r),
        ),
        border: Border(
          top: BorderSide(color: colors.authBrandRed, width: 2.w),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Container(
              width: 56.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: colors.onboardingBorderNeutral,
                borderRadius: BorderRadius.circular(100.r),
              ),
            ),
          ),
          Gaps.vGap16,
          Container(
            width: 74.r,
            height: 74.r,
            decoration: BoxDecoration(
              color: colors.authBrandRed,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_active_rounded,
              size: 28.r,
              color: colors.whiteColor,
            ),
          ),
          Gaps.vGap12,
          Text(
            'provider_request_new_job_title'.tr,
            textAlign: TextAlign.center,
            style: TextStyles.bold28(color: colors.onboardingTextStrong),
          ),
          Gaps.vGap16,
          Center(
            child: SizedBox(
              width: 95.r,
              height: 95.r,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 95.r,
                    height: 95.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 8.r,
                      value: .82,
                      color: colors.authBrandRed,
                      backgroundColor: colors.authSignUpBackgroundWash,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '45',
                        style: TextStyles.bold30(
                          color: colors.onboardingTextStrong,
                        ).copyWith(height: 1.h),
                      ),
                      Text(
                        'provider_request_seconds'.tr,
                        style: TextStyles.medium12(
                          color: colors.homeCaption,
                        ).copyWith(height: 1.h),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Gaps.vGap16,
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'provider_request_service_name'.tr,
                  maxLines: 2,
                  style: TextStyles.bold24(
                    color: colors.onboardingTextStrong,
                  ).copyWith(height: 1.1),
                ),
              ),
              Gaps.hGap10,
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'provider_request_price'.tr,
                    style: TextStyles.bold24(color: colors.authBrandRed),
                  ),
                  // Text(
                  //   'provider_request_after_commission'.tr,
                  //   style: TextStyles.regular14(color: colors.homeCaption),
                  // ),
                ],
              ),
            ],
          ),
          Gaps.vGap8,
          Row(
            children: <Widget>[
              Icon(
                Icons.location_on_outlined,
                size: 18.r,
                color: colors.homeCaption,
              ),
              Gaps.hGap4,
              Expanded(
                child: Text(
                  'provider_request_location'.tr,
                  style: TextStyles.medium16(color: colors.homeCaption),
                ),
              ),
            ],
          ),
          Gaps.vGap16,
          Container(
            padding: EdgeInsetsDirectional.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              color: colors.backGround,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: ProviderCustomerInfoRow(
              customerNameKey: 'provider_job_details_customer_name',
              customerNameStyle: TextStyles.semiBold20(
                color: colors.onboardingTextStrong,
              ).copyWith(height: 1.h),
              showCallChip: true,
              showChatChip: true,
            ),
          ),
          Gaps.vGap16,
          SizedBox(
            height: 52.h,
            child: FilledButton.icon(
              onPressed: () => context.push(Routes.providerJobDetailsRoute),
              style: FilledButton.styleFrom(
                backgroundColor: colors.main,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              icon: Icon(
                Icons.check_circle,
                size: 22.r,
                color: colors.whiteColor,
              ),
              label: Text(
                'provider_request_accept_job'.tr,
                style: TextStyles.bold20(color: colors.whiteColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
