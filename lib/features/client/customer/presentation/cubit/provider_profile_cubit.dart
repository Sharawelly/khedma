import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/customer_entities.dart';
import '../../domain/usecases/customer_use_cases.dart';

part 'provider_profile_state.dart';

enum ProviderProfileAction { load, favorite }

class ProviderProfileCommand {
  const ProviderProfileCommand(this.action, this.providerId);
  final ProviderProfileAction action;
  final String providerId;
}

class ProviderProfileCubit extends Cubit<ProviderProfileState> {
  ProviderProfileCubit({
    required this.getProvider,
    required this.getProviderReviews,
    required this.toggleFavorite,
  }) : super(const ProviderProfileInitial());

  final GetProvider getProvider;
  final GetProviderReviews getProviderReviews;
  final ToggleFavorite toggleFavorite;
  ProviderProfileEntity? _profile;
  List<ProviderReviewEntity> _reviews = const <ProviderReviewEntity>[];

  Future<void> execute(ProviderProfileCommand command) async {
    if (command.action == ProviderProfileAction.favorite) {
      final result = await toggleFavorite(command.providerId);
      result.fold(
        (failure) => emit(ProviderProfileFailure(failure.message ?? '')),
        (isFavorite) {
          final profile = _profile;
          if (profile != null) {
            emit(ProviderProfileSuccess(profile, _reviews, isFavorite));
          }
        },
      );
      return;
    }
    emit(const ProviderProfileLoading());
    final profileResponse = await getProvider(command.providerId);
    final reviewsResponse = await getProviderReviews(command.providerId, 1);
    profileResponse.fold(
      (failure) => emit(ProviderProfileFailure(failure.message ?? '')),
      (profile) {
        reviewsResponse.fold(
          (failure) => emit(ProviderProfileFailure(failure.message ?? '')),
          (page) {
            _profile = profile;
            _reviews = page.items;
            emit(ProviderProfileSuccess(profile, page.items, false));
          },
        );
      },
    );
  }
}
