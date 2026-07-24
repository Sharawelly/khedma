import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/values/text_styles.dart';
import '/features/client/customer/domain/entities/customer_entities.dart';
import '/features/client/customer/domain/usecases/params/customer_params.dart';
import '/features/client/customer/presentation/cubit/booking_cubit.dart';
import '/features/client/customer/presentation/widgets/cancel_booking_dialog.dart';
import '/features/client/customer/presentation/widgets/customer_state_widgets.dart';
import '/features/shared/chat/domain/entities/chat_entities.dart';
import '/injection_container.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key, required this.bookingId});
  final String bookingId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingCubit>(
      create: (_) =>
          ServiceLocator.instance()..execute(BookingCommand.detail(bookingId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('bookings_details_title'.tr),
          leading: BackButton(onPressed: context.pop),
        ),
        body: BlocBuilder<BookingCubit, BookingState>(
          builder: (_, state) {
            if (state is BookingFailure) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomerErrorView(state.message),
                  Builder(
                    builder: (context) => TextButton(
                      onPressed: () => context.read<BookingCubit>().execute(
                        BookingCommand.detail(bookingId),
                      ),
                      child: Text('retry'.tr),
                    ),
                  ),
                ],
              );
            }
            if (state is! BookingDetailSuccess) {
              return const CustomerLoadingView();
            }
            return _BookingBody(
              booking: state.booking,
              realtimeSnapshot: state.realtime,
              review: state.review,
            );
          },
        ),
      ),
    );
  }
}

class _BookingBody extends StatelessWidget {
  const _BookingBody({
    required this.booking,
    required this.realtimeSnapshot,
    required this.review,
  });
  final BookingEntity booking;
  final BookingRealtimeSnapshot realtimeSnapshot;
  final BookingReviewEntity? review;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsetsDirectional.all(20.r),
      children: <Widget>[
        Text(
          booking.localizedService(isArabic),
          style: TextStyles.bold28(color: colors.onboardingHeadline),
        ),
        SizedBox(height: 8.h),
        Text(
          realtimeSnapshot.statusChanged?.localizedLabel(isArabic) ??
              booking.localizedStatus(isArabic),
          style: TextStyles.bold18(color: colors.errorColor),
        ),
        SizedBox(height: 16.h),
        _line(
          'customer_provider'.tr,
          realtimeSnapshot.providerAssigned?.fullName ?? booking.providerName,
        ),
        _line(
          'customer_provider_phone'.tr,
          realtimeSnapshot.providerAssigned?.phoneNumber ??
              booking.providerPhone,
        ),
        _line('customer_address'.tr, booking.address),
        _line('customer_notes'.tr, booking.notes),
        _line('customer_total'.tr, booking.totalPrice.toStringAsFixed(2)),
        // Only worth a line when it was actually charged: a free cancellation
        // reads as reassurance, not as a zero to explain.
        if ((booking.cancellationFee ?? 0) > 0)
          _line(
            'customer_cancellation_fee'.tr,
            booking.cancellationFee!.toStringAsFixed(2),
          ),
        SizedBox(height: 20.h),
        Text(
          'customer_status_timeline'.tr,
          style: TextStyles.bold22(color: colors.onboardingHeadline),
        ),
        _time('customer_created'.tr, booking.createAt),
        _time('customer_accepted'.tr, booking.acceptedAt),
        _time('customer_en_route'.tr, booking.enRouteAt),
        _time('customer_arrived'.tr, booking.arrivedAt),
        _time('customer_started'.tr, booking.startedAt),
        _time('customer_completed'.tr, booking.completedAt),
        _time('customer_cancelled'.tr, booking.cancelledAt),
        SizedBox(height: 24.h),
        if (booking.status < 6)
          FilledButton(
            onPressed: () =>
                context.pushNamed(Routes.trackLiveRoute, extra: booking.id),
            child: Text('bookings_track_provider'.tr),
          ),
        // Available whenever a provider is assigned, active or finished, so the
        // customer can reach the same booking conversation from here instead of
        // hunting for it in the chats list.
        if (booking.providerId != null)
          OutlinedButton.icon(
            onPressed: () => _openChat(context),
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            label: Text('customer_chat_provider'.tr),
          ),
        if (booking.status < 6)
          TextButton(
            onPressed: () => _cancel(context),
            child: Text('customer_cancel_booking'.tr),
          ),
        if (review != null) ...<Widget>[
          SizedBox(height: 20.h),
          Text(
            'customer_your_review'.tr,
            style: TextStyles.bold22(color: colors.onboardingHeadline),
          ),
          SizedBox(height: 8.h),
          _ReviewCard(review: review!),
        ],
        if (booking.status == 6)
          FilledButton(
            onPressed: () => _review(context),
            child: Text(
              review == null
                  ? 'customer_leave_review'.tr
                  : 'customer_edit_review'.tr,
            ),
          ),
      ],
    );
  }

  Widget _line(String label, String? value) {
    if (value == null || value.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 8.h),
      child: Text('$label: $value'),
    );
  }

  Widget _time(String label, DateTime? value) {
    if (value == null) {
      return const SizedBox.shrink();
    }
    return ListTile(
      contentPadding: EdgeInsetsDirectional.zero,
      leading: const Icon(Icons.check_circle_rounded),
      title: Text(label),
      subtitle: Text(value.toLocal().toString()),
    );
  }

  /// Opens the conversation for this booking. Chat is keyed on the booking id,
  /// so this always lands on the one existing thread - it never spawns a new
  /// conversation. The input is locked once the booking is finished (>= 6),
  /// matching the server's completed/cancelled rule.
  void _openChat(BuildContext context) {
    final providerId = booking.providerId;
    if (providerId == null) {
      return;
    }
    context.pushNamed(
      Routes.chatDetailsRoute,
      extra: ChatThreadEntity(
        bookingId: booking.id,
        peerId: providerId,
        peerName: booking.providerName ?? '',
        unreadCount: 0,
        isOnline: false,
        isLocked: booking.status >= 6,
      ),
    );
  }

  Future<void> _cancel(BuildContext context) async {
    final reason = await showCancelBookingDialog(context);
    if (reason == null || reason.isEmpty || !context.mounted) {
      return;
    }
    await context.read<BookingCubit>().execute(
      BookingCommand.cancel(booking.id, reason),
    );
  }

  Future<void> _review(BuildContext context) async {
    final existing = review;
    final draft = await showDialog<_ReviewDraft>(
      context: context,
      builder: (_) => _ReviewDialog(review: existing),
    );
    if (draft == null || !context.mounted) {
      return;
    }
    final params = ReviewParams(
      bookingId: existing == null ? booking.id : null,
      rating: draft.rating,
      comment: draft.comment.isEmpty ? null : draft.comment,
    );
    await context.read<BookingCubit>().execute(
      existing == null
          ? BookingCommand.review(params)
          : BookingCommand.updateReview(existing.id, params),
    );
  }
}

