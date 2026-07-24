import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/core/utils/values/text_styles.dart';
import '/core/widgets/cached_network_image_with_fallback.dart';
import '/core/widgets/gaps.dart';
import '/features/shared/chat/domain/entities/chat_entities.dart';
import '/injection_container.dart';

class ChatThreadCard extends StatelessWidget {
  const ChatThreadCard({super.key, required this.thread, required this.onTap});

  final ChatThreadEntity thread;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18.r),
      onTap: onTap,
      child: Ink(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 12.w,
          vertical: 12.h,
        ),
        decoration: BoxDecoration(
          color: colors.whiteColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: colors.onboardingBorderNeutral),
        ),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: CachedNetworkImageWithFallback(
                imageUrl: thread.peerAvatarUrl,
                width: 62.r,
                height: 62.r,
              ),
            ),
            Gaps.hGap12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    thread.peerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.bold16(color: colors.onboardingHeadline),
                  ),
                  Gaps.vGap2,
                  Text(
                    thread.lastMessage ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.medium13(color: colors.lightTextColor),
                  ),
                ],
              ),
            ),
            if (thread.unreadCount > 0)
              CircleAvatar(
                radius: 11.r,
                backgroundColor: colors.errorColor,
                child: Text(
                  '${thread.unreadCount}',
                  style: TextStyles.semiBold11(color: colors.whiteColor),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
