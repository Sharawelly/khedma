import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/app_notification_bell_button.dart';
import '/injection_container.dart';

/// Default page header for scroll-based screens (used as a "sliver app bar").
class AppPageHeader extends StatelessWidget {
  const AppPageHeader({
    super.key,
    required this.titleKey,
    this.trailing,
    this.padding,
  });

  final String titleKey;

  /// If provided, replaces the default notification bell.
  final Widget? trailing;

  /// Defaults to the same spacing as the Kits header.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.fromLTRB(20.w, 0, 19.w, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            titleKey.tr,
            style: TextStyles.bold24(color: colors.onboardingHeadline),
          ),
          trailing ?? AppNotificationBellButton(),
        ],
      ),
    );
  }
}
