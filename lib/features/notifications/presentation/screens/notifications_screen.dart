import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/app_centered_header_bar.dart';
import '/features/notifications/presentation/widgets/notification_item_card.dart';
import '/injection_container.dart';
import '/core/utils/values/strings.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.blocksStatSurface,
      body: Column(
        children: <Widget>[
          AppCenteredHeaderBar(
            title: Strings.notifications,
            onBack: context.pop,
            showBottomBorder: true,
            titleStyle: TextStyles.bold18(color: colors.onboardingHeadline),
          ),
          Expanded(
            child: SingleChildScrollView(
              // Horizontal padding is ONLY on section headers, not here.
              // Cards are full-width (edge-to-edge) per Figma.
              padding: EdgeInsets.only(top: 12.h, bottom: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildSection(
                    titleKey: 'notifications_today',
                    items: <Widget>[
                      NotificationItemCard(
                        title: 'Daily Block Reminder',
                        description: "You haven't finished today's Block",
                        timeLabel: '2h ago',
                        leadingIcon: Icons.schedule_rounded,
                        leadingIconColor: colors.whiteColor,
                        cardBackgroundColor: colors.selectedOptionBg,
                        iconBackgroundColor: colors.main,
                      ),
                      NotificationItemCard(
                        title: 'Weekly Kit Available',
                        description:
                            'Your new weekly Kit is ready: Effective Customer Communication',
                        timeLabel: '3h ago',
                        leadingIcon: Icons.inventory_2_rounded,
                        leadingIconColor: colors.whiteColor,
                        cardBackgroundColor: colors.selectedOptionBg,
                        iconBackgroundColor: colors.main,
                      ),
                      NotificationItemCard(
                        title: 'Certificate Earned',
                        description:
                            'Congratulations! You earned a certificate in Sales Fundamentals',
                        timeLabel: '3h ago',
                        leadingIcon: Icons.workspace_premium_rounded,
                        leadingIconColor: colors.review,
                        cardBackgroundColor: colors.whiteColor,
                        iconBackgroundColor: colors.blocksStatBorder,
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  _buildSection(
                    titleKey: 'notifications_yesterday',
                    items: <Widget>[
                      NotificationItemCard(
                        title: 'Assessment Ready',
                        description:
                            "You've completed all modules. You can now start the assessment",
                        timeLabel: 'notifications_yesterday'.tr,
                        leadingIcon: Icons.fact_check_rounded,
                        leadingIconColor: colors.main,
                        cardBackgroundColor: colors.whiteColor,
                        iconBackgroundColor: colors.blocksStatBorder,
                      ),
                      NotificationItemCard(
                        title: 'Path Milestone Reached',
                        description:
                            "You've reached 25% of your Skill Development path",
                        timeLabel: 'notifications_yesterday'.tr,
                        leadingIcon: Icons.track_changes_rounded,
                        leadingIconColor: colors.homeProgressLabel,
                        cardBackgroundColor: colors.whiteColor,
                        iconBackgroundColor: colors.blocksStatBorder,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a date-group section: header row (title + mark-all) then
  /// full-width adjacent cards with no gap between them.
  Widget _buildSection({
    required String titleKey,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // Header row — only this gets horizontal padding
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  titleKey.tr,
                  style: TextStyles.bold18(color: colors.onboardingHeadline),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  Strings.markAllAsRead,
                  style: TextStyles.bold14(color: colors.main),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        // Cards span full width, stacked directly with no gap (matching Figma)
        ...items,
      ],
    );
  }
}
