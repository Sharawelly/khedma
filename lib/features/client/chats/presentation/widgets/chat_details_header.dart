import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/cached_network_image_with_fallback.dart';
import '/core/widgets/gaps.dart';
import '/features/client/chats/presentation/widgets/chat_thread_card.dart';
import '/injection_container.dart';

class ChatDetailsHeader extends StatelessWidget {
  const ChatDetailsHeader({super.key, required this.thread});

  final ChatThreadData thread;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(8.w, 4.h, 12.w, 8.h),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        border: Border(bottom: BorderSide(color: colors.onboardingBorderNeutral)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: context.pop,
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 22.r,
                color: colors.homeHeadline,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: CachedNetworkImageWithFallback(
                imageUrl: thread.imageUrl,
                width: 42.r,
                height: 42.r,
                fit: BoxFit.cover,
              ),
            ),
            Transform.translate(
              offset: Offset(-8.w, 14.h),
              child: Container(
                width: 11.r,
                height: 11.r,
                decoration: BoxDecoration(
                  color: colors.main,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.whiteColor, width: 2.w),
                ),
              ),
            ),
            Gaps.hGap4,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    thread.nameKey.tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.bold18(color: colors.homeHeadline),
                  ),
                  Text(
                    'chat_status_online'.tr,
                    style: TextStyles.medium13(color: colors.lightTextColor),
                  ),
                ],
              ),
            ),
            Icon(Icons.call_rounded, color: colors.lightTextColor, size: 24.r),
          ],
        ),
      ),
    );
  }
}
