import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/img_manager.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/app_image.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/injection_container.dart';

class ProviderProfileHeaderCard extends StatelessWidget {
  const ProviderProfileHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.authBrandRed,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
      ),
      padding: EdgeInsetsDirectional.fromSTEB(14.w, 12.h, 14.w, 14.h),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              width: 84.r,
              height: 84.r,
              decoration: BoxDecoration(
                color: colors.whiteColor,
                shape: BoxShape.circle,
                border: Border.all(color: colors.whiteColor, width: 2.w),
              ),
              child: AppImage.network(
                imageUrl: ImageAssets.profileMainAvatar,
                fit: BoxFit.cover,
                isCached: true,
                isCircle: true,
              ),
            ),
            Gaps.vGap8,
            Text(
              'provider_profile_name'.tr,
              style: TextStyles.bold24(color: colors.whiteColor),
            ),
            Gaps.vGap4,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.star_rounded, color: colors.review, size: 14.r),
                Gaps.hGap4,
                Text(
                  'provider_profile_rating_summary'.tr,
                  style: TextStyles.medium12(color: colors.whiteColor),
                ),
              ],
            ),
            Gaps.vGap8,
            Container(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 10.w,
                vertical: 4.h,
              ),
              decoration: BoxDecoration(
                color: colors.whiteColor.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'provider_profile_badge'.tr,
                style: TextStyles.semiBold12(color: colors.whiteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
