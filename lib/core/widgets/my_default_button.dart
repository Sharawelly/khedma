import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '/core/utils/values/text_styles.dart';
import '../../config/locale/app_localizations.dart';
import '../../injection_container.dart';

class MyDefaultButton extends StatelessWidget {
  final String? btnText;
  final bool localeText;
  final Function() onPressed;
  final Color? color;
  final Color? textColor;
  final bool isSelected;
  final double? height;
  final double? width;
  final String? svgAsset;
  final TextStyle? textStyle;
  final double? borderRadius;
  final Color? borderColor;
  final Widget? icon;
  final double? horizontalPadding;

  const MyDefaultButton({
    super.key,
    this.btnText,
    this.textStyle,
    required this.onPressed,
    this.color,
    this.isSelected = true,
    this.localeText = false,
    this.textColor,
    this.height,
    this.width,
    this.svgAsset,
    this.borderRadius,
    this.borderColor,
    this.icon,
    this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    AppLocalizations locale = AppLocalizations.of(context)!;

    return SizedBox(
      width: width ?? screenWidth,
      height: (height ?? 80.0).h,
      child: ElevatedButton(
        style: ButtonStyle(
          mouseCursor: WidgetStateProperty.all<MouseCursor>(
            SystemMouseCursors.click,
          ),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(
              horizontal: horizontalPadding ?? 8.w,
              vertical: 8.h,
            ),
          ),
          alignment: Alignment.center,
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius?.r ?? 15.r),
              side: BorderSide(color: borderColor ?? colors.main),
            ),
          ),
          backgroundColor: WidgetStateProperty.all<Color>(color ?? colors.main),
          foregroundColor: WidgetStateProperty.all<Color>(
            textColor ?? colors.textColor,
          ),
        ),
        onPressed: onPressed,
        child: icon != null
            ? icon!
            : svgAsset == null
            ? Center(
                child: Text(
                  localeText ? btnText! : locale.text(btnText!),
                  textAlign: TextAlign.center,
                  style:
                      textStyle ??
                      TextStyles.semiBold24(
                        color: textColor ?? colors.whiteColor,
                      ).copyWith(height: 1.h),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    svgAsset!,
                    height: 24.h,
                    width: 24.w,
                    colorFilter: ColorFilter.mode(
                      textColor ?? colors.whiteColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    localeText ? btnText! : locale.text(btnText!),
                    textAlign: TextAlign.center,
                    style:
                        textStyle ??
                        TextStyles.semiBold18(
                          color: textColor ?? colors.whiteColor,
                        ).copyWith(height: 1.h),
                  ),
                ],
              ),
      ),
    );
  }
}
