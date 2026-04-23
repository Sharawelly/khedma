import 'package:flutter/material.dart';
import 'package:khedma/injection_container.dart';

class MyColors {
  static const Color backGround = Color(0xFFFFFFFF);
  static const Color main = Color(0xFF1FA971);
  static const Color secondary = Color(0xffe0a04b);
  static const Color upBackGround = Color(0xffFBF8EF);
  static const Color textColor = Color(0xFF000000);
  static const Color lightTextColor = Color(0xFF565656);
  static const Color lightBackGroundColor = Color(
    0xFFdadada,
  ); // Color(0xFFfafafa)
  static const Color errorColor = Color(0xFFEF0F0F);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color phoneButtonColor = Color(0xFFAEB98F);

  // Medal colors for rankings
  static const Color gold = Color(0xFFFFD700);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color bronze = Color(0xFFCD7F32);

  // shared
  static Color review = const Color(0xffFFA534);

  // Onboarding / marketing (use with TextStyles from text_styles.dart)
  static const Color onboardingBackground = Color(0xFFF2F2F2);
  static const Color onboardingHeadline = Color(0xFF0A2540);
  static const Color onboardingSubtitleMuted = Color(0xFF8C8C8C);
  static const Color onboardingBody = Color(0xFF6B7280);
  static const Color onboardingCaption = Color(0xFF9CA3AF);
  static const Color onboardingTextStrong = Color(0xFF0E1A13);
  static const Color onboardingAccentSoft = Color(0xFF5BC09A);
  static const Color onboardingSurfaceMuted = Color(0xFFF7F7F7);
  static const Color onboardingBorderMint = Color(0xFFE9F7F1);
  static const Color onboardingBorderNeutral = Color(0xFFE5E7EB);
  static const Color onboardingTypingSurface = Color(0xFFEDEDED);
  static const Color onboardingDotInactive = Color(0xFFD1D5DB);
  static const Color invitationInputBorder = Color(0xFFCAD5E2);
  static const Color strengthFair = Color(0xFFE17100);
  static const Color strengthStrong = Color(0xFF007A55);
  static const Color disabledButtonBg = Color(0xFFE2E8F0);
  static const Color disabledButtonText = Color(0xFF90A1B9);
  static const Color optionBorder = Color(0xFFE2E8F0);
  static const Color selectedOptionBg = Color(0xFFECFDF5);
  static const Color registerLabelText = Color(0xFF314158);
  static const Color registerSubtitle = Color(0xFF475569);

  /// Same RGB as [onboardingHeadline]; lower alpha so bold hint reads faded
  /// (0xBF ~75% still looked nearly solid on white with w700).
  static const Color invitationPlaceholder = Color(0x660A2540);

  static const Color mainAlpha26 = Color(0x1A1FA971);
  static const Color mainAlpha31 = Color(0x1F1FA971);
  static const Color mainAlpha20 = Color(0x331FA971);
  static const Color mainAlpha40 = Color(0x661FA971);
  static const Color mainAlpha50 = Color(0x801FA971);
  static const Color mainAlpha60 = Color(0x991FA971);

  static const Color shadowSoft = Color(0x36000000);
  static const Color shadowCardLight = Color(0x0D000000);
  static const Color shadowCardMedium = Color(0x0F000000);

  /// Home / app shell (Figma Performa Me)
  static const Color homeHeadline = Color(0xFF0F1A16);
  static const Color homeSlate = Color(0xFF62748E);
  static const Color homeCaption = Color(0xFF94A3B8);
  static const Color homeProgressLabel = Color(0xFF539379);
  static const Color homeCardBorder = Color(0xFFF3F4F6);
  static const Color homeNavBorder = Color(0xFFE2E8F0);
  static const Color homeWeekWarningRing = Color(0xFFF4631E);

  /// Blocks (Figma Performa Me — My Blocks)
  static const Color blocksStatSurface = Color(0xFFF8FAFC);
  static const Color blocksStatBorder = Color(0xFFF1F5F9);
  static const Color blocksLockedIconFill = Color(0xFFF7FAFF);
  static const Color blocksLockedIconBorder = Color(0xFF0F172A);
  static const Color blocksMissedIconFill = Color(0xFFFFF7ED);
  static const Color blocksDoneIconFill = Color(0xFFF0FDF4);
  static const Color blocksHeroWarningBorder = Color(0xFFFFEDD5);
  static const Color blocksHeroChipBg = Color(0xFFFFF7ED);
  static const Color blocksOnGreenMuted = Color(0xFFCAD5E2);

