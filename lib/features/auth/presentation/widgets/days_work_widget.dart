import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/core/utils/values/text_styles.dart';
import '/injection_container.dart';

class DaysOfWorkWidget extends StatelessWidget {
  final String itemName;
  final Color buttonColor;
  final Color textColor;
  final void Function() onTap;
  const DaysOfWorkWidget({
    super.key,
    required this.itemName,
    required this.onTap,
    required this.buttonColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 36.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          border: Border.all(color: colors.textColor),
          color: buttonColor,
        ),
        child: Center(
          child: Text(itemName, style: TextStyles.regular16(color: textColor)),
        ),
      ),
    );
  }
}
