import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/config/routes/app_routes.dart';
import '/injection_container.dart';
import '../../auth_role_navigation.dart';

part 'auto_login_state.dart';

class AutoLoginCubit extends Cubit<AutoLoginState> {
  late final StreamSubscription<void> _unauthorizedSubscription;

  AutoLoginCubit() : super(AutoLoginInitial()) {
    _unauthorizedSubscription = eventBus.unauthorizedStream.listen((_) {
      emit(AutoLoginUnauthenticated());
      Routes.router.go(Routes.loginScreenRoute);
    });
  }

  Future<void> checkSession() async {
    emit(AutoLoginLoading());
    final accessToken = await secureStorage.getAccessToken();
    final role = sharedPreferences.getUserRole();
    final destination = role == null
        ? null
        : AuthRoleNavigation.routeForRole(role);
    if (accessToken == null || accessToken.isEmpty || destination == null) {
      emit(AutoLoginUnauthenticated());
      return;
    }
    emit(AutoLoginAuthenticated(destination: destination));
  }

  @override
  Future<void> close() async {
    await _unauthorizedSubscription.cancel();
    return super.close();
  }
}
