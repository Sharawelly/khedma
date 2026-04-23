import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class AlmostDonePhotoUploadCard extends StatelessWidget {
  const AlmostDonePhotoUploadCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 170.h,
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.onboardingBorderNeutral),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 56.r,
            height: 56.r,
            decoration: BoxDecoration(
              color: colors.errorColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.camera_alt_rounded,
              color: colors.errorColor,
              size: 24.r,
            ),
          ),
          Gaps.vGap12,
          Text(
            'home_almost_done_add_photo'.tr,
            style: TextStyles.bold18(color: colors.lightTextColor),
          ),
          Gaps.vGap2,
          Text(
            'home_almost_done_attach_photo'.tr,
            style: TextStyles.regular14(color: colors.homeCaption),
          ),
        ],
      ),
    );
  }
}
