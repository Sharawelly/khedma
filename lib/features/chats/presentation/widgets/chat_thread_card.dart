import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/cached_network_image_with_fallback.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class ChatThreadCard extends StatelessWidget {
  const ChatThreadCard({
    super.key,
    required this.thread,
    required this.onTap,
  });

  final ChatThreadData thread;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18.r),
      onTap: onTap,
      child: Ink(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: colors.whiteColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: colors.onboardingBorderNeutral),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: colors.shadowCardLight,
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: CachedNetworkImageWithFallback(
                imageUrl: thread.imageUrl,
                width: 62.r,
                height: 62.r,
                fit: BoxFit.cover,
              ),
            ),
            Gaps.hGap12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    thread.nameKey.tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.bold16(color: colors.onboardingHeadline),
                  ),
                  Gaps.vGap2,
                  Text(
                    thread.lastMessageKey.tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.medium13(color: colors.lightTextColor),
                  ),
                ],
              ),
            ),
            Gaps.hGap8,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  thread.timeKey.tr,
                  style: TextStyles.medium11(color: colors.homeCaption),
                ),
                Gaps.vGap8,
                if (thread.unreadCount > 0)
                  Container(
                    width: 22.r,
                    height: 22.r,
                    alignment: AlignmentDirectional.center,
                    decoration: BoxDecoration(
                      color: colors.errorColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${thread.unreadCount}',
                      style: TextStyles.semiBold11(color: colors.whiteColor),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChatThreadData {
  const ChatThreadData({
    required this.nameKey,
    required this.lastMessageKey,
    required this.timeKey,
    required this.roleKey,
    required this.imageUrl,
    required this.categoryKey,
    this.unreadCount = 0,
  });

  final String nameKey;
  final String lastMessageKey;
  final String timeKey;
  final String roleKey;
  final String imageUrl;
  final String categoryKey;
  final int unreadCount;
}
