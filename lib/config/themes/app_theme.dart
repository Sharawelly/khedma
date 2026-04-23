import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/utils/values/app_colors.dart';
import '../../core/utils/values/fonts.dart';

/// Light theme colors: use in [ThemeData.extensions] and register in GetIt
/// so `colors` works before any screen calls [ServiceLocator.injectAppColors].
final AppColors kDefaultAppColors = AppColors(
  backGround: MyColors.backGround,
  upBackGround: MyColors.upBackGround,
  whiteColor: MyColors.whiteColor,
  main: MyColors.main,
  secondary: MyColors.secondary,
  textColor: MyColors.textColor,
  errorColor: MyColors.errorColor,
  review: MyColors.review,
  lightTextColor: MyColors.lightTextColor,
  lightBackGroundColor: MyColors.lightBackGroundColor,
  phoneButtonColor: MyColors.phoneButtonColor,
  gold: MyColors.gold,
  silver: MyColors.silver,
  bronze: MyColors.bronze,
  onboardingBackground: MyColors.onboardingBackground,
  onboardingHeadline: MyColors.onboardingHeadline,
  onboardingSubtitleMuted: MyColors.onboardingSubtitleMuted,
  onboardingCaption: MyColors.onboardingCaption,
  onboardingBorderMint: MyColors.onboardingBorderMint,
  onboardingBorderNeutral: MyColors.onboardingBorderNeutral,
  onboardingBody: MyColors.onboardingBody,
  onboardingTextStrong: MyColors.onboardingTextStrong,
  onboardingSurfaceMuted: MyColors.onboardingSurfaceMuted,
  onboardingAccentSoft: MyColors.onboardingAccentSoft,
  onboardingTypingSurface: MyColors.onboardingTypingSurface,
  mainAlpha26: MyColors.mainAlpha26,
  mainAlpha31: MyColors.mainAlpha31,
  mainAlpha20: MyColors.mainAlpha20,
  mainAlpha40: MyColors.mainAlpha40,
  mainAlpha50: MyColors.mainAlpha50,
  mainAlpha60: MyColors.mainAlpha60,
  onboardingDotInactive: MyColors.onboardingDotInactive,
  invitationInputBorder: MyColors.invitationInputBorder,
  invitationPlaceholder: MyColors.invitationPlaceholder,
  shadowSoft: MyColors.shadowSoft,
  shadowCardLight: MyColors.shadowCardLight,
  shadowCardMedium: MyColors.shadowCardMedium,
  strengthFair: MyColors.strengthFair,
  strengthStrong: MyColors.strengthStrong,
  disabledButtonBg: MyColors.disabledButtonBg,
  disabledButtonText: MyColors.disabledButtonText,
  optionBorder: MyColors.optionBorder,
  selectedOptionBg: MyColors.selectedOptionBg,
  registerLabelText: MyColors.registerLabelText,
  registerSubtitle: MyColors.registerSubtitle,
  homeHeadline: MyColors.homeHeadline,
  homeCardBorder: MyColors.homeCardBorder,
  homeProgressLabel: MyColors.homeProgressLabel,
  homeCaption: MyColors.homeCaption,
  homeWeekWarningRing: MyColors.homeWeekWarningRing,
  blocksStatSurface: MyColors.blocksStatSurface,
  blocksStatBorder: MyColors.blocksStatBorder,
  blocksHeroWarningBorder: MyColors.blocksHeroWarningBorder,
  blocksHeroChipBg: MyColors.blocksHeroChipBg,
  blocksOnGreenMuted: MyColors.blocksOnGreenMuted,
  pathsInfoSurface: MyColors.pathsInfoSurface,
  pathsInfoAccent: MyColors.pathsInfoAccent,
);

ThemeData getAppTheme(BuildContext context) {
  return ThemeData(
    textTheme: GoogleFonts.notoKufiArabicTextTheme(ThemeData.light().textTheme),
    extensions: <ThemeExtension<AppColors>>[kDefaultAppColors],
    fontFamily: Fonts.primary,
    brightness: Brightness.light,
    primaryColor: MyColors.main,
    colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      primary: MyColors.main,
      error: MyColors.errorColor,
    ),
    dividerTheme: DividerThemeData(
      thickness: 1,
      indent: 4.w,
      endIndent: 4.w,
      color: MyColors.lightBackGroundColor,
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStateProperty.all<Color>(MyColors.whiteColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: MyColors.main,
    ),
    scaffoldBackgroundColor: MyColors.whiteColor,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: MyColors.whiteColor,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: MyColors.whiteColor,
      titleSpacing: 35.w,
      toolbarHeight: 70.h,
      actionsIconTheme: IconThemeData(color: MyColors.textColor, size: 24.r),
      iconTheme: IconThemeData(color: MyColors.textColor, size: 24.r),
      titleTextStyle: TextStyle(
        fontFamily: Fonts.primary,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: MyColors.textColor,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: MyColors.whiteColor,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontFamily: Fonts.primary,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: MyColors.textColor,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: Fonts.primary,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: MyColors.textColor,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(padding: EdgeInsets.zero),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
      },
    ),
    useMaterial3: false,
  );
}
