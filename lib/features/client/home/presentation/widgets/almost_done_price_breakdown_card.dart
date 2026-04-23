import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class AlmostDonePriceBreakdownCard extends StatelessWidget {
  const AlmostDonePriceBreakdownCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(16.w, 16.h, 16.w, 14.h),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.onboardingBorderNeutral),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'home_almost_done_price_breakdown'.tr,
                style: TextStyles.bold20(color: colors.onboardingHeadline),
              ),
              const Spacer(),
              Icon(
                Icons.keyboard_arrow_up_rounded,
                size: 22.r,
                color: colors.homeCaption,
              ),
            ],
          ),
          Gaps.vGap12,
          Gaps.vGap2,
          _PriceRow(
            labelKey: 'home_almost_done_service_fee',
            valueKey: 'home_almost_done_service_fee_value',
          ),
          Gaps.vGap8,
          _PriceRow(
            labelKey: 'home_almost_done_vat',
            valueKey: 'home_almost_done_vat_value',
          ),
          Gaps.vGap10,
          Divider(color: colors.onboardingBorderNeutral, height: 1.h),
          Gaps.vGap12,
          _PriceRow(
            labelKey: 'home_almost_done_total',
            valueKey: 'home_almost_done_total_value',
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.labelKey,
    required this.valueKey,
    this.isTotal = false,
  });

  final String labelKey;
  final String valueKey;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          labelKey.tr,
          style: isTotal
              ? TextStyles.bold22(color: colors.onboardingHeadline)
              : TextStyles.medium20(color: colors.lightTextColor),
        ),
        const Spacer(),
        Text(
          valueKey.tr,
          style: isTotal
              ? TextStyles.bold22(color: colors.errorColor)
              : TextStyles.medium18(color: colors.onboardingHeadline),
        ),
      ],
    );
  }
}
