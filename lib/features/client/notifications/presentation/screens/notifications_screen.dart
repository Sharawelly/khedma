import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/app_centered_header_bar.dart';
import '/core/widgets/app_shimmer.dart';
import '/core/widgets/no_data_found.dart';
import '/features/shared/notifications/domain/entities/notification_entity.dart';
import '/features/shared/notifications/presentation/cubit/notification_cubit.dart';
import '/injection_container.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationCubit _cubit;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _cubit = ServiceLocator.instance<NotificationCubit>();
    _cubit.execute(const NotificationCommand(NotificationAction.refresh));
    _scrollController.addListener(_loadNextPage);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_loadNextPage)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: colors.backGround,
        body: Column(
          children: <Widget>[
            AppCenteredHeaderBar(
              title: 'notifications'.tr,
              onBack: context.pop,
              trailing: TextButton(
                onPressed: () => _cubit.execute(
                  const NotificationCommand(NotificationAction.markAllRead),
                ),
                child: Text('notifications_mark_all_read'.tr),
              ),
            ),
            Expanded(
              child: BlocBuilder<NotificationCubit, NotificationState>(
                builder: (context, state) {
                  if (state is NotificationLoading ||
                      state is NotificationInitial) {
                    return AppShimmer(
                      child: Container(color: colors.lightBackGroundColor),
                    );
                  }
                  if (state is NotificationFailure) {
                    return Center(
                      child: SelectableText.rich(
                        TextSpan(
                          text: state.message,
                          style: TextStyle(color: colors.errorColor),
                        ),
                      ),
                    );
                  }
                  final notifications =
                      (state as NotificationSuccess).notifications;
                  if (notifications.isEmpty) {
                    return const NoDataFound();
                  }
                  return RefreshIndicator(
                    onRefresh: () => _cubit.execute(
                      const NotificationCommand(NotificationAction.refresh),
                    ),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      itemCount: notifications.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (_, index) =>
                          _NotificationTile(notification: notifications[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loadNextPage() {
    if (_scrollController.position.extentAfter < 300) {
      _cubit.execute(const NotificationCommand(NotificationAction.loadMore));
    }
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification});
  final NotificationEntity notification;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey<String>(notification.id),
      direction: DismissDirection.endToStart,
      background: ColoredBox(
        color: colors.errorColor,
        child: const Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Padding(
            padding: EdgeInsetsDirectional.all(20),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
      ),
      onDismissed: (_) => context.read<NotificationCubit>().execute(
        NotificationCommand(NotificationAction.delete, id: notification.id),
      ),
      child: ListTile(
        tileColor: notification.isRead
            ? colors.whiteColor
            : colors.errorColor.withValues(alpha: 0.06),
        title: Text(
          notification.title,
          style: TextStyles.bold14(color: colors.onboardingHeadline),
        ),
        subtitle: Text(notification.body),
        trailing: Text(
          _time(notification.sentAt),
          style: TextStyles.regular12(color: colors.homeCaption),
        ),
        onTap: notification.isRead
            ? null
            : () => context.read<NotificationCubit>().execute(
                NotificationCommand(
                  NotificationAction.markRead,
                  id: notification.id,
                ),
              ),
      ),
    );
  }

  String _time(DateTime? sentAt) {
    if (sentAt == null) {
      return '';
    }
    final local = sentAt.toLocal();
    return '${local.day}/${local.month} '
        '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }
}
