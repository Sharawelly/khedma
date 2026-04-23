import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/core/utils/values/text_styles.dart';
import '/injection_container.dart';

class RoleOptionTile extends StatelessWidget {
  const RoleOptionTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 58.h,
        decoration: BoxDecoration(
          color: selected ? colors.selectedOptionBg : Colors.white,
          border: Border.all(
            color: selected ? colors.main : colors.optionBorder,
            width: selected ? 1.5.r : 1.r,
          ),
          borderRadius: BorderRadius.circular(14.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyles.medium16(color: colors.onboardingHeadline),
              ),
            ),
            if (selected)
              Icon(
                Icons.check_circle_outline_rounded,
                color: colors.main,
                size: 20.r,
              ),
          ],
        ),
      ),
    );
  }
}
