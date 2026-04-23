import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/features/notifications/presentation/widgets/notification_item_card.dart';
import '/injection_container.dart';

class NotificationSection extends StatelessWidget {
  const NotificationSection({
    super.key,
    required this.sectionTitleKey,
    required this.items,
  });

  final String sectionTitleKey;
  final List<NotificationCardData> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsetsDirectional.only(start: 24.w, end: 24.w),
          child: Row(
            children: <Widget>[
              Text(
                sectionTitleKey.tr.toUpperCase(),
                style: TextStyles.bold16(
                  color: colors.homeCaption,
                ).copyWith(letterSpacing: 1.2),
              ),
              Gaps.hGap12,
              Expanded(
                child: Container(
                  height: 1.h,
                  color: colors.optionBorder,
                ),
              ),
            ],
          ),
        ),
        Gaps.vGap16,
        Column(
          children: items
              .map(
                (NotificationCardData item) => NotificationItemCard(
                  titleKey: item.titleKey.tr,
                  descriptionKey: item.descriptionKey.tr,
                  timeKey: item.timeKey.tr,
                  leadingIcon: item.iconData,
                  leadingIconColor: item.leadingIconColor,
                  cardBackgroundColor: item.cardBackgroundColor,
                  iconBackgroundColor: item.iconBackgroundColor,
                  showUnreadIndicator: item.showUnreadIndicator,
                  unreadIndicatorColor: item.unreadIndicatorColor,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class NotificationCardData {
  const NotificationCardData({
    required this.titleKey,
    required this.descriptionKey,
    required this.timeKey,
    required this.iconData,
    required this.leadingIconColor,
    required this.cardBackgroundColor,
    required this.iconBackgroundColor,
    this.showUnreadIndicator = false,
    this.unreadIndicatorColor,
  });

  final String titleKey;
  final String descriptionKey;
  final String timeKey;
  final IconData iconData;
  final Color leadingIconColor;
  final Color cardBackgroundColor;
  final Color iconBackgroundColor;
  final bool showUnreadIndicator;
  final Color? unreadIndicatorColor;
}
