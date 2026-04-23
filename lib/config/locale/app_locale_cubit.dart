import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/services/local_storage/app_shared_preferences.dart';

/// Drives [MaterialApp.locale] so [Directionality] matches the active language.
class AppLocaleCubit extends Cubit<Locale> {
  AppLocaleCubit(AppSharedPreferences prefs)
      : super(Locale(prefs.getLanguageCode().name));

  void setLocale(Locale value) => emit(value);
}
