import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/core/utils/values/text_styles.dart';
import '/core/widgets/app_centered_header_bar.dart';
import '/core/widgets/gaps.dart';
import '/features/notifications/presentation/widgets/notification_section.dart';
import '/injection_container.dart';
import '/core/utils/values/strings.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NotificationCardData> todayNotifications =
        <NotificationCardData>[
          NotificationCardData(
            titleKey: 'notifications_booking_confirmed_title',
            descriptionKey: 'notifications_booking_confirmed_desc',
            timeKey: 'notifications_time_2m_ago',
            iconData: Icons.calendar_month_rounded,
            leadingIconColor: colors.whiteColor,
            cardBackgroundColor: colors.errorColor.withValues(alpha: 0.06),
            iconBackgroundColor: colors.errorColor,
            showUnreadIndicator: true,
          ),
          NotificationCardData(
            titleKey: 'notifications_payment_success_title',
            descriptionKey: 'notifications_payment_success_desc',
            timeKey: 'notifications_time_3h_ago',
            iconData: Icons.attach_money_rounded,
            leadingIconColor: colors.whiteColor,
            cardBackgroundColor: colors.whiteColor,
            iconBackgroundColor: colors.main,
          ),
          NotificationCardData(
            titleKey: 'notifications_new_message_title',
            descriptionKey: 'notifications_new_message_desc',
            timeKey: 'notifications_time_5h_ago',
            iconData: Icons.chat_bubble_rounded,
            leadingIconColor: colors.whiteColor,
            cardBackgroundColor: colors.whiteColor,
            iconBackgroundColor: colors.pathsInfoAccent,
          ),
        ];
    final List<NotificationCardData> yesterdayNotifications =
        <NotificationCardData>[
          NotificationCardData(
            titleKey: 'notifications_rate_experience_title',
            descriptionKey: 'notifications_rate_experience_desc',
            timeKey: 'notifications_yesterday',
            iconData: Icons.star_rate_rounded,
            leadingIconColor: colors.whiteColor,
            cardBackgroundColor: colors.whiteColor,
            iconBackgroundColor: colors.errorColor,
          ),
        ];

    return Scaffold(
      backgroundColor: colors.backGround,
      body: Column(
        children: <Widget>[
          AppCenteredHeaderBar(
            title: Strings.notifications,
            onBack: context.pop,
            showBottomBorder: true,
            trailing: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(8.r),
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 6.w,
                  vertical: 4.h,
                ),
                child: Text(
                  Strings.markAllAsRead,
                  style: TextStyles.bold12(color: colors.errorColor),
                ),
              ),
            ),
            titleStyle: TextStyles.bold20(color: colors.onboardingHeadline),
            contentPadding: EdgeInsetsDirectional.only(
              start: 8.w,
              end: 20.w,
              top: MediaQuery.paddingOf(context).top + 8.h,
              bottom: 14.h,
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsetsDirectional.only(top: 18.h, bottom: 24.h),
              children: <Widget>[
                NotificationSection(
                  sectionTitleKey: 'notifications_today',
                  items: todayNotifications,
                ),
                Gaps.vGap30,
                NotificationSection(
                  sectionTitleKey: 'notifications_yesterday',
                  items: yesterdayNotifications,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
