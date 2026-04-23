import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

/// Reusable watcher count badge to overlay on images.
/// [isAr] true = bottom-left, false = bottom-right.
class WatcherCountBadge extends StatelessWidget {
  final int count;
  final bool isAr;

  const WatcherCountBadge({
    super.key,
    required this.count,
    required this.isAr,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isAr ? Alignment.bottomLeft : Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: colors.whiteColor.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: colors.textColor.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.visibility_outlined,
                size: 16.sp,
                color: colors.main,
              ),
              Gaps.hGap6,
              Text(
                '$count',
                style: TextStyles.medium14(color: colors.textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
