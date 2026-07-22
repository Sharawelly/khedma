import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/injection_container.dart';

class ProviderEarningsScreen extends StatelessWidget {
  const ProviderEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 48.h, 16.w, 20.h),
            decoration: BoxDecoration(color: colors.authBrandRed),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: colors.whiteColor,
                        size: 20.r,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'provider_my_earnings'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyles.bold24(color: colors.whiteColor),
                      ),
                    ),
                    SizedBox(width: 36.w),
                  ],
                ),
                Gaps.vGap8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _SegmentTab(titleKey: 'provider_earnings_daily', isActive: false),
                    _SegmentTab(titleKey: 'provider_earnings_weekly', isActive: false),
                    _SegmentTab(titleKey: 'provider_earnings_monthly', isActive: true),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsetsDirectional.fromSTEB(16.w, 16.h, 16.w, 20.h),
              children: <Widget>[
                Text(
                  'provider_earnings_this_month'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyles.medium20(color: colors.lightTextColor),
                ),
                Gaps.vGap8,
                Text(
                  'EGP 5,100',
                  textAlign: TextAlign.center,
                  style: TextStyles.bold32(color: colors.onboardingHeadline),
                ),
                Gaps.vGap4,
                Text(
                  '+12.5% ${'provider_earnings_from_last_month'.tr}',
                  textAlign: TextAlign.center,
                  style: TextStyles.semiBold14(color: colors.main),
                ),
                Gaps.vGap16,
                Container(
                  height: 180.h,
                  decoration: BoxDecoration(
                    color: colors.whiteColor,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: colors.onboardingBorderNeutral),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'provider_earnings_chart_placeholder'.tr,
                    style: TextStyles.regular13(color: colors.homeCaption),
                  ),
                ),
                Gaps.vGap20,
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'provider_earnings_payout_history'.tr,
                        style: TextStyles.bold20(color: colors.onboardingHeadline),
                      ),
                    ),
                    Text(
                      'profile_view_all'.tr,
                      style: TextStyles.semiBold14(color: colors.authBrandRed),
                    ),
                  ],
                ),
                Gaps.vGap12,
                const _PayoutCard(amount: 'EGP 1,250.00', date: 'April 24, 2024', paid: true),
                Gaps.vGap10,
                const _PayoutCard(amount: 'EGP 850.00', date: 'April 18, 2024', paid: false),
                Gaps.vGap10,
                const _PayoutCard(amount: 'EGP 2,100.00', date: 'April 10, 2024', paid: true),
                Gaps.vGap20,
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.authBrandRed,
                    side: BorderSide(color: colors.authBrandRed),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    padding: EdgeInsetsDirectional.symmetric(vertical: 14.h),
                  ),
                  child: Text(
                    'provider_earnings_request_early_payout'.tr,
                    style: TextStyles.bold18(color: colors.authBrandRed),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentTab extends StatelessWidget {
  const _SegmentTab({required this.titleKey, required this.isActive});

  final String titleKey;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.symmetric(horizontal: 4.w),
      padding: EdgeInsetsDirectional.fromSTEB(14.w, 8.h, 14.w, 8.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isActive ? colors.whiteColor : Colors.transparent,
            width: 2.w,
          ),
        ),
      ),
      child: Text(
        titleKey.tr,
        style: TextStyles.semiBold14(
          color: isActive
              ? colors.whiteColor
              : colors.whiteColor.withValues(alpha: 0.85),
        ),
      ),
    );
  }
}

class _PayoutCard extends StatelessWidget {
  const _PayoutCard({
    required this.amount,
    required this.date,
    required this.paid,
  });

  final String amount;
  final String date;
  final bool paid;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(12.w),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.onboardingBorderNeutral),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 30.r,
            height: 30.r,
            decoration: BoxDecoration(
              color: colors.onboardingSurfaceMuted,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.account_balance_wallet_rounded, size: 18.r),
          ),
          Gaps.hGap10,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  amount,
                  style: TextStyles.bold20(color: colors.onboardingHeadline),
                ),
                Text(date, style: TextStyles.regular13(color: colors.homeCaption)),
              ],
            ),
          ),
          Container(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: paid
                  ? colors.main.withValues(alpha: 0.14)
                  : colors.review.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              paid ? 'provider_earnings_paid'.tr : 'provider_earnings_pending'.tr,
              style: TextStyles.semiBold12(
                color: paid ? colors.main : colors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
