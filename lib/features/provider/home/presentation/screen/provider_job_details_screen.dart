import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/app_centered_header_bar.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/features/provider/home/presentation/widgets/provider_job_details_action_buttons.dart';
import 'package:khedma/features/provider/home/presentation/widgets/provider_job_details_customer_card.dart';
import 'package:khedma/features/provider/home/presentation/widgets/provider_job_details_location_card.dart';
import 'package:khedma/features/provider/home/presentation/widgets/provider_job_details_schedule_card.dart';
import 'package:khedma/features/provider/home/presentation/widgets/provider_job_details_service_card.dart';
import 'package:khedma/injection_container.dart';

class ProviderJobDetailsScreen extends StatelessWidget {
  const ProviderJobDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 12.w,
                vertical: 8.h,
              ),
              child: AppCenteredHeaderBar(
                title: 'provider_job_details_title'.tr,
                titleStyle: TextStyles.bold20(
                  color: colors.onboardingTextStrong,
                ),
                onBack: context.pop,
                showBottomBorder: false,
                backgroundColor: colors.backGround,
                // trailing: Container(
                //   padding: EdgeInsetsDirectional.symmetric(
                //     horizontal: 10.w,
                //     vertical: 6.h,
                //   ),
                //   decoration: BoxDecoration(
                //     color: colors.mainAlpha20,
                //     borderRadius: BorderRadius.circular(10.r),
                //   ),
                //   child: Text(
                //     'provider_job_details_status'.tr,
                //     style: TextStyles.bold10(color: colors.pathsInfoAccent),
                //   ),
                // ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 16.w,
                  vertical: 8.h,
                ),
                children: <Widget>[
                  const ProviderJobDetailsServiceCard(),
                  SizedBox(height: 14.h),
                  const ProviderJobDetailsCustomerCard(),
                  SizedBox(height: 14.h),
                  const ProviderJobDetailsLocationCard(),
                  SizedBox(height: 14.h),
                  const ProviderJobDetailsScheduleCard(),
                  SizedBox(height: 18.h),
                  const ProviderJobDetailsActionButtons(),
                  Gaps.vGap20,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
