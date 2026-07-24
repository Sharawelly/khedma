import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/injection_container.dart';

String providerMessage(String message) =>
    message.startsWith('provider_') ? message.tr : message;

class ProviderLoadingView extends StatelessWidget {
  const ProviderLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: colors.onboardingSurfaceMuted,
      highlightColor: colors.whiteColor,
      child: ListView.separated(
        padding: EdgeInsetsDirectional.all(16.r),
        itemCount: 4,
        separatorBuilder: (_, _) => SizedBox(height: 12.h),
        itemBuilder: (_, _) => Container(
          height: 104.h,
          decoration: BoxDecoration(
            color: colors.whiteColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
    );
  }
}

class ProviderErrorView extends StatelessWidget {
  const ProviderErrorView(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.all(20.r),
        child: SelectableText.rich(
          TextSpan(
            text: providerMessage(message),
            style: TextStyles.medium16(color: colors.errorColor),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
