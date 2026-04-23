import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/features/provider/presentation/cubit/provider_navigation_cubit/provider_navigation_cubit.dart';
import 'package:khedma/injection_container.dart';

final _sl = ServiceLocator.instance;

void initProviderFeatureInjection() {
  _sl.registerLazySingleton<ProviderNavigationCubit>(
    () => ProviderNavigationCubit(),
  );
}

List<BlocProvider<dynamic>> get providerBlocs => <BlocProvider<dynamic>>[
      BlocProvider<ProviderNavigationCubit>(
        create: (_) => _sl<ProviderNavigationCubit>(),
      ),
    ];