class _ReviewDraft {
  const _ReviewDraft({required this.rating, required this.comment});
  final int rating;
  final String comment;
}

class _ReviewDialog extends StatefulWidget {
  const _ReviewDialog({required this.review});
  final BookingReviewEntity? review;

  @override
  State<_ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<_ReviewDialog> {
  late final TextEditingController _comment = TextEditingController(
    text: widget.review?.comment,
  );
  late int _rating = widget.review?.rating ?? 5;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.review == null
            ? 'customer_leave_review'.tr
            : 'customer_edit_review'.tr,
      ),
      // Scrollable so the on-screen keyboard cannot overflow the content.
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DropdownButton<int>(
              value: _rating,
              items: List<DropdownMenuItem<int>>.generate(
                5,
                (index) => DropdownMenuItem<int>(
                  value: index + 1,
                  child: Text('${index + 1} ★'),
                ),
              ),
              onChanged: (value) => setState(() => _rating = value ?? 5),
            ),
            TextField(
              controller: _comment,
              decoration: InputDecoration(
                hintText: 'customer_review_comment'.tr,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => context.pop(
            _ReviewDraft(rating: _rating, comment: _comment.text.trim()),
          ),
          child: Text('save'.tr),
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});
  final BookingReviewEntity review;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsetsDirectional.all(14.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                for (int star = 1; star <= 5; star++)
                  Icon(
                    star <= review.rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 20.r,
                    color: colors.review,
                  ),
                const Spacer(),
                Text(review.createAt.toLocal().toString().split('.').first),
              ],
            ),
            if (review.comment != null &&
                review.comment!.isNotEmpty) ...<Widget>[
              SizedBox(height: 8.h),
              Text(review.comment!),
            ],
            _breakdown(
              'customer_review_punctuality'.tr,
              review.punctualityRating,
            ),
            _breakdown(
              'customer_review_work_quality'.tr,
              review.workQualityRating,
            ),
            _breakdown(
              'customer_review_cleanliness'.tr,
              review.cleanlinessRating,
            ),
            if (review.providerReply != null &&
                review.providerReply!.isNotEmpty) ...<Widget>[
              SizedBox(height: 12.h),
              Container(
                width: double.infinity,
                padding: EdgeInsetsDirectional.all(10.r),
                decoration: BoxDecoration(
                  color: colors.lightBackGroundColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'customer_provider_reply'.tr,
                      style: TextStyles.bold16(
                        color: colors.onboardingHeadline,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(review.providerReply!),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _breakdown(String label, int? value) {
    if (value == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 4.h),
      child: Text('$label: $value/5'),
    );
  }
}
