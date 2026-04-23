import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/injection_container.dart';

class ProviderTodayJobRow extends StatelessWidget {
  const ProviderTodayJobRow({
    super.key,
    required this.leadIcon,
    required this.leadIconBg,
    required this.leadIconColor,
    required this.titleKey,
    required this.metaKey,
    required this.badgeKey,
    required this.inProgress,
  });

  final IconData leadIcon;
  final Color leadIconBg;
  final Color leadIconColor;
  final String titleKey;
  final String metaKey;
  final String badgeKey;
  final bool inProgress;

  @override
  Widget build(BuildContext context) {
    final Color badgeBg = inProgress
        ? colors.pathsInfoSurface
        : colors.onboardingSurfaceMuted;
    final Color badgeFg = inProgress
        ? colors.pathsInfoAccent
        : colors.lightTextColor;

    return Container(
      padding: EdgeInsetsDirectional.all(12.w),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.shadowCardLight,
            blurRadius: 6,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: leadIconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(leadIcon, size: 22.r, color: leadIconColor),
          ),
          Gaps.hGap12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  titleKey.tr,
                  style: TextStyles.semiBold15(
                    color: colors.onboardingTextStrong,
                  ),
                ),
                Gaps.vGap4,
                Text(
                  metaKey.tr,
                  style: TextStyles.regular12(color: colors.homeCaption),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              badgeKey.tr,
              style: TextStyles.medium10(color: badgeFg).copyWith(
                letterSpacing: 0.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
