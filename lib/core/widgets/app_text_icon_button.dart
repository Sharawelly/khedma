import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/injection_container.dart';

/// Compact text + icon action (e.g. “View history”) using theme [colors.main].
class AppTextIconButton extends StatelessWidget {
  const AppTextIconButton({
    super.key,
    required this.labelKey,
    required this.icon,
    required this.onPressed,
    this.iconSize,
  });

  final String labelKey;
  final IconData icon;
  final VoidCallback? onPressed;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: colors.main,
      ),
      icon: Icon(icon, size: (iconSize ?? 16).r),
      label: Text(
        labelKey.tr,
        style: TextStyles.bold14(color: colors.main),
      ),
    );
  }
}
