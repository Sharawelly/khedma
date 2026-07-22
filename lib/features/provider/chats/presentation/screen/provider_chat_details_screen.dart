import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/core/widgets/gaps.dart';
import '/features/client/chats/presentation/widgets/chat_details_header.dart';
import '/features/client/chats/presentation/widgets/chat_message_bubble.dart';
import '/features/client/chats/presentation/widgets/chat_message_input_bar.dart';
import '/features/client/chats/presentation/widgets/chat_quick_replies_row.dart';
import '/features/client/chats/presentation/widgets/chat_thread_card.dart';
import '/injection_container.dart';

class ProviderChatDetailsScreen extends StatelessWidget {
  const ProviderChatDetailsScreen({super.key, required this.thread});

  final ChatThreadData thread;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.onboardingBackground,
      body: Column(
        children: <Widget>[
          ChatDetailsHeader(thread: thread),
          Expanded(
            child: ListView(
              padding: EdgeInsetsDirectional.fromSTEB(22.w, 14.h, 22.w, 18.h),
              children: <Widget>[
                const ChatMessageBubble(
                  messageKey: 'chat_message_1',
                  timeKey: 'chat_time_0915',
                  isOutgoing: false,
                ),
                Gaps.vGap12,
                const ChatMessageBubble(
                  messageKey: 'chat_message_2',
                  timeKey: 'chat_time_0918',
                  isOutgoing: true,
                ),
                Gaps.vGap12,
                const ChatMessageBubble(
                  messageKey: 'chat_message_3',
                  timeKey: 'chat_time_0920',
                  isOutgoing: false,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 4.h, 16.w, 16.h),
            child: Column(
              children: <Widget>[
                const ChatQuickRepliesRow(
                  replyKeys: <String>[
                    'chat_quick_reply_home',
                    'chat_quick_reply_call_first',
                    'chat_quick_reply_on_my_way',
                  ],
                ),
                Gaps.vGap10,
                const ChatMessageInputBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
