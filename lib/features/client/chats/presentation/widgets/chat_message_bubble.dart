import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/cached_network_image_with_fallback.dart';
import '/features/shared/chat/domain/entities/chat_entities.dart';
import '/injection_container.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({super.key, required this.message, this.onRetry});
  final ChatMessageEntity message;

  /// Called when a failed outgoing bubble is tapped, to resend it.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final content = message.messageType == 'QuickReply'
        ? (message.messageText ?? '').tr
        : message.messageText ?? '';
    final bubble = Container(
      constraints: BoxConstraints(maxWidth: 300.w),
      padding: EdgeInsetsDirectional.all(12.r),
      decoration: BoxDecoration(
        color: message.isMine
            ? colors.errorColor
            : colors.onboardingSurfaceMuted,
        borderRadius: BorderRadius.circular(18.r),
      ),
      // A pending bubble is dimmed until the server confirms it.
      child: Opacity(
        opacity: message.isPending ? 0.6 : 1,
        child: message.messageType == 'Image'
            ? CachedNetworkImageWithFallback(
                imageUrl: message.attachmentUrl,
                width: 220.w,
                height: 180.h,
              )
            : Text(
                content,
                style: TextStyles.medium16(
                  color: message.isMine
                      ? colors.whiteColor
                      : colors.homeHeadline,
                ),
              ),
      ),
    );
    return Align(
      alignment: message.isMine
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: Column(
        crossAxisAlignment: message.isMine
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: <Widget>[
          message.isFailed
              ? GestureDetector(onTap: onRetry, child: bubble)
              : bubble,
          _statusRow(),
        ],
      ),
    );
  }

  Widget _statusRow() {
    if (message.isMine && message.isFailed) {
      return GestureDetector(
        onTap: onRetry,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.error_outline_rounded,
              size: 14.r,
              color: colors.errorColor,
            ),
            SizedBox(width: 3.w),
            Text(
              'chat_send_failed_retry'.tr,
              style: TextStyles.regular12(color: colors.errorColor),
            ),
          ],
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          _time(message.sentAt),
          style: TextStyles.regular12(color: colors.homeCaption),
        ),
        if (message.isMine) ...<Widget>[
          SizedBox(width: 3.w),
          if (message.isPending)
            Icon(
              Icons.access_time_rounded,
              size: 14.r,
              color: colors.homeCaption,
            )
          else
            Icon(
              message.isRead ? Icons.done_all_rounded : Icons.done_rounded,
              size: 14.r,
              color: message.isRead ? colors.main : colors.homeCaption,
            ),
        ],
      ],
    );
  }

  String _time(DateTime dateTime) {
    final local = dateTime.toLocal();
    return '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }
}
