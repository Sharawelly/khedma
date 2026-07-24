import '/injection_container.dart';
import 'data/datasources/notification_remote_datasource.dart';
import 'data/repositories/notification_repository_impl.dart';
import 'domain/repositories/notification_repository.dart';
import 'domain/usecases/notification_use_cases.dart';
import 'presentation/cubit/notification_cubit.dart';

void initNotificationFeatureInjection() {
  final locator = ServiceLocator.instance;
  locator
    ..registerLazySingleton<NotificationRemoteDataSource>(
      NotificationRemoteDataSourceImpl.new,
    )
    ..registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(locator()),
    )
    ..registerLazySingleton(() => GetNotifications(locator()))
    ..registerLazySingleton(() => MarkNotificationRead(locator()))
    ..registerLazySingleton(() => MarkAllNotificationsRead(locator()))
    ..registerLazySingleton(() => DeleteNotification(locator()))
    ..registerLazySingleton(
      () => NotificationCubit(
        getNotifications: locator(),
        markNotificationRead: locator(),
        markAllNotificationsRead: locator(),
        deleteNotification: locator(),
        realtimeService: locator(),
      ),
    );
}
