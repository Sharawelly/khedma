import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class HomeBookingTimeSlotsSection extends StatelessWidget {
  const HomeBookingTimeSlotsSection({
    super.key,
    required this.title,
    required this.timeKeys,
    required this.selectedTimeKey,
    required this.onTimeSelected,
  });

  final String title;
  final List<String> timeKeys;
  final String selectedTimeKey;
  final ValueChanged<String> onTimeSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: TextStyles.bold16(color: colors.lightTextColor)),
        Gaps.vGap10,
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: timeKeys
              .map(
                (String timeKey) => _TimeSlotChip(
                  label: timeKey,
                  isSelected: selectedTimeKey == timeKey,
                  isDisabled: timeKey == 'home_choose_date_time_slot_0200_pm',
                  onTap: () => onTimeSelected(timeKey),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _TimeSlotChip extends StatelessWidget {
  const _TimeSlotChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isDisabled = false,
  });

  final String label;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color borderColor;
    final Color textColor;
    final Color fillColor;

    if (isDisabled) {
      borderColor = colors.onboardingBorderNeutral;
      textColor = colors.onboardingSubtitleMuted;
      fillColor = colors.onboardingSurfaceMuted;
    } else if (isSelected) {
      borderColor = colors.errorColor;
      textColor = colors.whiteColor;
      fillColor = colors.errorColor;
    } else {
      borderColor = colors.onboardingBorderNeutral;
      textColor = colors.lightTextColor;
      fillColor = colors.whiteColor;
    }

    return IgnorePointer(
      ignoring: isDisabled,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            width: 95.w,
            padding: EdgeInsetsDirectional.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: borderColor),
            ),
            child: Center(
              child: Text(
                label.tr,
                style: TextStyles.semiBold16(color: textColor).copyWith(
                  decoration: isDisabled ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
