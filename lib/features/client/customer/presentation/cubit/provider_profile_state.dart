part of 'provider_profile_cubit.dart';

sealed class ProviderProfileState extends Equatable {
  const ProviderProfileState();
  @override
  List<Object?> get props => <Object?>[];
}

class ProviderProfileInitial extends ProviderProfileState {
  const ProviderProfileInitial();
}

class ProviderProfileLoading extends ProviderProfileState {
  const ProviderProfileLoading();
}

class ProviderProfileFailure extends ProviderProfileState {
  const ProviderProfileFailure(this.message);
  final String message;
  @override
  List<Object?> get props => <Object?>[message];
}

class ProviderProfileSuccess extends ProviderProfileState {
  const ProviderProfileSuccess(
    this.profile,
    this.reviews,
    this.isFavorite, {
    this.reviewsHaveNextPage = false,
  });
  final ProviderProfileEntity profile;
  final List<ProviderReviewEntity> reviews;
  final bool isFavorite;
  final bool reviewsHaveNextPage;
  @override
  List<Object?> get props => <Object?>[
    profile,
    reviews,
    isFavorite,
    reviewsHaveNextPage,
  ];
}
