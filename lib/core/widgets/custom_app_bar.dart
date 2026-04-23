import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/core/utils/values/text_styles.dart';
import '/injection_container.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final Widget? trailing;
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final bool centerTitle;
  final Color? backButtonIconColor;
  final bool showBackButton;
  final Function()? onBackButtonPressed;

  const CustomAppBar({
    super.key,
    this.title,
    this.leading,
    this.trailing,
    this.backgroundColor,
    this.titleStyle,
    this.centerTitle = false,
    this.backButtonIconColor,
    this.showBackButton = true,
    this.onBackButtonPressed,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? colors.whiteColor,
      elevation: 0,
      leadingWidth: MediaQuery.of(context).size.width * 0.7,
      leading:
          leading ??
          (showBackButton
              ? SizedBox(
                  width: 200.w,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => onBackButtonPressed?.call() ?? context.pop(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Icon(
                            Icons.arrow_back,
                            color: backButtonIconColor ?? colors.main,
                            size: 35.sp,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          title ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              titleStyle ??
                              TextStyles.bold20(
                                color: colors.main,
                              ).copyWith(height: 1.h),
                        ),
                      ),
                    ],
                  ),
                )
              : null),
      automaticallyImplyLeading: false,

      actions: trailing != null ? [trailing!] : const [],
    );
  }
}
