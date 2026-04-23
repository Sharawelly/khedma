import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/injection_container.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    super.key,
    required this.messageKey,
    required this.timeKey,
    required this.isOutgoing,
  });

  final String messageKey;
  final String timeKey;
  final bool isOutgoing;

  @override
  Widget build(BuildContext context) {
    final BorderRadiusDirectional radius = isOutgoing
        ? BorderRadiusDirectional.only(
            topStart: Radius.circular(22.r),
            topEnd: Radius.circular(22.r),
            bottomStart: Radius.circular(22.r),
            bottomEnd: Radius.circular(7.r),
          )
        : BorderRadiusDirectional.only(
            topStart: Radius.circular(22.r),
            topEnd: Radius.circular(22.r),
            bottomStart: Radius.circular(7.r),
            bottomEnd: Radius.circular(22.r),
          );

    return Align(
      alignment: isOutgoing
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: Column(
        crossAxisAlignment: isOutgoing
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(maxWidth: 300.w),
            padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: isOutgoing ? colors.errorColor : colors.onboardingSurfaceMuted,
              borderRadius: radius,
            ),
            child: Text(
              messageKey.tr,
              style: TextStyles.medium16(
                color: isOutgoing ? colors.whiteColor : colors.homeHeadline,
              ).copyWith(height: 1.4),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(top: 6.h, start: 4.w, end: 4.w),
            child: Text(
              timeKey.tr,
              style: TextStyles.regular12(color: colors.homeCaption),
            ),
          ),
        ],
      ),
    );
  }
}
