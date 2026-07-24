import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/features/client/customer/domain/entities/customer_entities.dart';
import '/injection_container.dart';
import '../../../presentation/cubit/provider_reviews_cubit.dart';
import '../../../presentation/widgets/provider_state_widgets.dart';

class ProviderReviewsScreen extends StatelessWidget {
  const ProviderReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final providerId = sharedPreferences.getAuthUserId();
    if (providerId == null || providerId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('provider_my_reviews'.tr),
          leading: BackButton(onPressed: context.pop),
        ),
        body: ProviderErrorView('provider_identity_missing'.tr),
      );
    }
    return BlocProvider<ProviderReviewsCubit>(
      create: (_) =>
          ServiceLocator.instance<ProviderReviewsCubit>()
            ..execute(ProviderReviewsCommand.load(providerId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('provider_my_reviews'.tr),
          leading: BackButton(onPressed: context.pop),
        ),
        body: BlocConsumer<ProviderReviewsCubit, ProviderReviewsState>(
          listener: (context, state) {
            if (state is ProviderReviewsSuccess &&
                state.repliedReviewId != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('provider_review_reply_sent'.tr)),
              );
            }
          },
          builder: (context, state) {
            if (state is ProviderReviewsFailure) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ProviderErrorView(state.message),
                  TextButton(
                    onPressed: () => context
                        .read<ProviderReviewsCubit>()
                        .execute(ProviderReviewsCommand.load(providerId)),
                    child: Text('retry'.tr),
                  ),
                ],
              );
            }
            if (state is! ProviderReviewsSuccess) {
              return const ProviderLoadingView();
            }
            return _ReviewsBody(
              providerId: providerId,
              reviews: state.reviews,
              hasNextPage: state.hasNextPage,
            );
          },
        ),
      ),
    );
  }
}

class _ReviewsBody extends StatelessWidget {
  const _ReviewsBody({
    required this.providerId,
    required this.reviews,
    required this.hasNextPage,
  });

  final String providerId;
  final List<ProviderReviewEntity> reviews;
  final bool hasNextPage;

  @override
  Widget build(BuildContext context) {
    final average = reviews.isEmpty
        ? 0.0
        : reviews.fold<double>(0, (sum, item) => sum + item.rating) /
              reviews.length;
    return RefreshIndicator(
      onRefresh: () => context.read<ProviderReviewsCubit>().execute(
        ProviderReviewsCommand.load(providerId),
      ),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsetsDirectional.all(16.r),
        children: <Widget>[
          Container(
            padding: EdgeInsetsDirectional.all(16.r),
            decoration: BoxDecoration(
              color: colors.whiteColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: colors.onboardingBorderNeutral),
            ),
            child: Column(
              children: <Widget>[
                Text(
                  average.toStringAsFixed(1),
                  style: TextStyles.bold32(color: colors.authBrandRed),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(
                    5,
                    (index) => Icon(
                      Icons.star_rounded,
                      color: index < average.round()
                          ? colors.review
                          : colors.onboardingBorderNeutral,
                      size: 18.r,
                    ),
                  ),
                ),
                Gaps.vGap4,
                Text(
                  '${reviews.length} ${'provider_reviews_count'.tr}',
                  style: TextStyles.regular14(color: colors.homeCaption),
                ),
              ],
            ),
          ),
          Gaps.vGap16,
          if (reviews.isEmpty)
            Text(
              'provider_no_reviews'.tr,
              textAlign: TextAlign.center,
              style: TextStyles.medium16(color: colors.homeCaption),
            )
          else
            ...reviews.map(
              (review) => Padding(
                padding: EdgeInsetsDirectional.only(bottom: 12.h),
                child: _ReviewCard(
                  review: review,
                  onReply: () => _reply(context, review.id),
                ),
              ),
            ),
          if (hasNextPage)
            TextButton(
              onPressed: () => context.read<ProviderReviewsCubit>().execute(
                ProviderReviewsCommand.loadMore(providerId),
              ),
              child: Text('load_more'.tr),
            ),
        ],
      ),
    );
  }

  Future<void> _reply(BuildContext context, String reviewId) async {
    final controller = TextEditingController();
    final reply = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('provider_reviews_write_reply'.tr),
        content: TextField(
          controller: controller,
          minLines: 3,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'provider_review_reply_hint'.tr,
          ),
        ),
        actions: <Widget>[
          TextButton(onPressed: dialogContext.pop, child: Text('cancel'.tr)),
          FilledButton(
            onPressed: () {
              final value = controller.text.trim();
              if (value.isNotEmpty) {
                dialogContext.pop(value);
              }
            },
            child: Text('provider_send_reply'.tr),
          ),
        ],
      ),
    );
    controller.dispose();
    if (reply != null && context.mounted) {
      await context.read<ProviderReviewsCubit>().execute(
        ProviderReviewsCommand.reply(
          providerId: providerId,
          reviewId: reviewId,
          reply: reply,
        ),
      );
    }
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review, required this.onReply});

  final ProviderReviewEntity review;
  final VoidCallback onReply;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(14.r),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.onboardingBorderNeutral),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 20.r,
                backgroundImage: review.customerAvatarUrl == null
                    ? null
                    : NetworkImage(review.customerAvatarUrl!),
                child: review.customerAvatarUrl == null
                    ? const Icon(Icons.person_rounded)
                    : null,
              ),
              Gaps.hGap10,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      review.customerName,
                      style: TextStyles.bold16(
                        color: colors.onboardingHeadline,
                      ),
                    ),
                    Text(
                      review.createdAt.toLocal().toString(),
                      style: TextStyles.regular12(color: colors.homeCaption),
                    ),
                  ],
                ),
              ),
              Text(
                '${review.rating.toStringAsFixed(1)} ★',
                style: TextStyles.bold14(color: colors.secondary),
              ),
            ],
          ),
          if (review.comment?.isNotEmpty == true) ...<Widget>[
            Gaps.vGap10,
            Text(
              review.comment!,
              style: TextStyles.regular14(color: colors.onboardingBody),
            ),
          ],
          Gaps.vGap8,
          TextButton.icon(
            onPressed: onReply,
            icon: const Icon(Icons.reply_rounded),
            label: Text('provider_reviews_write_reply'.tr),
          ),
        ],
      ),
    );
  }
}
