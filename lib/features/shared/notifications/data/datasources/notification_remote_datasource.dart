import '/core/api/dio_consumer.dart';
import '/core/error/exceptions.dart';
import '/injection_container.dart';
import '../../domain/usecases/params/notification_query.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<NotificationPageModel> getNotifications(NotificationQuery query);
  Future<void> markRead(String id);
  Future<void> markAllRead();
  Future<void> deleteNotification(String id);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  @override
  Future<NotificationPageModel> getNotifications(
    NotificationQuery query,
  ) async {
    final response = await dioConsumer.get(
      ApiConstants.notifications,
      queryParameters: query.toJson(),
    );
    final responseMap = _responseMap(response);
    return NotificationPageModel.fromJson(responseMap);
  }

  @override
  Future<void> markRead(String id) async {
    _responseMap(await dioConsumer.put(ApiConstants.readNotification(id)));
  }

  @override
  Future<void> markAllRead() async {
    _responseMap(await dioConsumer.put(ApiConstants.readAllNotifications));
  }

  @override
  Future<void> deleteNotification(String id) async {
    _responseMap(await dioConsumer.delete(ApiConstants.notification(id)));
  }

  Map<String, dynamic> _responseMap(Object? response) {
    if (response is! Map<String, dynamic> || response['success'] != true) {
      throw ServerException(
        message: response is Map<String, dynamic>
            ? response['message'] as String?
            : null,
      );
    }
    return response;
  }
}
