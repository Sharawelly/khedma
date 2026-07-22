import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/injection_container.dart';

class ProviderPersonalInfoSection extends StatelessWidget {
  const ProviderPersonalInfoSection({
    super.key,
    required this.onReviewsTap,
    required this.onEarningsTap,
  });

  final VoidCallback onReviewsTap;
  final VoidCallback onEarningsTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.onboardingBorderNeutral),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'provider_personal_info'.tr,
            style: TextStyles.semiBold14(color: colors.homeCaption),
          ),
          Gaps.vGap8,
          _ProviderPersonalInfoItem(
            labelKey: 'provider_my_reviews',
            iconData: Icons.star_rounded,
            onTap: onReviewsTap,
            showDivider: true,
          ),
          _ProviderPersonalInfoItem(
            labelKey: 'provider_my_earnings',
            iconData: Icons.account_balance_wallet_rounded,
            onTap: onEarningsTap,
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class _ProviderPersonalInfoItem extends StatelessWidget {
  const _ProviderPersonalInfoItem({
    required this.labelKey,
    required this.iconData,
    required this.onTap,
    required this.showDivider,
  });

  final String labelKey;
  final IconData iconData;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(vertical: 10.h),
            child: Row(
              children: <Widget>[
                Container(
                  width: 34.r,
                  height: 34.r,
                  decoration: BoxDecoration(
                    color: colors.authBrandRed.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(iconData, color: colors.authBrandRed, size: 18.r),
                ),
                Gaps.hGap10,
                Expanded(
                  child: Text(
                    labelKey.tr,
                    style: TextStyles.semiBold16(color: colors.onboardingHeadline),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22.r,
                  color: colors.lightTextColor,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(color: colors.onboardingBorderNeutral, height: 1.h),
      ],
    );
  }
}
