import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/core/utils/values/text_styles.dart';
import '/injection_container.dart';

/// Reusable radio-style option tile used by the Multiple Choice block and any
/// other feature that presents a list of selectable answer options.
class BlockChoiceOptionTile extends StatelessWidget {
  const BlockChoiceOptionTile({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected ? colors.selectedOptionBg : colors.whiteColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? colors.main : colors.optionBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20.r,
              height: 20.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? colors.main : colors.whiteColor,
                border: Border.all(
                  color: isSelected ? colors.main : colors.optionBorder,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check_rounded,
                      size: 13.r,
                      color: colors.whiteColor,
                    )
                  : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: TextStyles.regular14(
                  color: isSelected
                      ? colors.onboardingHeadline
                      : colors.onboardingBody,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
