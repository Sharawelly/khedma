import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';
import 'params/notification_query.dart';

class GetNotifications {
  const GetNotifications(this.repository);
  final NotificationRepository repository;
  Future<Either<Failure, NotificationPageEntity>> call(
    NotificationQuery query,
  ) => repository.getNotifications(query);
}

class MarkNotificationRead {
  const MarkNotificationRead(this.repository);
  final NotificationRepository repository;
  Future<Either<Failure, Unit>> call(String id) => repository.markRead(id);
}

class MarkAllNotificationsRead {
  const MarkAllNotificationsRead(this.repository);
  final NotificationRepository repository;
  Future<Either<Failure, Unit>> call() => repository.markAllRead();
}

class DeleteNotification {
  const DeleteNotification(this.repository);
  final NotificationRepository repository;
  Future<Either<Failure, Unit>> call(String id) =>
      repository.deleteNotification(id);
}
