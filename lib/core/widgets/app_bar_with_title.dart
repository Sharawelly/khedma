import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/core/utils/values/text_styles.dart';
import '/core/widgets/back_button.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class AppBarWithTitle extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? titleColor;
  final TextStyle? titleStyle;
  final double? backButtonWidth;
  final double? backButtonHeight;
  final Color? backButtonIconColor;
  final Widget? trailing;
  final double? preferredHeight;

  const AppBarWithTitle({
    super.key,
    required this.title,
    this.titleColor,
    this.titleStyle,
    this.backButtonWidth,
    this.backButtonHeight,
    this.backButtonIconColor,
    this.trailing,
    this.preferredHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight?.h ?? 60.h);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          children: [
            CustomBackButton(iconColor: backButtonIconColor ?? colors.main),
            Gaps.hGap12,
            Expanded(
              child: Text(
                title,
                style:
                    titleStyle ??
                    TextStyles.bold20(
                      color: titleColor ?? colors.main,
                    ).copyWith(height: 1.h),
                // textAlign: TextAlign.center,
              ),
            ),
            // trailing ??
            //     SizedBox(
            //       width: .w,
            //     ), // Balance the back button if no trailing widget
          ],
        ),
      ),
    );
  }
}
