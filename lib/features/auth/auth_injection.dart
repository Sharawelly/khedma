import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/config/locale/app_locale_cubit.dart';
import '/features/auth/domain/usecases/delete_account_use_case.dart';
import '/features/auth/domain/usecases/forgot_password_use_case.dart';

import '/features/auth/domain/usecases/get_profile_use_case.dart';
import '/features/auth/domain/usecases/login_with_password_use_case.dart';
import '/features/auth/domain/usecases/logout_use_case.dart';
import '/features/auth/domain/usecases/register_with_password_use_case.dart';
import '/features/auth/domain/usecases/reset_password_use_case.dart';
import '/features/auth/presentation/cubit/accept_terms_cubit/accept_terms_cubit.dart';
import '/features/auth/presentation/cubit/create_account_form_cubit/create_account_form_cubit.dart';
import '/features/auth/presentation/cubit/language_preference_cubit/language_preference_cubit.dart';
import '/features/auth/presentation/cubit/role_selection_cubit/role_selection_cubit.dart';
import '/features/auth/presentation/cubit/country_selection_cubit/country_selection_cubit.dart';
import '/features/auth/presentation/cubit/delete_account_cubit/delete_account_cubit.dart';

import '/features/auth/presentation/cubit/logout_cubit/logout_cubit.dart';
import '/features/auth/presentation/cubit/register_cubit/register_cubit.dart';
import '../../injection_container.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/repositories/auth_repo_impl.dart';
import 'domain/repositories/auth_repo.dart';

import 'domain/usecases/get_user_role_usecase.dart';
import 'domain/usecases/get_user_type_usecase.dart';
import 'domain/usecases/save_user_role.dart';
import 'domain/usecases/save_user_type_usecase.dart';
import 'presentation/cubit/auto_login/auto_login_cubit.dart';
import 'presentation/cubit/forgot_password_cubit/forgot_password_cubit.dart';

import 'presentation/cubit/reset_password_cubit/reset_password_cubit.dart';
import 'presentation/cubit/login/login_cubit.dart';
import 'presentation/cubit/login_form_cubit/login_form_cubit.dart';
import 'presentation/cubit/profile_cubit/profile_cubit.dart';

final _sl = ServiceLocator.instance;

Future<void> initAuthFeatureInjection() async {
  ///-> Cubits

  _sl.registerFactory<LoginCubit>(
    () => LoginCubit(loginWithPasswordUseCase: _sl()),
  );

  _sl.registerFactory<RegisterCubit>(
    () => RegisterCubit(registerWithPasswordUseCase: _sl()),
  );

  _sl.registerLazySingleton<ProfileCubit>(
    () => ProfileCubit(getProfileUseCase: _sl()),
  );

  _sl.registerFactory<LogoutCubit>(() => LogoutCubit(logoutUseCase: _sl()));

  _sl.registerFactory<DeleteAccountCubit>(
    () => DeleteAccountCubit(deleteAccountUseCase: _sl()),
  );

  _sl.registerFactory<AutoLoginCubit>(
    () => AutoLoginCubit(
      getUserTypeUseCase: _sl(),
      saveUserTypeUseCase: _sl(),
      getUserCycleUseCase: _sl(),
      saveUserCycleUseCase: _sl(),
    ),
  );
  _sl.registerFactory<AcceptTermsCubit>(() => AcceptTermsCubit());
  _sl.registerFactory<CreateAccountFormCubit>(() => CreateAccountFormCubit());
  _sl.registerFactory<LanguagePreferenceCubit>(
    () => LanguagePreferenceCubit(appLocaleCubit: _sl<AppLocaleCubit>()),
  );
  _sl.registerFactory<RoleSelectionCubit>(() => RoleSelectionCubit());
  _sl.registerFactory<CountrySelectionCubit>(() => CountrySelectionCubit());
  _sl.registerFactory<LoginFormCubit>(() => LoginFormCubit());
  _sl.registerFactory<ForgotPasswordCubit>(
    () => ForgotPasswordCubit(forgotPasswordUseCase: _sl()),
  );
  _sl.registerFactory<ResetPasswordCubit>(
    () => ResetPasswordCubit(resetPasswordUseCase: _sl()),
  );

  ///-> UseCases

  _sl.registerLazySingleton<GetUserTypeUseCase>(
    () => GetUserTypeUseCase(repository: _sl()),
  );
  _sl.registerLazySingleton<GetUserCycleUseCase>(
    () => GetUserCycleUseCase(repository: _sl()),
  );
  _sl.registerLazySingleton<SaveUserTypeUseCase>(
    () => SaveUserTypeUseCase(repository: _sl()),
  );
  _sl.registerLazySingleton<SaveUserCycleUseCase>(
    () => SaveUserCycleUseCase(repository: _sl()),
  );
  _sl.registerLazySingleton<LoginWithPasswordUseCase>(
    () => LoginWithPasswordUseCase(repository: _sl()),
  );

  _sl.registerLazySingleton<RegisterWithPasswordUseCase>(
    () => RegisterWithPasswordUseCase(repository: _sl()),
  );

  _sl.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(repository: _sl()),
  );
  _sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(repository: _sl()),
  );

  _sl.registerLazySingleton<DeleteAccountUseCase>(
    () => DeleteAccountUseCase(repository: _sl()),
  );
  _sl.registerLazySingleton<ForgotPasswordUseCase>(
    () => ForgotPasswordUseCase(repository: _sl()),
  );
  _sl.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(repository: _sl()),
  );

  ///-> Repository
  _sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remote: _sl()),
  );

  ///-> DataSource
  _sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
}

///-> BlocProvider
List<BlocProvider> get authBlocs => <BlocProvider>[
  BlocProvider<AutoLoginCubit>(
    create: (BuildContext context) => _sl<AutoLoginCubit>(),
  ),
  BlocProvider<RegisterCubit>(
    create: (BuildContext context) => _sl<RegisterCubit>(),
  ),
];
