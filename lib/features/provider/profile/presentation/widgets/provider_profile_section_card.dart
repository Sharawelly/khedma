import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/injection_container.dart';

class ProviderProfileSectionCard extends StatelessWidget {
  const ProviderProfileSectionCard({
    super.key,
    required this.titleKey,
    required this.child,
  });

  final String titleKey;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(10.w),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.onboardingBorderNeutral),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            titleKey,
            style: TextStyles.semiBold16(color: colors.onboardingHeadline),
          ),
          Gaps.vGap8,
          child,
        ],
      ),
    );
  }
}
