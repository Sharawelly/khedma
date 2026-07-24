import '/core/base_classes/pagination_model.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.type,
    required super.isRead,
    super.sentAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: json['type'] as String,
      isRead: json['isRead'] as bool? ?? false,
      sentAt: json['sentAt'] is String
          ? DateTime.tryParse(json['sentAt'] as String)
          : null,
    );
  }
}

class NotificationPageModel extends NotificationPageEntity {
  const NotificationPageModel({
    required super.notifications,
    required super.pagination,
  });

  factory NotificationPageModel.fromJson(Map<String, dynamic> json) {
    final payload = json['data'] as List<dynamic>;
    return NotificationPageModel(
      notifications: payload
          .cast<Map<String, dynamic>>()
          .map(NotificationModel.fromJson)
          .toList(),
      pagination: PaginationModel.fromJson(json),
    );
  }
}
