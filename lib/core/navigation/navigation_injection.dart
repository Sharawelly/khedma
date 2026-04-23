import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/navigation/cubit/navigation_cubit.dart';
import '/injection_container.dart';

final _sl = ServiceLocator.instance;

Future<void> initNavigationInjection() async {
  ///-> Cubits
  _sl.registerLazySingleton<NavigationCubit>(() => NavigationCubit());
}

///-> BlocProvider
List<BlocProvider> get navigationBlocs => <BlocProvider>[
  BlocProvider<NavigationCubit>(
    create: (BuildContext context) => _sl<NavigationCubit>(),
  ),
];
