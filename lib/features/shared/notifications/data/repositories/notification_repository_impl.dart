import 'package:dartz/dartz.dart';

import '/core/error/exceptions.dart';
import '/core/error/failures.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/usecases/params/notification_query.dart';
import '../datasources/notification_remote_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  const NotificationRepositoryImpl(this.remote);
  final NotificationRemoteDataSource remote;

  @override
  Future<Either<Failure, NotificationPageEntity>> getNotifications(
    NotificationQuery query,
  ) async {
    try {
      return Right<Failure, NotificationPageEntity>(
        await remote.getNotifications(query),
      );
    } on AppException catch (error) {
      return Left<Failure, NotificationPageEntity>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> markRead(String id) {
    return _command(() => remote.markRead(id));
  }

  @override
  Future<Either<Failure, Unit>> markAllRead() {
    return _command(remote.markAllRead);
  }

  @override
  Future<Either<Failure, Unit>> deleteNotification(String id) {
    return _command(() => remote.deleteNotification(id));
  }

  Future<Either<Failure, Unit>> _command(
    Future<void> Function() request,
  ) async {
    try {
      await request();
      return const Right<Failure, Unit>(unit);
    } on AppException catch (error) {
      return Left<Failure, Unit>(error.toFailure());
    }
  }
}
