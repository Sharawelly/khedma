import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/injection_container.dart';
import '/config/routes/app_routes.dart';
import '/features/shared/notifications/presentation/cubit/notification_cubit.dart';

class AppNotificationBellButton extends StatelessWidget {
  const AppNotificationBellButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      bloc: ServiceLocator.instance<NotificationCubit>(),
      builder: (_, state) => _NotificationBell(
        hasUnread:
            state is NotificationSuccess &&
            state.notifications.any((notification) => !notification.isRead),
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  const _NotificationBell({required this.hasUnread});

  final bool hasUnread;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        IconButton(
          padding: EdgeInsets.all(8.r),
          onPressed: () => context.push(Routes.notificationsRoute),
          icon: Icon(
            Icons.notifications_none_rounded,
            size: 22.r,
            color: colors.onboardingHeadline,
          ),
        ),
        if (hasUnread)
          Positioned(
            right: 8.w,
            top: 8.h,
            child: Container(
              width: 8.r,
              height: 8.r,
              decoration: BoxDecoration(
                color: colors.errorColor,
                shape: BoxShape.circle,
                border: Border.all(color: colors.whiteColor, width: 2.w),
              ),
            ),
          ),
      ],
    );
  }
}
