import 'package:equatable/equatable.dart';

import '/core/base_classes/pagination.dart';

class ChatThreadEntity extends Equatable {
  const ChatThreadEntity({
    required this.bookingId,
    required this.peerId,
    required this.peerName,
    required this.unreadCount,
    required this.isOnline,
    required this.isLocked,
    this.peerRoleEn,
    this.peerRoleAr,
    this.peerAvatarUrl,
    this.lastMessage,
    this.lastMessageAt,
    this.scheduleChipEn,
    this.scheduleChipAr,
  });

  final String bookingId;
  final String peerId;
  final String peerName;
  final String? peerRoleEn;
  final String? peerRoleAr;
  final String? peerAvatarUrl;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;
  final bool isOnline;
  final bool isLocked;
  final String? scheduleChipEn;
  final String? scheduleChipAr;

  @override
  List<Object?> get props => <Object?>[
    bookingId,
    peerId,
    peerName,
    peerRoleEn,
    peerRoleAr,
    peerAvatarUrl,
    lastMessage,
    lastMessageAt,
    unreadCount,
    isOnline,
    isLocked,
    scheduleChipEn,
    scheduleChipAr,
  ];
}

class ChatMessageEntity extends Equatable {
  const ChatMessageEntity({
    required this.id,
    required this.bookingId,
    required this.senderId,
    required this.isMine,
    required this.messageType,
    required this.sentAt,
    required this.isRead,
    this.senderName,
    this.messageText,
    this.attachmentUrl,
  });

  final String id;
  final String bookingId;
  final String senderId;
  final String? senderName;
  final bool isMine;
  final String messageType;
  final String? messageText;
  final String? attachmentUrl;
  final DateTime sentAt;
  final bool isRead;

  @override
  List<Object?> get props => <Object?>[
    id,
    bookingId,
    senderId,
    senderName,
    isMine,
    messageType,
    messageText,
    attachmentUrl,
    sentAt,
    isRead,
  ];
}

class ChatHistoryEntity extends Equatable {
  const ChatHistoryEntity({required this.messages, required this.pagination});
  final List<ChatMessageEntity> messages;
  final Pagination pagination;
  @override
  List<Object?> get props => <Object?>[messages, pagination];
}
