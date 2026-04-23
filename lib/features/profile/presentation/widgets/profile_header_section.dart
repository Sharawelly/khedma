import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/img_manager.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/app_centered_header_bar.dart';
import '/core/widgets/app_image.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.errorColor,
        borderRadius: BorderRadiusDirectional.only(
          bottomStart: Radius.circular(20.r),
          bottomEnd: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: <Widget>[
          // AppCenteredHeaderBar(
          //   title: 'profile_screen_title'.tr,
          //   onBack: () {},
          //   showBackButton: false,
          //   showBottomBorder: false,
          //   backgroundColor: colors.errorColor,
          //   titleStyle: TextStyles.bold24(color: colors.whiteColor),
          //   trailing: Icon(
          //     Icons.settings_rounded,
          //     color: colors.whiteColor,
          //     size: 22.r,
          //   ),
          //   contentPadding: EdgeInsetsDirectional.only(
          //     start: 8.w,
          //     end: 18.w,
          //     top: MediaQuery.paddingOf(context).top + 8.h,
          //     bottom: 12.h,
          //   ),
          // ),
          SafeArea(
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  padding: EdgeInsetsDirectional.only(top: 8.h),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.whiteColor, width: 3.w),
                    ),
                    child: ClipOval(
                      child: AppImage.network(
                        imageUrl: ImageAssets.profileMainAvatar,
                        width: 88.r,
                        height: 88.r,
                        fit: BoxFit.cover,
                        isCircle: true,
                        isCached: true,
                      ),
                    ),
                  ),
                ),
                PositionedDirectional(
                  end: -2.w,
                  bottom: -2.h,
                  child: Container(
                    width: 28.r,
                    height: 28.r,
                    decoration: BoxDecoration(
                      color: colors.errorColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.whiteColor, width: 2.w),
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: colors.whiteColor,
                      size: 14.r,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gaps.vGap10,
          Text(
            'profile_name'.tr,
            style: TextStyles.bold24(color: colors.whiteColor),
          ),
          Text(
            'profile_email'.tr,
            style: TextStyles.regular16(color: colors.whiteColor).copyWith(
              height: 1.2,
              color: colors.whiteColor.withValues(alpha: 0.9),
            ),
          ),
          Gaps.vGap16,
        ],
      ),
    );
  }
}
