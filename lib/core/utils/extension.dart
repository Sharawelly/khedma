import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../injection_container.dart';
import 'enums.dart';
import 'values/strings.dart';

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
