import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/core/utils/enums.dart';
import '../../../domain/usecases/get_user_role_usecase.dart';
import '../../../domain/usecases/get_user_type_usecase.dart';
import '../../../domain/usecases/save_user_role.dart';
import '../../../domain/usecases/save_user_type_usecase.dart';

part 'auto_login_state.dart';

class AutoLoginCubit extends Cubit<AutoLoginState> {
  final GetUserTypeUseCase getUserTypeUseCase;
  final GetUserCycleUseCase getUserCycleUseCase;
  final SaveUserTypeUseCase saveUserTypeUseCase;
  final SaveUserCycleUseCase saveUserCycleUseCase;
  AutoLoginCubit({
    required this.getUserCycleUseCase,
    required this.saveUserCycleUseCase,
    required this.getUserTypeUseCase,
    required this.saveUserTypeUseCase,
  }) : super(const AutoLoginState());

  UserType userType = UserType.user;
  UserCycle userCycle = UserCycle.firstOpen;

  Future<UserType> getUserType() async {
    Either<Failure, UserType> result = await getUserTypeUseCase.call(
      NoParams(),
    );

    result.fold(
      (Failure fail) {
        emit(AutoLoginUserTypeState(message: fail.message, userType: userType));
      },
      (UserType value) {
        userType = value;
        emit(AutoLoginUserTypeState(userType: userType));
      },
    );

    return userType;
  }

  Future<void> getUserCycle() async {
    final Either<Failure, UserCycle> result = await getUserCycleUseCase.call(
      NoParams(),
    );
    await Future<void>.delayed(const Duration(milliseconds: 1750), () {
      result.fold(
        (Failure fail) {
          emit(
            AutoLoginUserCycleState(
              message: fail.message,
              userCycle: userCycle,
            ),
          );
        },
        (UserCycle value) {
          userCycle = value;
          emit(AutoLoginUserCycleState(userCycle: userCycle));
        },
      );
    });
  }

  Future<void> saveUserType({required UserType type}) async {
    final Either<Failure, bool> result = await saveUserTypeUseCase(
      SaveUserTypeParams(type: type),
    );
    await Future<void>.delayed(const Duration(milliseconds: 500), () {
      result.fold(
        (Failure fail) {
          emit(
            AutoLoginUserTypeState(message: fail.message, userType: userType),
          );
        },
        (bool value) {
          userType = type;
          emit(AutoLoginUserTypeState(userType: userType));
        },
      );
    });
  }

  Future<void> saveUserCycle({required UserCycle type}) async {
    final Either<Failure, bool> result = await saveUserCycleUseCase(
      SaveUserCycleParams(type: type),
    );
    await Future<void>.delayed(const Duration(milliseconds: 500), () {
      result.fold(
        (Failure fail) {
          emit(
            AutoLoginUserCycleState(
              message: fail.message,
              userCycle: userCycle,
            ),
          );
        },
        (bool value) {
          userCycle = type;
          emit(AutoLoginUserCycleState(userCycle: userCycle));
        },
      );
    });
  }

  void fLogout() {
    // ServiceLocator.instance<GetProfileCubit>().updateUser(null);
    saveUserCycle(type: UserCycle.login);
  }

  /// Enter guest mode: save cycle as guest and emit so splash can navigate to main.
  Future<void> enterGuestMode() async {
    await saveUserCycle(type: UserCycle.guest);
  }
}
