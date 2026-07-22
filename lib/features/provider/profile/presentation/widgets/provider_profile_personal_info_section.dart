import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/config/routes/app_routes.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/features/provider/profile/presentation/widgets/provider_profile_section_card.dart';
import 'package:khedma/injection_container.dart';

class ProviderProfilePersonalInfoSection extends StatelessWidget {
  const ProviderProfilePersonalInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderProfileSectionCard(
      titleKey: 'provider_personal_info'.tr,
      child: Column(
        children: <Widget>[
          _ProviderInfoRow(
            iconData: Icons.person,
            labelKey: 'provider_info_full_name',
            valueKey: 'provider_profile_name',
          ),
          _ProviderInfoRow(
            iconData: Icons.email,
            labelKey: 'provider_info_email_address',
            valueKey: 'provider_info_email_value',
          ),
          _ProviderInfoRow(
            iconData: Icons.phone,
            labelKey: 'provider_info_phone_number',
            valueKey: 'provider_info_phone_value',
          ),
          _ProviderInfoRow(
            iconData: Icons.account_balance_wallet_rounded,
            labelKey: 'provider_my_earnings',
            showNavigationArrow: true,
            onTap: () => context.push(Routes.providerEarningsRoute),
          ),
          _ProviderInfoRow(
            iconData: Icons.star_rounded,
            labelKey: 'provider_my_reviews',
            showDivider: false,
            showNavigationArrow: true,
            onTap: () => context.push(Routes.providerReviewsRoute),
          ),
        ],
      ),
    );
  }
}

class _ProviderInfoRow extends StatelessWidget {
  const _ProviderInfoRow({
    required this.iconData,
    required this.labelKey,
    this.valueKey,
    this.showDivider = true,
    this.onTap,
    this.showNavigationArrow = false,
  });

  final IconData iconData;
  final String labelKey;
  final String? valueKey;
  final bool showDivider;
  final VoidCallback? onTap;
  final bool showNavigationArrow;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.r),
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(vertical: 7.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(iconData, size: 16.r, color: colors.authBrandRed),
                Gaps.hGap8,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        labelKey.tr,
                        style: TextStyles.regular12(
                          color: colors.homeCaption,
                        ).copyWith(height: 1.h),
                      ),
                      if (valueKey != null) ...<Widget>[
                        Gaps.vGap2,
                        Text(
                          valueKey!.tr,
                          style: TextStyles.medium14(
                            color: colors.onboardingHeadline,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  showNavigationArrow ? Icons.chevron_right_rounded : Icons.edit,
                  size: 18.r,
                  color: colors.authBrandRed,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(height: 1.h, color: colors.onboardingBorderNeutral),
      ],
    );
  }
}
