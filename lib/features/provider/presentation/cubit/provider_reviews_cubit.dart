import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/features/client/customer/domain/entities/customer_entities.dart';
import '/features/client/customer/domain/usecases/customer_use_cases.dart';
import '../../domain/usecases/params/provider_params.dart';
import '../../domain/usecases/provider_use_cases.dart';

part 'provider_reviews_state.dart';

enum ProviderReviewsAction { load, loadMore, reply }

class ProviderReviewsCommand {
  const ProviderReviewsCommand._(
    this.action, {
    required this.providerId,
    this.reviewId,
    this.reply,
  });

  const ProviderReviewsCommand.load(String providerId)
    : this._(ProviderReviewsAction.load, providerId: providerId);
  const ProviderReviewsCommand.loadMore(String providerId)
    : this._(ProviderReviewsAction.loadMore, providerId: providerId);
  const ProviderReviewsCommand.reply({
    required String providerId,
    required String reviewId,
    required String reply,
  }) : this._(
         ProviderReviewsAction.reply,
         providerId: providerId,
         reviewId: reviewId,
         reply: reply,
       );

  final ProviderReviewsAction action;
  final String providerId;
  final String? reviewId;
  final String? reply;
}

class ProviderReviewsCubit extends Cubit<ProviderReviewsState> {
  ProviderReviewsCubit({required this.getReviews, required this.replyToReview})
    : super(const ProviderReviewsInitial());

  final GetProviderReviews getReviews;
  final ReplyToProviderReview replyToReview;
  List<ProviderReviewEntity> _reviews = const <ProviderReviewEntity>[];
  int _page = 1;
  bool _hasNextPage = false;
  bool _isLoading = false;

  Future<void> execute(ProviderReviewsCommand command) async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;
    emit(const ProviderReviewsLoading());
    if (command.action == ProviderReviewsAction.reply) {
      final result = await replyToReview(
        ProviderReviewReplyParams(
          reviewId: command.reviewId!,
          reply: command.reply!,
        ),
      );
      final failureMessage = result.fold<String?>(
        (failure) => failure.message ?? 'provider_review_reply_failed',
        (_) => null,
      );
      if (failureMessage != null) {
        _isLoading = false;
        emit(ProviderReviewsFailure(failureMessage));
        return;
      }
      _isLoading = false;
      emit(
        ProviderReviewsSuccess(
          _reviews,
          hasNextPage: _hasNextPage,
          repliedReviewId: command.reviewId,
        ),
      );
      return;
    }
    final requestedPage = command.action == ProviderReviewsAction.loadMore
        ? _page + 1
        : 1;
    final result = await getReviews(command.providerId, requestedPage);
    result.fold(
      (failure) {
        _isLoading = false;
        emit(
          ProviderReviewsFailure(failure.message ?? 'provider_request_failed'),
        );
      },
      (page) {
        _reviews = command.action == ProviderReviewsAction.loadMore
            ? <ProviderReviewEntity>[..._reviews, ...page.items]
            : page.items;
        _page = page.pagination.page ?? requestedPage;
        _hasNextPage = page.pagination.hasNextPage ?? false;
        _isLoading = false;
        emit(ProviderReviewsSuccess(_reviews, hasNextPage: _hasNextPage));
      },
    );
  }
}
