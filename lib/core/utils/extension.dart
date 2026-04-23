import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../injection_container.dart';
import 'enums.dart';
import 'values/strings.dart';

extension ImageExtension on num {
  int cacheSize(BuildContext context) {
    return (this * MediaQuery.of(context).devicePixelRatio).round();
  }
}

extension StatusLevelExtension on StatusLevel {
  static StatusLevel fromString(String value) {
    for (StatusLevel type in StatusLevel.values) {
      if (type.name.toLowerCase() == value.toLowerCase()) {
        return type;
      }
    }
    throw Exception('$value is not a valid TripType');
  }
}

extension LanguageCodeExtension on LanguageCode {
  static LanguageCode fromString(String value) =>
      LanguageCode.values.firstWhere(
        (LanguageCode element) => element.name == value,
        orElse: () => LanguageCode.ar,
      );

  String get displayName {
    switch (this) {
      case LanguageCode.en:
        return Strings.english;
      case LanguageCode.ar:
        return Strings.arabic;
    }
  }
}

extension ThemesExtension on Themes {
  static Themes fromString(String value) => Themes.values.firstWhere(
    (Themes element) => element.name == value,
    orElse: () => Themes.light,
  );
}

extension UserTypeExtension on UserType {
  static UserType fromString(String value) => UserType.values.firstWhere(
    (UserType element) => element.name == value,
    orElse: () => UserType.user,
  );
}

extension UserCycleExtension on UserCycle {
  static UserCycle fromString(String value) => UserCycle.values.firstWhere(
    (UserCycle element) => element.name == value,
    orElse: () => UserCycle.firstOpen,
  );
}

extension StringExtension on String {
  Future<void> get launcherUrl async {
    Uri? uri = Uri.tryParse(this);
    if (uri == null) {
      throw 'Could not launch $this';
    }
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $this';
    }
  }
}

extension DateTimeExtension on DateTime {
  String get displayDate {
    String day = this.day.toString();
    String month = this.month.toString();
    String year = this.year.toString();
    if (day.length == 1) {
      day = '0$day';
    }
    if (month.length == 1) {
      month = '0$month';
    }
    return '$year-$month-$day';
  }

  String get displayDateNamed => DateFormat.yMMMMd(
    appLocalizations.isArLocale ? 'ar_SA' : 'en_US',
  ).format(this);
}

extension FormDataExtension on FormData {
  String get toPrint {
    List<String> list = [];
    Map<String, dynamic> result = {};
    for (final item in fields) {
      result.addAll({item.key: item.value});
      list.add('${item.key}:${item.value}');
    }
    for (final item in files) {
      result.addAll({item.key: item.value.filename});
      list.add('${item.key}:${item.value.filename}');
    }
    return list.toString();
  }
}

extension UserStatusExtension on UserStatus {
  static UserStatus fromString(String value) {
    for (UserStatus type in UserStatus.values) {
      if (type.name.toLowerCase() == value.toLowerCase()) {
        return type;
      }
    }
    throw Exception('$value is not a valid UserStatus');
  }
}

extension ColorFilterExtension on ColorFilter {
  static ColorFilter getFocustextColor(FocusNode focusNode) {
    return ColorFilter.mode(
      focusNode.hasFocus ? colors.main : colors.textColor,
      BlendMode.srcIn,
    );
  }

  static ColorFilter setColor(Color color) {
    return ColorFilter.mode(color, BlendMode.srcIn);
  }
}

extension AppUpdateTypeExtension on AppUpdateType {
  static AppUpdateType fromString(String value) {
    for (AppUpdateType type in AppUpdateType.values) {
      if (type.name.toLowerCase() == value.toLowerCase()) {
        return type;
      }
    }
    throw Exception('$value is not a valid AppUpdateType');
  }
}

extension CircularProgressIndicatorExtension on CircularProgressIndicator {
  CircularProgressIndicator get appLoading {
    if (color != null) {
      return CircularProgressIndicator(
        key: key,
        strokeWidth: 4.r,
        valueColor: valueColor,
        color: color,
        backgroundColor: backgroundColor,
        semanticsLabel: semanticsLabel,
        semanticsValue: semanticsValue,
        value: value,
        strokeAlign: strokeAlign,
        strokeCap: strokeCap,
      );
    }
    return CircularProgressIndicator.adaptive(
      key: key,
      strokeWidth: 4.r,
      valueColor: valueColor,
      backgroundColor: backgroundColor,
      semanticsLabel: semanticsLabel,
      semanticsValue: semanticsValue,
      value: value,
      strokeAlign: strokeAlign,
      strokeCap: strokeCap,
    );
  }
}

extension RoundOnlyDouble on double {
  double mRoundDouble(int places) {
    num mod = pow(10.0, places);
    return ((this * mod).round().toDouble() / mod);
  }
}
