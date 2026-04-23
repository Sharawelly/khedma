import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/img_manager.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: 20.w,
        end: 20.w,
        top: 16.h,
        bottom: 20.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[_TopBar()],
      ),
    );
  }
}

// ── Top bar ──────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'home_greeting_sub'.tr,
                style: TextStyles.medium14(color: colors.lightTextColor),
              ),
              Gaps.vGap2,
              Text(
                'home_greeting'.tr,
                style: TextStyles.bold24(
                  color: colors.onboardingHeadline,
                ).copyWith(height: 1.2),
              ),
              Gaps.vGap6,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.location_on_rounded,
                    color: colors.errorColor,
                    size: 13.r,
                  ),
                  Gaps.hGap2,
                  Text(
                    'home_location'.tr,
                    style: TextStyles.medium13(color: colors.lightTextColor),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: colors.lightTextColor,
                    size: 15.r,
                  ),
                ],
              ),
            ],
          ),
        ),

        _NotificationButton(),
        Gaps.hGap20,
        _AvatarCircle(),
      ],
    );
  }
}

class _NotificationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Icon(
            Icons.notifications_outlined,
            color: colors.onboardingHeadline,
            size: 22.r,
          ),
          PositionedDirectional(
            top: -3.r,
            end: -3.r,
            child: Container(
              width: 10.r,
              height: 10.r,
              decoration: BoxDecoration(
                color: colors.errorColor,
                shape: BoxShape.circle,
                border: Border.all(color: colors.whiteColor, width: 2.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.r,
      height: 50.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.errorColor.withValues(alpha: 0.10),
        border: Border.all(
          color: colors.errorColor.withValues(alpha: 0.22),
          width: 1.8.r,
        ),
      ),
      alignment: Alignment.center,
      child: ClipOval(
        child: Image.asset(
          ImageAssets.marawan,
          width: 44.r,
          height: 44.r,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
