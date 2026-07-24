import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/realtime/realtime_events.dart';
import '/core/realtime/realtime_service.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/notification_use_cases.dart';
import '../../domain/usecases/params/notification_query.dart';

part 'notification_state.dart';

enum NotificationAction { refresh, loadMore, markRead, markAllRead, delete }

class NotificationCommand {
  const NotificationCommand(this.action, {this.id});
  final NotificationAction action;
  final String? id;
}

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit({
    required this.getNotifications,
    required this.markNotificationRead,
    required this.markAllNotificationsRead,
    required this.deleteNotification,
    required this.realtimeService,
  }) : super(const NotificationInitial()) {
    _connectionSubscription = realtimeService.connected
        .where((event) => event.hub == RealtimeHub.notifications)
        .listen((_) => unawaited(_load(refresh: true)));
    unawaited(_load(refresh: true));
  }

  final GetNotifications getNotifications;
  final MarkNotificationRead markNotificationRead;
  final MarkAllNotificationsRead markAllNotificationsRead;
  final DeleteNotification deleteNotification;
  final RealtimeService realtimeService;
  late final StreamSubscription<RealtimeHubConnected> _connectionSubscription;
  final List<NotificationEntity> _notifications = <NotificationEntity>[];
  int _page = 1;
  bool _hasNextPage = true;
  bool _isLoading = false;

  Future<void> execute(NotificationCommand command) async {
    if (command.action == NotificationAction.refresh) {
      await _load(refresh: true);
    } else if (command.action == NotificationAction.loadMore) {
      await _load(refresh: false);
    } else if (command.action == NotificationAction.markAllRead) {
      await _markAllRead();
    } else if (command.action == NotificationAction.markRead &&
        command.id != null) {
      await _markRead(command.id!);
    } else if (command.action == NotificationAction.delete &&
        command.id != null) {
      await _delete(command.id!);
    }
  }

  Future<void> _load({required bool refresh}) async {
    if (_isLoading || (!refresh && !_hasNextPage)) {
      return;
    }
    _isLoading = true;
    if (refresh) {
      emit(const NotificationLoading());
      _page = 1;
    }
    final requestedPage = refresh ? 1 : _page + 1;
    final response = await getNotifications(
      NotificationQuery(page: requestedPage),
    );
    response.fold(
      (failure) {
        _isLoading = false;
        emit(NotificationFailure(failure.message ?? ''));
      },
      (page) {
        if (refresh) {
          _notifications.clear();
        }
        _notifications.addAll(page.notifications);
        _page = page.pagination.page ?? requestedPage;
        _hasNextPage = page.pagination.hasNextPage ?? false;
        _isLoading = false;
        emit(
          NotificationSuccess(List.unmodifiable(_notifications), _hasNextPage),
        );
      },
    );
  }

  Future<void> _markAllRead() async {
    final response = await markAllNotificationsRead();
    response.fold(
      (failure) => emit(NotificationFailure(failure.message ?? '')),
      (_) => _load(refresh: true),
    );
  }

  Future<void> _markRead(String id) async {
    final response = await markNotificationRead(id);
    response.fold(
      (failure) => emit(NotificationFailure(failure.message ?? '')),
      (_) => _load(refresh: true),
    );
  }

  Future<void> _delete(String id) async {
    final response = await deleteNotification(id);
    response.fold(
      (failure) => emit(NotificationFailure(failure.message ?? '')),
      (_) => _load(refresh: true),
    );
  }

  @override
  Future<void> close() async {
    await _connectionSubscription.cancel();
    return super.close();
  }
}
