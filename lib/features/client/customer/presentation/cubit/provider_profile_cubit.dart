import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/customer_entities.dart';
import '../../domain/usecases/customer_use_cases.dart';

part 'provider_profile_state.dart';

enum ProviderProfileAction { load, loadMoreReviews, favorite }

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
  int _reviewsPage = 1;
  bool _reviewsHaveNextPage = false;
  bool _loadingMoreReviews = false;
  bool _isFavorite = false;

  Future<void> execute(ProviderProfileCommand command) async {
    if (command.action == ProviderProfileAction.favorite) {
      final result = await toggleFavorite(command.providerId);
      result.fold(
        (failure) => emit(ProviderProfileFailure(failure.message ?? '')),
        (isFavorite) {
          _isFavorite = isFavorite;
          final profile = _profile;
          if (profile != null) {
            emit(
              ProviderProfileSuccess(
                profile,
                _reviews,
                _isFavorite,
                reviewsHaveNextPage: _reviewsHaveNextPage,
              ),
            );
          }
        },
      );
      return;
    }
    if (command.action == ProviderProfileAction.loadMoreReviews) {
      await _loadMoreReviews(command.providerId);
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
            _reviewsPage = page.pagination.page ?? 1;
            _reviewsHaveNextPage = page.pagination.hasNextPage ?? false;
            emit(
              ProviderProfileSuccess(
                profile,
                page.items,
                _isFavorite,
                reviewsHaveNextPage: _reviewsHaveNextPage,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _loadMoreReviews(String providerId) async {
    if (_loadingMoreReviews || !_reviewsHaveNextPage) {
      return;
    }
    _loadingMoreReviews = true;
    final requestedPage = _reviewsPage + 1;
    final response = await getProviderReviews(providerId, requestedPage);
    response.fold(
      (failure) => emit(ProviderProfileFailure(failure.message ?? '')),
      (page) {
        _reviews = <ProviderReviewEntity>[..._reviews, ...page.items];
        _reviewsPage = page.pagination.page ?? requestedPage;
        _reviewsHaveNextPage = page.pagination.hasNextPage ?? false;
        final profile = _profile;
        if (profile != null) {
          emit(
            ProviderProfileSuccess(
              profile,
              _reviews,
              _isFavorite,
              reviewsHaveNextPage: _reviewsHaveNextPage,
            ),
          );
        }
      },
    );
    _loadingMoreReviews = false;
  }
}
