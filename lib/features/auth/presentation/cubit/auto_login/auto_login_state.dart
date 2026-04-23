part of 'auto_login_cubit.dart';

class AutoLoginState extends Equatable {
  const AutoLoginState();

  @override
  List<Object?> get props => <Object?>[];
}

class AutoLoginUserTypeState extends AutoLoginState {
  final UserType userType;
  final String? message;

  const AutoLoginUserTypeState({this.userType = UserType.user, this.message});
}

class AutoLoginUserCycleState extends AutoLoginState {
  final UserCycle userCycle;
  final String? message;

  const AutoLoginUserCycleState({
    this.userCycle = UserCycle.firstOpen,
    this.message,
  });
}
