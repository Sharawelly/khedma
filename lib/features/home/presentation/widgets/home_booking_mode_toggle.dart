import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class HomeBookingModeToggle extends StatelessWidget {
  const HomeBookingModeToggle({
    super.key,
    required this.isNowSelected,
    required this.onNowTap,
    required this.onScheduleTap,
  });

  final bool isNowSelected;
  final VoidCallback onNowTap;
  final VoidCallback onScheduleTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _ModeOptionTile(
            title: 'home_choose_date_time_mode_now'.tr,
            icon: Icons.flash_on_rounded,
            isSelected: isNowSelected,
            onTap: onNowTap,
          ),
        ),
        Gaps.hGap12,
        Expanded(
          child: _ModeOptionTile(
            title: 'home_choose_date_time_mode_schedule'.tr,
            icon: Icons.calendar_month_outlined,
            isSelected: !isNowSelected,
            onTap: onScheduleTap,
          ),
        ),
      ],
    );
  }
}

class _ModeOptionTile extends StatelessWidget {
  const _ModeOptionTile({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.whiteColor,
      borderRadius: BorderRadius.circular(20.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: onTap,
        child: Container(
          height: 70.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected
                  ? colors.errorColor
                  : colors.onboardingBorderNeutral,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 20.r,
                color: isSelected ? colors.errorColor : colors.lightTextColor,
              ),
              Gaps.vGap4,
              Text(
                title,
                style: TextStyles.bold18(
                  color: isSelected
                      ? colors.onboardingHeadline
                      : colors.lightTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
