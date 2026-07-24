import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/cached_network_image_with_fallback.dart';
import '/core/widgets/gaps.dart';
import '/features/shared/chat/domain/entities/chat_entities.dart';
import '/injection_container.dart';

class ChatDetailsHeader extends StatelessWidget {
  const ChatDetailsHeader({super.key, required this.thread});
  final ChatThreadEntity thread;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: context.pop,
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          ClipOval(
            child: CachedNetworkImageWithFallback(
              imageUrl: thread.peerAvatarUrl,
              width: 42.r,
              height: 42.r,
            ),
          ),
          Gaps.hGap10,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  thread.peerName,
                  style: TextStyles.bold18(color: colors.homeHeadline),
                ),
                Text(
                  thread.isOnline
                      ? 'chat_status_online'.tr
                      : 'chat_status_offline'.tr,
                  style: TextStyles.medium13(color: colors.lightTextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
