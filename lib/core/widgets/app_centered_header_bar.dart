import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/core/utils/values/text_styles.dart';
import '/injection_container.dart';

/// Back control, centered [title], optional [trailing] slot.
///
/// For layouts that skip [Scaffold.appBar], e.g. a [CustomScrollView].
/// By default pads the top with [MediaQuery] view padding (status bar).
class AppCenteredHeaderBar extends StatelessWidget {
  const AppCenteredHeaderBar({
    super.key,
    required this.title,
    required this.onBack,
    this.trailing,
    this.showBottomBorder = true,
    this.backgroundColor,
    this.titleStyle,
    this.contentPadding,
    this.leadingIconSize,
  });

  final String title;
  final VoidCallback onBack;
  final Widget? trailing;
  final bool showBottomBorder;
  final Color? backgroundColor;
  final TextStyle? titleStyle;

  /// Full padding; when null, uses leading/title/trailing insets plus
  /// status-bar top inset.
  final EdgeInsetsGeometry? contentPadding;

  /// Diameter-friendly size for the back icon (via [.r]).
  final double? leadingIconSize;

  @override
  Widget build(BuildContext context) {
    final double top = MediaQuery.paddingOf(context).top;
    final EdgeInsetsGeometry resolvedPadding =
        contentPadding ?? EdgeInsets.fromLTRB(8.w, top + 8.h, 17.w, 16.h);
    final double iconSide = leadingIconSize ?? 24;

    return Container(
      padding: resolvedPadding,
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.whiteColor,
        border: showBottomBorder
            ? Border(bottom: BorderSide(color: colors.optionBorder))
            : null,
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: onBack,
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: iconSide.r,
              color: colors.onboardingHeadline,
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style:
                  titleStyle ??
                  TextStyles.bold20(color: colors.onboardingHeadline),
            ),
          ),
          trailing ?? SizedBox(width: 48.w),
        ],
      ),
    );
  }
}
