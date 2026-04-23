import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/injection_container.dart';

/// Pager dots for onboarding. Set [allActiveWithWideLast] on the final step.
class OnBoardingPageDots extends StatelessWidget {
  const OnBoardingPageDots({
    super.key,
    required this.activeIndex,
    this.count = 7,
    this.allActiveWithWideLast = false,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  final int activeIndex;
  final int count;
  final bool allActiveWithWideLast;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    if (allActiveWithWideLast) {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          for (int i = 0; i < count - 1; i++) ...[
            if (i > 0) SizedBox(width: 8.w),
            const _OnBoardingDot(isActive: true),
          ],
          SizedBox(width: 8.w),
          const _OnBoardingDot(isActive: true, isWide: true),
        ],
      );
    }
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        for (int i = 0; i < count; i++) ...[
          if (i > 0) SizedBox(width: 8.w),
          _OnBoardingDot(isActive: i == activeIndex),
        ],
      ],
    );
  }
}

class _OnBoardingDot extends StatelessWidget {
  const _OnBoardingDot({this.isActive = false, this.isWide = false});

  final bool isActive;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: isWide ? 24.w : (isActive ? 24.w : 6.w),
      height: 6.h,
      decoration: BoxDecoration(
        color: isActive ? colors.main : colors.onboardingDotInactive,
        borderRadius: BorderRadius.circular(3.r),
      ),
    );
  }
}
