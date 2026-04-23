import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/core/widgets/app_shimmer.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

/// Reusable shimmer widget for FormReasonSelector
/// Matches the structure of FilterButton (circle + text)
class FormReasonSelectorShimmer extends StatelessWidget {
  final int itemCount;

  const FormReasonSelectorShimmer({
    super.key,
    this.itemCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(
          itemCount,
          (index) => Padding(
            padding: EdgeInsetsDirectional.only(
              end: index < itemCount - 1 ? 10.w : 0,
            ),
            child: AppShimmer(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 25.w,
                    height: 25.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.lightBackGroundColor,
                    ),
                  ),
                  Gaps.hGap8,
                  Container(
                    height: 16.h,
                    width: 80.w + (index * 15.w), // Varying widths for realism
                    decoration: BoxDecoration(
                      color: colors.lightBackGroundColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


