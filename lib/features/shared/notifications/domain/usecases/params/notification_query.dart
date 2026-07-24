class NotificationQuery {
  const NotificationQuery({
    this.type,
    this.isRead,
    this.page = 1,
    this.pageSize = 20,
  });

  final String? type;
  final bool? isRead;
  final int page;
  final int pageSize;

  Map<String, dynamic> toJson() => <String, dynamic>{
    if (type != null) 'type': type,
    if (isRead != null) 'isRead': isRead,
    'page': page,
    'pageSize': pageSize,
  };
}
