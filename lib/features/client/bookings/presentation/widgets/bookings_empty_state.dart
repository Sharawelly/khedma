import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/img_manager.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/app_image.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class BookingsEmptyState extends StatelessWidget {
  const BookingsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 34.h),
      child: Column(
        children: <Widget>[
          AppImage.network(
            imageUrl: ImageAssets.bookingsEmptyState,
            width: 168.r,
            height: 168.r,
            fit: BoxFit.cover,
            isCached: true,
          ),
          Gaps.vGap20,
          Text(
            'bookings_empty_cancelled_title'.tr,
            style: TextStyles.bold32(color: colors.onboardingHeadline).copyWith(
              fontSize: 34.sp,
              height: 1.05,
            ),
            textAlign: TextAlign.center,
          ),
          Gaps.vGap10,
          Text(
            'bookings_empty_cancelled_message'.tr,
            style: TextStyles.regular16(color: colors.homeCaption).copyWith(
              height: 1.55,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
