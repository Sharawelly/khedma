import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class FilterButton extends StatelessWidget {
  final String labelKey;
  final bool isActive;
  final VoidCallback onTap;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final double? circleSize;
  final bool hasLanguage;

  const FilterButton({
    super.key,
    required this.labelKey,
    required this.isActive,
    required this.onTap,
    this.activeColor,
    this.inactiveColor,
    this.textColor,
    this.textStyle,
    this.circleSize,
    this.hasLanguage = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: circleSize ?? 25.w,
            height: circleSize ?? 25.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? (activeColor ?? colors.main)
                  : (inactiveColor ?? colors.lightBackGroundColor),
            ),
          ),
          Gaps.hGap8,
          Text(
            hasLanguage ? labelKey : labelKey.tr,
            style:
                textStyle ??
                TextStyles.bold16(color: textColor ?? colors.textColor),
          ),
        ],
      ),
    );
  }
}