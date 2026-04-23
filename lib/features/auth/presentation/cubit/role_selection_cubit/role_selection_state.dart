part of 'role_selection_cubit.dart';

class RoleSelectionState extends Equatable {
  final String? selectedRole;

  const RoleSelectionState({this.selectedRole});

  RoleSelectionState copyWith({String? selectedRole}) {
    return RoleSelectionState(selectedRole: selectedRole ?? this.selectedRole);
  }

  bool get hasSelection => selectedRole != null && selectedRole!.isNotEmpty;

  @override
  List<Object?> get props => [selectedRole];
}
