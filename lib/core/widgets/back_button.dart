import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/core/utils/values/svg_manager.dart';

class CustomBackButton extends StatelessWidget {
  final double height;
  final double width;
  final bool? refresh;

  final String? iconAsset;
  final Color? iconColor;

  /// When set, called instead of [Navigator.pop] (e.g. GoRouter [context.pop]).
  final VoidCallback? onTap;

  const CustomBackButton({
    super.key,

    this.height = 10,
    this.width = 10,
    this.refresh = false,
    this.iconAsset,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
          return;
        }
        Navigator.pop(context, refresh);
      },
      child: Container(
        width: 35.w,
        height: 35.h,
        padding: EdgeInsets.all(8.w),
        child: SvgPicture.asset(
          isArabic ? SvgAssets.forwardArrow : SvgAssets.backArrow,
          width: (16).w,
          height: (16).h,
          colorFilter: iconColor != null
              ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
              : null,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

// Container(
//                       height: 35.h,
//                       width: 35.w,
//                       decoration: BoxDecoration(
//                         color: MyColors.arrowBackGrey,
//                         borderRadius: BorderRadius.circular(6.0.r),
//                       ),
//                       child: Icon(Icons.arrow_back_ios_new_outlined,),
//                     ),
