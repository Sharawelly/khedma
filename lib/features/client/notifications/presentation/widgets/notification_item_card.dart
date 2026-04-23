import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class NotificationItemCard extends StatelessWidget {
  const NotificationItemCard({
    super.key,
    required this.titleKey,
    required this.descriptionKey,
    required this.timeKey,
    required this.leadingIcon,
    required this.leadingIconColor,
    required this.cardBackgroundColor,
    required this.iconBackgroundColor,
    this.showUnreadIndicator = false,
    this.unreadIndicatorColor,
  });

  final String titleKey;
  final String descriptionKey;
  final String timeKey;
  final IconData leadingIcon;
  final Color leadingIconColor;
  final Color cardBackgroundColor;
  final Color iconBackgroundColor;
  final bool showUnreadIndicator;
  final Color? unreadIndicatorColor;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: <Widget>[
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: showUnreadIndicator ? 4.w : 0,
            decoration: BoxDecoration(
              color: unreadIndicatorColor ?? colors.errorColor,
              borderRadius: BorderRadiusDirectional.only(
                topEnd: Radius.circular(4.r),
                bottomEnd: Radius.circular(4.r),
              ),
            ),
          ),
          Expanded(
            child: Container(
              constraints: BoxConstraints(minHeight: 94.h),
              padding: EdgeInsetsDirectional.only(
                start: 16.w,
                end: 16.w,
                top: 16.h,
                bottom: 14.h,
              ),
              color: cardBackgroundColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 46.r,
                    height: 46.r,
                    decoration: BoxDecoration(
                      color: iconBackgroundColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      leadingIcon,
                      size: 23.r,
                      color: leadingIconColor,
                    ),
                  ),
                  Gaps.hGap12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                titleKey,
                                style: TextStyles.bold14(
                                  color: colors.onboardingHeadline,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Gaps.hGap8,
                            Text(
                              timeKey,
                              style: TextStyles.regular12(
                                color: colors.homeCaption,
                              ),
                            ),
                          ],
                        ),
                        Gaps.vGap2,
                        Text(
                          descriptionKey,
                          style: TextStyles.regular14(
                            color: colors.lightTextColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