  /// Paths — case study / info chips (Figma blue-100 & blue-500)
  static const Color pathsInfoSurface = Color(0xFFDBEAFE);
  static const Color pathsInfoAccent = Color(0xFF3B82F6);
}

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color backGround;
  final Color upBackGround;
  final Color main;
  final Color secondary;
  final Color textColor;
  final Color whiteColor;
  final Color errorColor;
  final Color review;
  final Color lightTextColor;
  final Color lightBackGroundColor;
  final Color phoneButtonColor;
  final Color gold;
  final Color silver;
  final Color bronze;
  final Color onboardingBackground;
  final Color onboardingHeadline;
  final Color onboardingSubtitleMuted;
  final Color onboardingCaption;
  final Color onboardingBorderMint;
  final Color onboardingBorderNeutral;
  final Color onboardingBody;
  final Color onboardingTextStrong;
  final Color onboardingSurfaceMuted;
  final Color onboardingAccentSoft;
  final Color onboardingTypingSurface;
  final Color mainAlpha26;
  final Color mainAlpha31;
  final Color mainAlpha20;
  final Color mainAlpha40;
  final Color mainAlpha50;
  final Color mainAlpha60;
  final Color onboardingDotInactive;
  final Color invitationInputBorder;
  final Color invitationPlaceholder;
  final Color shadowSoft;
  final Color shadowCardLight;
  final Color shadowCardMedium;
  final Color strengthFair;
  final Color strengthStrong;
  final Color disabledButtonBg;
  final Color disabledButtonText;
  final Color optionBorder;
  final Color selectedOptionBg;
  final Color registerLabelText;
  final Color registerSubtitle;
  final Color homeHeadline;
  final Color homeCardBorder;
  final Color homeProgressLabel;
  final Color homeCaption;
  final Color homeWeekWarningRing;
  final Color blocksStatSurface;
  final Color blocksStatBorder;
  final Color blocksHeroWarningBorder;
  final Color blocksHeroChipBg;
  final Color blocksOnGreenMuted;
  final Color pathsInfoSurface;
  final Color pathsInfoAccent;

  const AppColors({
    required this.backGround,
    required this.upBackGround,
    required this.main,
    required this.secondary,
    required this.textColor,
    required this.whiteColor,
    required this.errorColor,
    required this.review,
    required this.lightTextColor,
    required this.lightBackGroundColor,
    required this.phoneButtonColor,
    required this.gold,
    required this.silver,
    required this.bronze,
    required this.onboardingBackground,
    required this.onboardingHeadline,
    required this.onboardingSubtitleMuted,
    required this.onboardingCaption,
    required this.onboardingBorderMint,
    required this.onboardingBorderNeutral,
    required this.onboardingBody,
    required this.onboardingTextStrong,
    required this.onboardingSurfaceMuted,
    required this.onboardingAccentSoft,
    required this.onboardingTypingSurface,
    required this.mainAlpha26,
    required this.mainAlpha31,
    required this.mainAlpha20,
    required this.mainAlpha40,
    required this.mainAlpha50,
    required this.mainAlpha60,
    required this.onboardingDotInactive,
    required this.invitationInputBorder,
    required this.invitationPlaceholder,
    required this.shadowSoft,
    required this.shadowCardLight,
    required this.shadowCardMedium,
    required this.strengthFair,
    required this.strengthStrong,
    required this.disabledButtonBg,
    required this.disabledButtonText,
    required this.optionBorder,
    required this.selectedOptionBg,
    required this.registerLabelText,
    required this.registerSubtitle,
    required this.homeHeadline,
    required this.homeCardBorder,
    required this.homeProgressLabel,
    required this.homeCaption,
    required this.homeWeekWarningRing,
    required this.blocksStatSurface,
    required this.blocksStatBorder,
    required this.blocksHeroWarningBorder,
    required this.blocksHeroChipBg,
    required this.blocksOnGreenMuted,
    required this.pathsInfoSurface,
    required this.pathsInfoAccent,
  });

  @override
  AppColors copyWith({
    Color? backGround,
    Color? upBackGround,
    Color? main,
    Color? secondary,
    Color? textColor,
    Color? whiteColor,
    Color? errorColor,
    Color? review,
    Color? lightTextColor,
    Color? lightBackGroundColor,
    Color? phoneButtonColor,
    Color? gold,
    Color? silver,
    Color? bronze,
    Color? onboardingBackground,
    Color? onboardingHeadline,
    Color? onboardingSubtitleMuted,
    Color? onboardingCaption,
    Color? onboardingBorderMint,
    Color? onboardingBorderNeutral,
    Color? onboardingBody,
    Color? onboardingTextStrong,
    Color? onboardingSurfaceMuted,
    Color? onboardingAccentSoft,
    Color? onboardingTypingSurface,
    Color? mainAlpha26,
    Color? mainAlpha31,
    Color? mainAlpha20,
    Color? mainAlpha40,
    Color? mainAlpha50,
    Color? mainAlpha60,
    Color? onboardingDotInactive,
    Color? invitationInputBorder,
    Color? invitationPlaceholder,
    Color? shadowSoft,
    Color? shadowCardLight,
    Color? shadowCardMedium,
    Color? strengthFair,
    Color? strengthStrong,
    Color? disabledButtonBg,
    Color? disabledButtonText,
    Color? optionBorder,
    Color? selectedOptionBg,
    Color? registerLabelText,
    Color? registerSubtitle,
    Color? homeHeadline,
    Color? homeCardBorder,
    Color? homeProgressLabel,
    Color? homeCaption,
    Color? homeWeekWarningRing,
    Color? blocksStatSurface,
    Color? blocksStatBorder,
    Color? blocksHeroWarningBorder,
    Color? blocksHeroChipBg,
    Color? blocksOnGreenMuted,
    Color? pathsInfoSurface,
    Color? pathsInfoAccent,
  }) {
    return AppColors(
      backGround: backGround ?? this.backGround,
      upBackGround: upBackGround ?? this.upBackGround,
      main: main ?? this.main,
      secondary: secondary ?? this.secondary,
      textColor: textColor ?? this.textColor,
      whiteColor: whiteColor ?? this.whiteColor,
      errorColor: errorColor ?? this.errorColor,
      review: review ?? this.review,
      lightTextColor: lightTextColor ?? this.lightTextColor,
      lightBackGroundColor: lightBackGroundColor ?? this.lightBackGroundColor,
      phoneButtonColor: phoneButtonColor ?? this.phoneButtonColor,
      gold: gold ?? this.gold,
      silver: silver ?? this.silver,
      bronze: bronze ?? this.bronze,
      onboardingBackground: onboardingBackground ?? this.onboardingBackground,
      onboardingHeadline: onboardingHeadline ?? this.onboardingHeadline,
      onboardingSubtitleMuted:
          onboardingSubtitleMuted ?? this.onboardingSubtitleMuted,
      onboardingCaption: onboardingCaption ?? this.onboardingCaption,
      onboardingBorderMint: onboardingBorderMint ?? this.onboardingBorderMint,
      onboardingBorderNeutral:
          onboardingBorderNeutral ?? this.onboardingBorderNeutral,
      onboardingBody: onboardingBody ?? this.onboardingBody,
      onboardingTextStrong: onboardingTextStrong ?? this.onboardingTextStrong,
      onboardingSurfaceMuted:
          onboardingSurfaceMuted ?? this.onboardingSurfaceMuted,
      onboardingAccentSoft: onboardingAccentSoft ?? this.onboardingAccentSoft,
      onboardingTypingSurface:
          onboardingTypingSurface ?? this.onboardingTypingSurface,
      mainAlpha26: mainAlpha26 ?? this.mainAlpha26,
      mainAlpha31: mainAlpha31 ?? this.mainAlpha31,
      mainAlpha20: mainAlpha20 ?? this.mainAlpha20,
      mainAlpha40: mainAlpha40 ?? this.mainAlpha40,
      mainAlpha50: mainAlpha50 ?? this.mainAlpha50,
      mainAlpha60: mainAlpha60 ?? this.mainAlpha60,
      onboardingDotInactive:
          onboardingDotInactive ?? this.onboardingDotInactive,
      invitationInputBorder:
          invitationInputBorder ?? this.invitationInputBorder,
      invitationPlaceholder:
          invitationPlaceholder ?? this.invitationPlaceholder,
      shadowSoft: shadowSoft ?? this.shadowSoft,
      shadowCardLight: shadowCardLight ?? this.shadowCardLight,
      shadowCardMedium: shadowCardMedium ?? this.shadowCardMedium,
      strengthFair: strengthFair ?? this.strengthFair,
      strengthStrong: strengthStrong ?? this.strengthStrong,
      disabledButtonBg: disabledButtonBg ?? this.disabledButtonBg,
      disabledButtonText: disabledButtonText ?? this.disabledButtonText,
      optionBorder: optionBorder ?? this.optionBorder,
      selectedOptionBg: selectedOptionBg ?? this.selectedOptionBg,
      registerLabelText: registerLabelText ?? this.registerLabelText,
      registerSubtitle: registerSubtitle ?? this.registerSubtitle,
      homeHeadline: homeHeadline ?? this.homeHeadline,
      homeCardBorder: homeCardBorder ?? this.homeCardBorder,
      homeProgressLabel: homeProgressLabel ?? this.homeProgressLabel,
      homeCaption: homeCaption ?? this.homeCaption,
      homeWeekWarningRing: homeWeekWarningRing ?? this.homeWeekWarningRing,
      blocksStatSurface: blocksStatSurface ?? this.blocksStatSurface,
      blocksStatBorder: blocksStatBorder ?? this.blocksStatBorder,
      blocksHeroWarningBorder:
          blocksHeroWarningBorder ?? this.blocksHeroWarningBorder,
      blocksHeroChipBg: blocksHeroChipBg ?? this.blocksHeroChipBg,
      blocksOnGreenMuted: blocksOnGreenMuted ?? this.blocksOnGreenMuted,
      pathsInfoSurface: pathsInfoSurface ?? this.pathsInfoSurface,
      pathsInfoAccent: pathsInfoAccent ?? this.pathsInfoAccent,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors> other, double t) {
    if (other is! AppColors) {
      return this;
    }
    final appColors = AppColors(
      backGround: Color.lerp(backGround, other.backGround, t) ?? backGround,
      upBackGround:
          Color.lerp(upBackGround, other.upBackGround, t) ?? upBackGround,
      main: Color.lerp(main, other.main, t) ?? main,
      secondary: Color.lerp(secondary, other.secondary, t) ?? secondary,
      textColor: Color.lerp(textColor, other.textColor, t) ?? textColor,
      whiteColor: Color.lerp(whiteColor, other.whiteColor, t) ?? whiteColor,
      errorColor: Color.lerp(errorColor, other.errorColor, t) ?? errorColor,
      review: Color.lerp(review, other.review, t) ?? review,
      lightTextColor:
          Color.lerp(lightTextColor, other.lightTextColor, t) ?? lightTextColor,
      lightBackGroundColor:
          Color.lerp(lightBackGroundColor, other.lightBackGroundColor, t) ??
          lightBackGroundColor,
      phoneButtonColor:
          Color.lerp(phoneButtonColor, other.phoneButtonColor, t) ??
          phoneButtonColor,
      gold: Color.lerp(gold, other.gold, t) ?? gold,
      silver: Color.lerp(silver, other.silver, t) ?? silver,
      bronze: Color.lerp(bronze, other.bronze, t) ?? bronze,
      onboardingBackground:
          Color.lerp(onboardingBackground, other.onboardingBackground, t) ??
          onboardingBackground,
      onboardingHeadline:
          Color.lerp(onboardingHeadline, other.onboardingHeadline, t) ??
          onboardingHeadline,
      onboardingSubtitleMuted:
          Color.lerp(
            onboardingSubtitleMuted,
            other.onboardingSubtitleMuted,
            t,
          ) ??
          onboardingSubtitleMuted,
      onboardingCaption:
          Color.lerp(onboardingCaption, other.onboardingCaption, t) ??
          onboardingCaption,
      onboardingBorderMint:
          Color.lerp(onboardingBorderMint, other.onboardingBorderMint, t) ??
          onboardingBorderMint,
      onboardingBorderNeutral:
          Color.lerp(
            onboardingBorderNeutral,
            other.onboardingBorderNeutral,
            t,
          ) ??
          onboardingBorderNeutral,
      onboardingBody:
          Color.lerp(onboardingBody, other.onboardingBody, t) ?? onboardingBody,
      onboardingTextStrong:
          Color.lerp(onboardingTextStrong, other.onboardingTextStrong, t) ??
          onboardingTextStrong,
      onboardingSurfaceMuted:
          Color.lerp(onboardingSurfaceMuted, other.onboardingSurfaceMuted, t) ??
          onboardingSurfaceMuted,
      onboardingAccentSoft:
          Color.lerp(onboardingAccentSoft, other.onboardingAccentSoft, t) ??
          onboardingAccentSoft,
      onboardingTypingSurface:
          Color.lerp(
            onboardingTypingSurface,
            other.onboardingTypingSurface,
            t,
          ) ??
          onboardingTypingSurface,
      mainAlpha26: Color.lerp(mainAlpha26, other.mainAlpha26, t) ?? mainAlpha26,
      mainAlpha31: Color.lerp(mainAlpha31, other.mainAlpha31, t) ?? mainAlpha31,
      mainAlpha20: Color.lerp(mainAlpha20, other.mainAlpha20, t) ?? mainAlpha20,
      mainAlpha40: Color.lerp(mainAlpha40, other.mainAlpha40, t) ?? mainAlpha40,
      mainAlpha50: Color.lerp(mainAlpha50, other.mainAlpha50, t) ?? mainAlpha50,
      mainAlpha60: Color.lerp(mainAlpha60, other.mainAlpha60, t) ?? mainAlpha60,
      onboardingDotInactive:
          Color.lerp(onboardingDotInactive, other.onboardingDotInactive, t) ??
          onboardingDotInactive,
      invitationInputBorder:
          Color.lerp(invitationInputBorder, other.invitationInputBorder, t) ??
          invitationInputBorder,
      invitationPlaceholder:
          Color.lerp(invitationPlaceholder, other.invitationPlaceholder, t) ??
          invitationPlaceholder,
      shadowSoft: Color.lerp(shadowSoft, other.shadowSoft, t) ?? shadowSoft,
      shadowCardLight:
          Color.lerp(shadowCardLight, other.shadowCardLight, t) ??
          shadowCardLight,
      shadowCardMedium:
          Color.lerp(shadowCardMedium, other.shadowCardMedium, t) ??
          shadowCardMedium,
      strengthFair:
          Color.lerp(strengthFair, other.strengthFair, t) ?? strengthFair,
      strengthStrong:
          Color.lerp(strengthStrong, other.strengthStrong, t) ?? strengthStrong,
      disabledButtonBg:
          Color.lerp(disabledButtonBg, other.disabledButtonBg, t) ??
          disabledButtonBg,
      disabledButtonText:
          Color.lerp(disabledButtonText, other.disabledButtonText, t) ??
          disabledButtonText,
      optionBorder:
          Color.lerp(optionBorder, other.optionBorder, t) ?? optionBorder,
      selectedOptionBg:
          Color.lerp(selectedOptionBg, other.selectedOptionBg, t) ??
          selectedOptionBg,
      registerLabelText:
          Color.lerp(registerLabelText, other.registerLabelText, t) ??
          registerLabelText,
      registerSubtitle:
          Color.lerp(registerSubtitle, other.registerSubtitle, t) ??
          registerSubtitle,
      homeHeadline:
          Color.lerp(homeHeadline, other.homeHeadline, t) ?? homeHeadline,
      homeCardBorder:
          Color.lerp(homeCardBorder, other.homeCardBorder, t) ?? homeCardBorder,
      homeProgressLabel:
          Color.lerp(homeProgressLabel, other.homeProgressLabel, t) ??
          homeProgressLabel,
      homeCaption: Color.lerp(homeCaption, other.homeCaption, t) ?? homeCaption,
      homeWeekWarningRing:
          Color.lerp(homeWeekWarningRing, other.homeWeekWarningRing, t) ??
          homeWeekWarningRing,
      blocksStatSurface:
          Color.lerp(blocksStatSurface, other.blocksStatSurface, t) ??
          blocksStatSurface,
      blocksStatBorder:
          Color.lerp(blocksStatBorder, other.blocksStatBorder, t) ??
          blocksStatBorder,
      blocksHeroWarningBorder:
          Color.lerp(
            blocksHeroWarningBorder,
            other.blocksHeroWarningBorder,
            t,
          ) ??
          blocksHeroWarningBorder,
      blocksHeroChipBg:
          Color.lerp(blocksHeroChipBg, other.blocksHeroChipBg, t) ??
          blocksHeroChipBg,
      blocksOnGreenMuted:
          Color.lerp(blocksOnGreenMuted, other.blocksOnGreenMuted, t) ??
          blocksOnGreenMuted,
      pathsInfoSurface:
          Color.lerp(pathsInfoSurface, other.pathsInfoSurface, t) ??
          pathsInfoSurface,
      pathsInfoAccent:
          Color.lerp(pathsInfoAccent, other.pathsInfoAccent, t) ??
          pathsInfoAccent,
    );
    ServiceLocator.injectAppColors(appColors: appColors);
    return appColors;
  }
}
