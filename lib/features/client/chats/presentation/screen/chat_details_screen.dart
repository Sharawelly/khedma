import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '/config/locale/app_localizations.dart';
import '/core/widgets/gaps.dart';
import '/core/widgets/app_shimmer.dart';
import '/core/widgets/no_data_found.dart';
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
            ..execute(LoadChatHistory(thread)),
      child: BlocListener<ChatDetailsCubit, ChatDetailsState>(
        listenWhen: (_, current) =>
            current is ChatDetailsSuccess && current.transientError != null,
        listener: (context, state) {
          final message = (state as ChatDetailsSuccess).transientError!;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  message.startsWith('chat_') ? message.tr : message,
                ),
              ),
            );
        },
        child: Scaffold(
          backgroundColor: colors.onboardingBackground,
          body: Column(
            children: <Widget>[
              BlocBuilder<ChatDetailsCubit, ChatDetailsState>(
                builder: (_, state) => ChatDetailsHeader(
                  thread: thread,
                  isOnline: state is ChatDetailsSuccess
                      ? state.isPeerOnline
                      : thread.isOnline,
                ),
              ),
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
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SelectableText.rich(
                              TextSpan(
                                text: state.message.startsWith('chat_')
                                    ? state.message.tr
                                    : state.message,
                                style: TextStyle(color: colors.errorColor),
                              ),
                            ),
                            TextButton(
                              onPressed: () => context
                                  .read<ChatDetailsCubit>()
                                  .execute(LoadChatHistory(thread)),
                              child: Text('retry'.tr),
                            ),
                          ],
                        ),
                      );
                    }
                    final success = state as ChatDetailsSuccess;
                    if (success.messages.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: () => context
                            .read<ChatDetailsCubit>()
                            .execute(LoadChatHistory(thread)),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: 400.h,
                            child: const NoDataFound(),
                          ),
                        ),
                      );
                    }
                    return _ConversationList(success: success, thread: thread);
                  },
                ),
              ),
              SafeArea(
                top: false,
                child: BlocBuilder<ChatDetailsCubit, ChatDetailsState>(
                  builder: (context, state) => Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      16.w,
                      4.h,
                      16.w,
                      16.h,
                    ),
                    child: Column(
                      children: <Widget>[
                        IgnorePointer(
                          ignoring:
                              state is ChatDetailsSuccess && state.isLocked,
                          child: ChatQuickRepliesRow(
                            thread: thread,
                            onSelected: (key) => context
                                .read<ChatDetailsCubit>()
                                .execute(SendQuickReply(thread.bookingId, key)),
                          ),
                        ),
                        Gaps.vGap10,
                        ChatMessageInputBar(
                          enabled: state is ChatDetailsSuccess
                              ? !state.isLocked
                              : !thread.isLocked,
                          onSend: (text) => context
                              .read<ChatDetailsCubit>()
                              .execute(SendTextMessage(thread.bookingId, text)),
                          onAttach: () => _pickImage(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
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

/// The scrolling message list. Owns a controller so it can keep the newest
/// message in view: it pins to the bottom on open and when a new latest message
/// arrives, but leaves the position alone while the user reads older messages or
/// loads an earlier page.
class _ConversationList extends StatefulWidget {
  const _ConversationList({required this.success, required this.thread});
  final ChatDetailsSuccess success;
  final ChatThreadEntity thread;

  @override
  State<_ConversationList> createState() => _ConversationListState();
}

class _ConversationListState extends State<_ConversationList> {
  final ScrollController _controller = ScrollController();
  String? _lastMessageId;

  @override
  void initState() {
    super.initState();
    _pinToBottomIfNeeded();
  }

  @override
  void didUpdateWidget(covariant _ConversationList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _pinToBottomIfNeeded();
  }

  void _pinToBottomIfNeeded() {
    final messages = widget.success.messages;
    if (messages.isEmpty) {
      return;
    }
    final newestId = messages.last.id;
    if (newestId == _lastMessageId) {
      return; // Same tail: a read receipt, presence change or older page.
    }
    final isFirstLoad = _lastMessageId == null;
    final newestIsMine = messages.last.isMine;
    _lastMessageId = newestId;
    // Don't yank the user down if they've scrolled up to read history, unless
    // it's their own message or the very first render.
    if (!isFirstLoad && !newestIsMine && !_isNearBottom()) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_controller.hasClients) {
        return;
      }
      _controller.jumpTo(_controller.position.maxScrollExtent);
    });
  }

  bool _isNearBottom() {
    if (!_controller.hasClients) {
      return true;
    }
    final position = _controller.position;
    return position.maxScrollExtent - position.pixels < 240;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final success = widget.success;
    final messages = success.messages;
    return RefreshIndicator(
      onRefresh: () => context.read<ChatDetailsCubit>().execute(
        LoadChatHistory(widget.thread),
      ),
      child: ListView.separated(
        controller: _controller,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsetsDirectional.fromSTEB(22.w, 14.h, 22.w, 18.h),
        itemCount: messages.length + (success.hasNextPage ? 1 : 0),
        separatorBuilder: (_, _) => Gaps.vGap12,
        itemBuilder: (_, index) {
          if (success.hasNextPage && index == 0) {
            return TextButton(
              onPressed: () => context.read<ChatDetailsCubit>().execute(
                const LoadEarlierChatMessages(),
              ),
              child: Text('load_more'.tr),
            );
          }
          final messageIndex = index - (success.hasNextPage ? 1 : 0);
          final message = messages[messageIndex];
          return ChatMessageBubble(
            message: message,
            onRetry: () =>
                context.read<ChatDetailsCubit>().execute(RetryMessage(message)),
          );
        },
      ),
    );
  }
}
