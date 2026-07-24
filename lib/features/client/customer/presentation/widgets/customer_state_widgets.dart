import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '/core/utils/values/text_styles.dart';
import '/injection_container.dart';

bool get isArabic => !appLocalizations.isEnLocale;

class CustomerLoadingView extends StatelessWidget {
  const CustomerLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: colors.onboardingSurfaceMuted,
      highlightColor: colors.whiteColor,
      child: ListView.separated(
        padding: EdgeInsetsDirectional.all(16.r),
        itemCount: 5,
        separatorBuilder: (_, _) => SizedBox(height: 12.h),
        itemBuilder: (_, _) => Container(
          height: 92.h,
          decoration: BoxDecoration(
            color: colors.whiteColor,
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
      ),
    );
  }
}

class CustomerErrorView extends StatelessWidget {
  const CustomerErrorView(this.message, {super.key});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.all(20.r),
        child: SelectableText.rich(
          TextSpan(
            text: message,
            style: TextStyles.medium16(color: colors.errorColor),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
