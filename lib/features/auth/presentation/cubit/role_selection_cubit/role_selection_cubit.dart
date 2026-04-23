import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'role_selection_state.dart';

class RoleSelectionCubit extends Cubit<RoleSelectionState> {
  RoleSelectionCubit()
      : super(const RoleSelectionState(selectedRole: 'need_service'));

  void selectRole(String role) {
    emit(RoleSelectionState(selectedRole: role));
  }
}
