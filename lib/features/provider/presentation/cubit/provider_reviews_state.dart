part of 'provider_reviews_cubit.dart';

sealed class ProviderReviewsState extends Equatable {
  const ProviderReviewsState();

  @override
  List<Object?> get props => <Object?>[];
}

class ProviderReviewsInitial extends ProviderReviewsState {
  const ProviderReviewsInitial();
}

class ProviderReviewsLoading extends ProviderReviewsState {
  const ProviderReviewsLoading();
}

class ProviderReviewsSuccess extends ProviderReviewsState {
  const ProviderReviewsSuccess(this.reviews, {this.repliedReviewId});

  final List<ProviderReviewEntity> reviews;
  final String? repliedReviewId;

  @override
  List<Object?> get props => <Object?>[reviews, repliedReviewId];
}

class ProviderReviewsFailure extends ProviderReviewsState {
  const ProviderReviewsFailure(this.message);
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
