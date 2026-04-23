import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/core/widgets/my_default_button.dart';
import '/injection_container.dart';

/// Shown for each tab when user is in guest mode or not logged in.
class GuestPlaceholderScreen extends StatelessWidget {
  final String sectionTitle;

  const GuestPlaceholderScreen({
    super.key,
    required this.sectionTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline_rounded,
              size: 64.sp,
              color: colors.main.withValues(alpha: 0.6),
            ),
            Gaps.vGap24,
            Text(
              sectionTitle,
              style: TextStyles.bold20(color: colors.textColor),
              textAlign: TextAlign.center,
            ),
            Gaps.vGap12,
            Text(
              'login_to_access_section'.tr,
              style: TextStyles.regular14(color: colors.textColor),
              textAlign: TextAlign.center,
            ),
            Gaps.vGap32,
            MyDefaultButton(
              btnText: 'login',
              onPressed: () => context.push(Routes.loginScreenRoute),
              color: colors.main,
              textColor: colors.whiteColor,
              height: 48.h,
              width: 200.w,
              borderRadius: 12,
            ),
          ],
        ),
      ),
    );
  }
}
