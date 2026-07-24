import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/config/locale/app_locale_cubit.dart';
import '/injection_container.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/repositories/auth_repo_impl.dart';
import 'domain/repositories/auth_repo.dart';
import 'domain/usecases/delete_account_use_case.dart';
import 'domain/usecases/forgot_password_use_case.dart';
import 'domain/usecases/get_profile_use_case.dart';
import 'domain/usecases/login_use_case.dart';
import 'domain/usecases/logout_use_case.dart';
import 'domain/usecases/register_customer_use_case.dart';
import 'domain/usecases/register_provider_use_case.dart';
import 'domain/usecases/reset_password_use_case.dart';
import 'presentation/cubit/auto_login/auto_login_cubit.dart';
import 'presentation/cubit/create_account_form_cubit/create_account_form_cubit.dart';
import 'presentation/cubit/delete_account_cubit/delete_account_cubit.dart';
import 'presentation/cubit/forgot_password_cubit/forgot_password_cubit.dart';
import 'presentation/cubit/language_preference_cubit/language_preference_cubit.dart';
import 'presentation/cubit/login/login_cubit.dart';
import 'presentation/cubit/logout_cubit/logout_cubit.dart';
import 'presentation/cubit/profile_cubit/profile_cubit.dart';
import 'presentation/cubit/register_cubit/register_cubit.dart';
import 'presentation/cubit/reset_password_cubit/reset_password_cubit.dart';
import 'presentation/cubit/role_selection_cubit/role_selection_cubit.dart';

final _sl = ServiceLocator.instance;

Future<void> initAuthFeatureInjection() async {
  _sl
    ..registerFactory<LoginCubit>(() => LoginCubit(loginUseCase: _sl()))
    ..registerFactory<RegisterCubit>(
      () => RegisterCubit(
        registerCustomerUseCase: _sl(),
        registerProviderUseCase: _sl(),
      ),
    )
    ..registerFactory<ProfileCubit>(
      () => ProfileCubit(getProfileUseCase: _sl()),
    )
    ..registerFactory<LogoutCubit>(() => LogoutCubit(logoutUseCase: _sl()))
    ..registerFactory<DeleteAccountCubit>(
      () => DeleteAccountCubit(deleteAccountUseCase: _sl()),
    )
    ..registerFactory<AutoLoginCubit>(AutoLoginCubit.new)
    ..registerFactory<CreateAccountFormCubit>(CreateAccountFormCubit.new)
    ..registerFactory<LanguagePreferenceCubit>(
      () => LanguagePreferenceCubit(appLocaleCubit: _sl<AppLocaleCubit>()),
    )
    ..registerFactory<RoleSelectionCubit>(RoleSelectionCubit.new)
    ..registerFactory<ForgotPasswordCubit>(
      () => ForgotPasswordCubit(forgotPasswordUseCase: _sl()),
    )
    ..registerFactory<ResetPasswordCubit>(
      () => ResetPasswordCubit(resetPasswordUseCase: _sl()),
    )
    ..registerLazySingleton<LoginUseCase>(() => LoginUseCase(repository: _sl()))
    ..registerLazySingleton<RegisterCustomerUseCase>(
      () => RegisterCustomerUseCase(repository: _sl()),
    )
    ..registerLazySingleton<RegisterProviderUseCase>(
      () => RegisterProviderUseCase(repository: _sl()),
    )
    ..registerLazySingleton<GetProfileUseCase>(
      () => GetProfileUseCase(repository: _sl()),
    )
    ..registerLazySingleton<LogoutUseCase>(
      () => LogoutUseCase(repository: _sl()),
    )
    ..registerLazySingleton<DeleteAccountUseCase>(
      () => DeleteAccountUseCase(repository: _sl()),
    )
    ..registerLazySingleton<ForgotPasswordUseCase>(
      () => ForgotPasswordUseCase(repository: _sl()),
    )
    ..registerLazySingleton<ResetPasswordUseCase>(
      () => ResetPasswordUseCase(repository: _sl()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remote: _sl()),
    )
    ..registerLazySingleton<AuthRemoteDataSource>(AuthRemoteDataSourceImpl.new);
}

List<BlocProvider> get authBlocs => <BlocProvider>[
  BlocProvider<AutoLoginCubit>(
    create: (BuildContext context) => _sl<AutoLoginCubit>(),
  ),
  BlocProvider<RegisterCubit>(
    create: (BuildContext context) => _sl<RegisterCubit>(),
  ),
];
