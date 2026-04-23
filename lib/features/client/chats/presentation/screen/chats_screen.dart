import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/routes/app_routes.dart';
import '/core/widgets/gaps.dart';
import '/features/client/chats/presentation/widgets/chat_thread_card.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.separated(
        padding: EdgeInsetsDirectional.only(
          start: 16.w,
          end: 16.w,
          top: 16.h,
          bottom: 24.h,
        ),
        itemCount: _threads.length,
        separatorBuilder: (_, _) => Gaps.vGap12,
        itemBuilder: (BuildContext context, int index) {
          final ChatThreadData thread = _threads[index];
          return ChatThreadCard(
            thread: thread,
            onTap: () => context.push(Routes.chatDetailsRoute, extra: thread),
          );
        },
      ),
    );
  }
}

const List<ChatThreadData> _threads = <ChatThreadData>[
  ChatThreadData(
    nameKey: 'chat_thread_ahmed_plumber',
    lastMessageKey: 'chat_thread_ahmed_last_message',
    timeKey: 'chat_thread_time_2m',
    roleKey: 'chat_thread_role_plumbing',
    imageUrl:
        'https://images.unsplash.com/photo-1626806787461-102c1bfaaea1?auto=format&fit=crop&w=300&q=80',
    categoryKey: 'plumbing',
    unreadCount: 2,
  ),
  ChatThreadData(
    nameKey: 'chat_thread_sara_cleaning',
    lastMessageKey: 'chat_thread_sara_last_message',
    timeKey: 'chat_thread_time_12m',
    roleKey: 'chat_thread_role_cleaning',
    imageUrl:
        'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=300&q=80',
    categoryKey: 'cleaning',
  ),
  ChatThreadData(
    nameKey: 'chat_thread_mahmoud_electrician',
    lastMessageKey: 'chat_thread_mahmoud_last_message',
    timeKey: 'chat_thread_time_1h',
    roleKey: 'chat_thread_role_electrical',
    imageUrl:
        'https://images.unsplash.com/photo-1581092921461-eab10380d5df?auto=format&fit=crop&w=300&q=80',
    categoryKey: 'electrical',
    unreadCount: 1,
  ),
  ChatThreadData(
    nameKey: 'chat_thread_hvac_support',
    lastMessageKey: 'chat_thread_hvac_last_message',
    timeKey: 'chat_thread_time_3h',
    roleKey: 'chat_thread_role_hvac',
    imageUrl:
        'https://images.unsplash.com/photo-1631545805717-43b0f6e3e0ff?auto=format&fit=crop&w=300&q=80',
    categoryKey: 'hvac',
  ),
];
