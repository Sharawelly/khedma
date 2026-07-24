import '/core/base_classes/pagination_model.dart';
import '../../domain/entities/chat_entities.dart';

class ChatThreadModel extends ChatThreadEntity {
  const ChatThreadModel({
    required super.bookingId,
    required super.peerId,
    required super.peerName,
    required super.unreadCount,
    required super.isOnline,
    required super.isLocked,
    super.peerRoleEn,
    super.peerRoleAr,
    super.peerAvatarUrl,
    super.lastMessage,
    super.lastMessageAt,
    super.scheduleChipEn,
    super.scheduleChipAr,
  });

  factory ChatThreadModel.fromJson(Map<String, dynamic> json) {
    return ChatThreadModel(
      bookingId: json['bookingId'] as String,
      peerId: json['peerId'] as String,
      peerName: json['peerName'] as String,
      peerRoleEn: json['peerRoleEn'] as String?,
      peerRoleAr: json['peerRoleAr'] as String?,
      peerAvatarUrl: json['peerAvatarUrl'] as String?,
      lastMessage: json['lastMessage'] as String?,
      lastMessageAt: _date(json['lastMessageAt']),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      isOnline: json['isOnline'] as bool? ?? false,
      isLocked: json['isLocked'] as bool? ?? false,
      scheduleChipEn: json['scheduleChipEn'] as String?,
      scheduleChipAr: json['scheduleChipAr'] as String?,
    );
  }
}

class ChatMessageModel extends ChatMessageEntity {
  const ChatMessageModel({
    required super.id,
    required super.bookingId,
    required super.senderId,
    required super.isMine,
    required super.messageType,
    required super.sentAt,
    required super.isRead,
    super.senderName,
    super.messageText,
    super.attachmentUrl,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String?,
      isMine: json['isMine'] as bool? ?? false,
      messageType: json['messageType'] as String,
      messageText: json['messageText'] as String?,
      attachmentUrl: json['attachmentUrl'] as String?,
      sentAt: DateTime.parse(json['sentAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );
  }
}

class ChatHistoryModel extends ChatHistoryEntity {
  const ChatHistoryModel({required super.messages, required super.pagination});

  factory ChatHistoryModel.fromJson(Map<String, dynamic> json) {
    return ChatHistoryModel(
      messages: (json['data'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(ChatMessageModel.fromJson)
          .toList(),
      pagination: PaginationModel.fromJson(json),
    );
  }
}

DateTime? _date(Object? rawDate) {
  return rawDate is String ? DateTime.tryParse(rawDate) : null;
}
