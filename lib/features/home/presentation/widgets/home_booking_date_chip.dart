import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/core/utils/values/text_styles.dart';
import '/injection_container.dart';

class HomeBookingDateChip extends StatelessWidget {
  const HomeBookingDateChip({
    super.key,
    required this.weekdayLabel,
    required this.dayNumberLabel,
    required this.isSelected,
    required this.onTap,
  });

  final String weekdayLabel;
  final String dayNumberLabel;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          width: 64.w,
          padding: EdgeInsetsDirectional.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? colors.errorColor : colors.whiteColor,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected
                  ? colors.errorColor
                  : colors.onboardingBorderNeutral,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                weekdayLabel,
                style: TextStyles.medium14(
                  color: isSelected ? colors.whiteColor : colors.lightTextColor,
                ),
              ),
              Text(
                dayNumberLabel,
                style: TextStyles.bold22(
                  color: isSelected
                      ? colors.whiteColor
                      : colors.onboardingHeadline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
