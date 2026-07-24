import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '../entities/notification_entity.dart';
import '../usecases/params/notification_query.dart';

abstract class NotificationRepository {
  Future<Either<Failure, NotificationPageEntity>> getNotifications(
    NotificationQuery query,
  );
  Future<Either<Failure, Unit>> markRead(String id);
  Future<Either<Failure, Unit>> markAllRead();
  Future<Either<Failure, Unit>> deleteNotification(String id);
}
