import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/profile_entity.dart';
import '../../../domain/usecases/get_profile_use_case.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;

  ProfileCubit({required this.getProfileUseCase}) : super(ProfileInitial());

  Future<void> getProfile() async {
    emit(ProfileIsLoading());
    final profileResult = await getProfileUseCase();
    profileResult.fold(
      (failure) => emit(ProfileError(failure.message ?? '')),
      (profile) => emit(ProfileLoaded(profile: profile)),
    );
  }
}
