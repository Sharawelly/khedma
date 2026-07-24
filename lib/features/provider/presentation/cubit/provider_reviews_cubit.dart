import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/features/client/customer/domain/entities/customer_entities.dart';
import '/features/client/customer/domain/usecases/customer_use_cases.dart';
import '../../domain/usecases/params/provider_params.dart';
import '../../domain/usecases/provider_use_cases.dart';

part 'provider_reviews_state.dart';

enum ProviderReviewsAction { load, reply }

class ProviderReviewsCommand {
  const ProviderReviewsCommand._(
    this.action, {
    required this.providerId,
    this.reviewId,
    this.reply,
  });

  const ProviderReviewsCommand.load(String providerId)
    : this._(ProviderReviewsAction.load, providerId: providerId);
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

  Future<void> execute(ProviderReviewsCommand command) async {
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
        emit(ProviderReviewsFailure(failureMessage));
        return;
      }
      emit(ProviderReviewsSuccess(_reviews, repliedReviewId: command.reviewId));
      return;
    }
    final result = await getReviews(command.providerId, 1);
    result.fold(
      (failure) => emit(
        ProviderReviewsFailure(failure.message ?? 'provider_request_failed'),
      ),
      (page) {
        _reviews = page.items;
        emit(ProviderReviewsSuccess(_reviews));
      },
    );
  }
}
