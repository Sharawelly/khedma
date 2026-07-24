import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '/core/widgets/gaps.dart';
import '/core/widgets/app_shimmer.dart';
import '/features/shared/chat/domain/entities/chat_entities.dart';
import '/features/shared/chat/presentation/cubit/chat_details_cubit.dart';
import '/injection_container.dart';
import '../widgets/chat_details_header.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/chat_message_input_bar.dart';
import '../widgets/chat_quick_replies_row.dart';

class ChatDetailsScreen extends StatelessWidget {
  const ChatDetailsScreen({super.key, required this.thread});
  final ChatThreadEntity thread;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ServiceLocator.instance<ChatDetailsCubit>()
            ..execute(LoadChatHistory(thread.bookingId)),
      child: Scaffold(
        backgroundColor: colors.onboardingBackground,
        body: Column(
          children: <Widget>[
            ChatDetailsHeader(thread: thread),
            if (_scheduleChip.isNotEmpty)
              Padding(
                padding: EdgeInsetsDirectional.all(8.r),
                child: Chip(label: Text(_scheduleChip)),
              ),
            Expanded(
              child: BlocBuilder<ChatDetailsCubit, ChatDetailsState>(
                builder: (context, state) {
                  if (state is ChatDetailsLoading ||
                      state is ChatDetailsInitial) {
                    return AppShimmer(
                      child: Container(color: colors.lightBackGroundColor),
                    );
                  }
                  if (state is ChatDetailsFailure) {
                    return Center(
                      child: SelectableText.rich(
                        TextSpan(
                          text: state.message,
                          style: TextStyle(color: colors.errorColor),
                        ),
                      ),
                    );
                  }
                  final messages = (state as ChatDetailsSuccess).messages;
                  return ListView.separated(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      22.w,
                      14.h,
                      22.w,
                      18.h,
                    ),
                    itemCount: messages.length,
                    separatorBuilder: (_, _) => Gaps.vGap12,
                    itemBuilder: (_, index) =>
                        ChatMessageBubble(message: messages[index]),
                  );
                },
              ),
            ),
            Builder(
              builder: (context) => Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.w, 4.h, 16.w, 16.h),
                child: Column(
                  children: <Widget>[
                    ChatQuickRepliesRow(
                      thread: thread,
                      onSelected: (key) => context
                          .read<ChatDetailsCubit>()
                          .execute(SendQuickReply(thread.bookingId, key)),
                    ),
                    Gaps.vGap10,
                    ChatMessageInputBar(
                      enabled: !thread.isLocked,
                      onSend: (text) => context
                          .read<ChatDetailsCubit>()
                          .execute(SendTextMessage(thread.bookingId, text)),
                      onAttach: () => _pickImage(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _scheduleChip => appLocalizations.isArLocale
      ? thread.scheduleChipAr ?? thread.scheduleChipEn ?? ''
      : thread.scheduleChipEn ?? thread.scheduleChipAr ?? '';

  Future<void> _pickImage(BuildContext context) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null && context.mounted) {
      await context.read<ChatDetailsCubit>().execute(
        SendImageMessage(thread.bookingId, File(image.path)),
      );
    }
  }
}
