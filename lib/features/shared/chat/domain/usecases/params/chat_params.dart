class ChatHistoryParams {
  const ChatHistoryParams({
    required this.bookingId,
    this.page = 1,
    this.pageSize = 30,
  });
  final String bookingId;
  final int page;
  final int pageSize;
}

class SendMessageParams {
  const SendMessageParams({
    required this.bookingId,
    required this.messageType,
    this.messageText,
    this.attachmentUrl,
  });
  final String bookingId;
  final String messageType;
  final String? messageText;
  final String? attachmentUrl;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'messageType': messageType,
    if (messageText != null) 'messageText': messageText,
    if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
  };
}
