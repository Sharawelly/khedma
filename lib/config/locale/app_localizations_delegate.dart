import 'dart:developer';

import 'package:flutter/material.dart' show Locale, LocalizationsDelegate;

import '../../core/utils/enums.dart';
import '../../injection_container.dart';
import 'app_localizations.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();
  @override
  bool isSupported(Locale locale) {
    return [
      LanguageCode.ar.name,
      LanguageCode.en.name,
    ].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations appLocalizations = AppLocalizations(locale);
    await appLocalizations.load();
    log('AppLocalizationsDelegate: loaded locale ${locale.languageCode}');
    ServiceLocator.injectAppLocalizations(appLocalizations: appLocalizations);
    return appLocalizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
