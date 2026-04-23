import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/config/locale/app_locale_cubit.dart';
import '/core/utils/enums.dart';
import '/injection_container.dart';

part 'language_preference_state.dart';

class LanguagePreferenceCubit extends Cubit<LanguagePreferenceState> {
  LanguagePreferenceCubit({required AppLocaleCubit appLocaleCubit})
      : _appLocaleCubit = appLocaleCubit,
        super(
          LanguagePreferenceState(
            selected: sharedPreferences.getLanguageCode(),
          ),
        );

  final AppLocaleCubit _appLocaleCubit;

  Future<void> selectLanguage(LanguageCode lang) async {
    if (state.selected == lang) return;
    await appLocalizations.load(locale: Locale(lang.name));
    ServiceLocator.injectAppLocalizations(appLocalizations: appLocalizations);
    _appLocaleCubit.setLocale(Locale(lang.name));
    emit(LanguagePreferenceState(selected: lang));
  }

  Future<void> persistSelectedLanguage() async {
    await sharedPreferences.saveLanguageCode(state.selected.name);
  }
}
