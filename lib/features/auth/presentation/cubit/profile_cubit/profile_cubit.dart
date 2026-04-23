import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/base_classes/base_one_response.dart';
import '/core/usecases/usecase.dart';
import '../../../data/models/auth_resp_model.dart';
import '../../../domain/entities/auth_entity.dart';
import '../../../domain/usecases/get_profile_use_case.dart';
import '/injection_container.dart';
import '/core/error/failures.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;

  ProfileCubit({required this.getProfileUseCase}) : super(ProfileInitial());

  /// Load profile from cached data in SharedPreferences
  void loadCachedProfile() {
    if (isClosed) return;
    final user = sharedPreferences.getUser();
    if (user != null) {
      emit(ProfileLoaded(user: user));
    }
  }

  /// Set user profile directly (used after profile update)
  void setProfile(UserEntity user) {
    if (isClosed) {
      debugPrint('setProfile: Cubit is closed, cannot emit state');
      // Even if cubit is closed, ensure SharedPreferences is updated
      // (it should already be updated in repository, but double-check)
      try {
        final userModel = user as UserModel;
        sharedPreferences.saveUser(userModel);
        debugPrint('setProfile: SharedPreferences updated as fallback (:');
      } catch (e) {
        debugPrint('setProfile: Error updating SharedPreferences: $e');
      }
      return;
    }

    debugPrint(
      'setProfile: Updating ProfileCubit state with user: ${user.name}',
    );
    emit(ProfileLoaded(user: user));
  }

  Future<void> getProfile() async {
    emit(ProfileIsLoading());
    try {
      final Either<Failure, BaseOneResponse> eitherResult =
          await getProfileUseCase(NoParams());
      eitherResult.fold(
        (Failure failure) {
          emit(ProfileError(failure.message ?? ''));
        },
        (BaseOneResponse response) {
          final authModel = response.data as AuthModel;
          emit(ProfileLoaded(user: authModel.user));
        },
      );
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  /// Reset cubit to initial state - used on logout
  void reset() {
    if (!isClosed) {
      emit(ProfileInitial());
    }
  }
}
