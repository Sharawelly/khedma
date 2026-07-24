import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/features/shared/chat/domain/entities/chat_entities.dart';

class ChatQuickRepliesRow extends StatelessWidget {
  const ChatQuickRepliesRow({
    super.key,
    required this.thread,
    required this.onSelected,
  });

  final ChatThreadEntity thread;
  final ValueChanged<String> onSelected;

  static const List<String> _replyKeys = <String>[
    'chat_quick_reply_home',
    'chat_quick_reply_call_first',
    'chat_quick_reply_on_my_way',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _replyKeys
            .map(
              (key) => Padding(
                padding: EdgeInsetsDirectional.only(end: 8.w),
                child: ActionChip(
                  onPressed: thread.isLocked ? null : () => onSelected(key),
                  label: Text(key.tr),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
