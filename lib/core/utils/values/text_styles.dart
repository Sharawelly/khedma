import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class TextStyles {
  //region:: Light
  static TextStyle light16({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 16.sp,
    fontWeight: FontWeight.w300,
  );

  static TextStyle light12({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 12.sp,
    fontWeight: FontWeight.w300,
  );

  //endregion

  //region:: Regular
  static TextStyle regular22({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 22.sp,
    fontWeight: FontWeight.w400,
  );
  static TextStyle regular28({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 28.sp,
    fontWeight: FontWeight.w400,
  );
  static TextStyle regular20({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 20.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle regular18({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle regular17({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 17.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle regular16({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle regular15({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 15.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle regular14({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
  );

  static TextStyle regular13({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle regular12({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle regular10({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
  );

  //endregion

  //region:: Medium
  static TextStyle medium24({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 24.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle medium22({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 22.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle medium20({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle medium18({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle medium17({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 17.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle medium16({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle medium15({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle medium14({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle medium13({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle medium12({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle medium11({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle medium10({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
  );

  //endregion

  //region:: SemiBold
  static TextStyle semiBold40({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 40.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle semiBold24({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle semiBold22({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle semiBold20({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle semiBold18({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle semiBold17({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 17.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle semiBold16({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle semiBold15({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle semiBold14({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle semiBold12({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle semiBold11({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle semiBold10({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
  );

  //endregion

  //region:: Bold
  static TextStyle bold48({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 48.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle bold32({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle bold30({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 30.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle bold28({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle bold24({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle bold24Heavy({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 24.sp,
    fontWeight: FontWeight.w800,
    height: 44.98 / 24,
    letterSpacing: 0,
  );

  static TextStyle bold22({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle bold20({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle bold19({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 19.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle bold18({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle bold17({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 17.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle bold16({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
  );
  static TextStyle undelLineBold16({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.underline,
  );

  static TextStyle bold15({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 15.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle bold14({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
  );
  static TextStyle bold12({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
  );
  static TextStyle bold11({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 11.sp,
    fontWeight: FontWeight.w700,
  );
  static TextStyle bold10({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
  );

  //endregion

  //region:: UnderLine Regular
  static TextStyle underlineRegular20({Color? color}) => GoogleFonts.cairo(
    color: color,
    fontSize: 20.sp,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.underline,
  );
  //endregion
}
