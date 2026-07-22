import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/features/provider/home/presentation/widgets/provider_customer_info_row.dart';
import 'package:khedma/injection_container.dart';

class ProviderJobDetailsCustomerCard extends StatelessWidget {
  const ProviderJobDetailsCustomerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(16.w),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.onboardingBorderNeutral),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'provider_job_details_customer_title'.tr,
            style: TextStyles.semiBold12(
              color: colors.onboardingTextStrong,
            ).copyWith(height: 1.h),
          ),
          Gaps.vGap10,
          ProviderCustomerInfoRow(
            customerNameKey: 'provider_job_details_customer_name',
            customerNameStyle: TextStyles.semiBold20(
              color: colors.onboardingTextStrong,
            ).copyWith(height: 1.h),
            showCallChip: true,
            showChatChip: true,
          ),
        ],
      ),
    );
  }
}
