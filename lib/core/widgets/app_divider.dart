// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '/core/utils/values/app_colors.dart';

class AppDivider extends StatelessWidget {
  double? width;
  double? height;
  Color? color;
  double raduis;
  AppDivider({
    super.key,
    this.width = double.infinity,
    this.height = 1,
    this.color = MyColors.main,
    this.raduis = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(raduis),
      ),
    );
  }
}
