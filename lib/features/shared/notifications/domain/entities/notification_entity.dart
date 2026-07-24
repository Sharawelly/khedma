import 'package:equatable/equatable.dart';

import '/core/base_classes/pagination.dart';

class NotificationEntity extends Equatable {
  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    this.sentAt,
  });

  final String id;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final DateTime? sentAt;

  @override
  List<Object?> get props => <Object?>[id, title, body, type, isRead, sentAt];
}

class NotificationPageEntity extends Equatable {
  const NotificationPageEntity({
    required this.notifications,
    required this.pagination,
  });

  final List<NotificationEntity> notifications;
  final Pagination pagination;

  @override
  List<Object?> get props => <Object?>[notifications, pagination];
}
