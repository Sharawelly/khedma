import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '/core/config/app_config.dart';
import '/core/services/local_storage/app_secure_storage.dart';
import '/core/utils/server_datetime.dart';
import '/features/provider/domain/entities/provider_entities.dart';
import '/features/shared/chat/domain/entities/chat_entities.dart';
import 'realtime_events.dart';

class RealtimeService with WidgetsBindingObserver {
  RealtimeService(this._secureStorage) {
    WidgetsBinding.instance.addObserver(this);
  }

  final AppSecureStorage _secureStorage;

  final StreamController<RealtimeHubConnected> _connectedController =
      StreamController<RealtimeHubConnected>.broadcast();
  final StreamController<PendingJobEntity> _jobDispatchedController =
      StreamController<PendingJobEntity>.broadcast();
  final StreamController<JobOfferDismissed> _jobDismissedController =
      StreamController<JobOfferDismissed>.broadcast();
  final StreamController<BookingStatusChangedEvent> _bookingStatusController =
      StreamController<BookingStatusChangedEvent>.broadcast();
  final StreamController<ProviderAssignedEvent> _providerAssignedController =
      StreamController<ProviderAssignedEvent>.broadcast();
  final StreamController<ProviderLocationEvent> _providerLocationController =
      StreamController<ProviderLocationEvent>.broadcast();
  final StreamController<NoProviderFoundEvent> _noProviderController =
      StreamController<NoProviderFoundEvent>.broadcast();
  final StreamController<PaymentStatusChangedEvent> _paymentStatusController =
      StreamController<PaymentStatusChangedEvent>.broadcast();
  final StreamController<ChatMessageEntity> _chatMessageController =
      StreamController<ChatMessageEntity>.broadcast();
  final StreamController<MessageReadEvent> _messageReadController =
      StreamController<MessageReadEvent>.broadcast();
  final StreamController<ChatLockedEvent> _chatLockedController =
      StreamController<ChatLockedEvent>.broadcast();
  final StreamController<PresenceChangedEvent> _presenceController =
      StreamController<PresenceChangedEvent>.broadcast();

  final Set<String> _bookingGroups = <String>{};
  final Set<String> _chatGroups = <String>{};

  HubConnection? _bookingConnection;
  HubConnection? _chatConnection;
  HubConnection? _notificationConnection;
  Future<void> _operation = Future<void>.value();
  String? _connectionToken;
  bool _authenticated = false;
  bool _backgrounded = false;

  Stream<RealtimeHubConnected> get connected => _connectedController.stream;
  Stream<PendingJobEntity> get jobDispatched => _jobDispatchedController.stream;
  Stream<JobOfferDismissed> get jobDismissed => _jobDismissedController.stream;
  Stream<BookingStatusChangedEvent> get bookingStatusChanged =>
      _bookingStatusController.stream;
  Stream<ProviderAssignedEvent> get providerAssigned =>
      _providerAssignedController.stream;
  Stream<ProviderLocationEvent> get providerLocation =>
      _providerLocationController.stream;
  Stream<NoProviderFoundEvent> get noProviderFound =>
      _noProviderController.stream;
  Stream<PaymentStatusChangedEvent> get paymentStatusChanged =>
      _paymentStatusController.stream;
  Stream<ChatMessageEntity> get chatMessage => _chatMessageController.stream;
  Stream<MessageReadEvent> get messageRead => _messageReadController.stream;
  Stream<ChatLockedEvent> get chatLocked => _chatLockedController.stream;
  Stream<PresenceChangedEvent> get presenceChanged =>
      _presenceController.stream;

  bool get isChatConnected =>
      !_backgrounded && _chatConnection?.state == HubConnectionState.Connected;

  Future<void> connect() => _serialize(() async {
    final token = await _secureStorage.getAccessToken();
    if (token == null || token.isEmpty) {
      _authenticated = false;
      return;
    }
    _authenticated = true;
    if (_connectionToken != token) {
      await _replaceConnections(token);
    }
    if (!_backgrounded) {
      await _startConnections();
    }
  });

  Future<void> reconnectWithLatestToken() => _serialize(() async {
    final token = await _secureStorage.getAccessToken();
    if (token == null || token.isEmpty) {
      await _disconnect(clearGroups: true);
      return;
    }
    _authenticated = true;
    await _replaceConnections(token);
    if (!_backgrounded) {
      await _startConnections();
    }
  });

  Future<void> disconnect() => _serialize(() => _disconnect(clearGroups: true));

  Future<void> joinBookingGroup(String bookingId) async {
    _bookingGroups.add(bookingId);
    await _invokeIfConnected(_bookingConnection, 'JoinBookingGroup', <Object>[
      bookingId,
    ]);
  }

  Future<void> leaveBookingGroup(String bookingId) async {
    _bookingGroups.remove(bookingId);
    await _invokeIfConnected(_bookingConnection, 'LeaveBookingGroup', <Object>[
      bookingId,
    ]);
  }

  Future<void> joinChat(String bookingId) async {
    _chatGroups.add(bookingId);
    await _invokeIfConnected(_chatConnection, 'JoinBooking', <Object>[
      bookingId,
    ]);
  }

  Future<void> leaveChat(String bookingId) async {
    _chatGroups.remove(bookingId);
    await _invokeIfConnected(_chatConnection, 'LeaveBooking', <Object>[
      bookingId,
    ]);
  }

  Future<ChatMessageEntity> sendChatMessage(
    String bookingId,
    Map<String, dynamic> message,
  ) async {
    final connection = _chatConnection;
    if (connection?.state != HubConnectionState.Connected) {
      throw const RealtimeUnavailableException();
    }
    final response = await connection!.invoke(
      'SendMessage',
      args: <Object>[bookingId, message],
    );
    return _chatMessage(_responseMap(response));
  }

  Future<void> markChatRead(String bookingId) =>
      _invokeIfConnected(_chatConnection, 'MarkRead', <Object>[bookingId]);

  Future<void> _serialize(Future<void> Function() action) {
    final scheduled = _operation.then((_) => action());
    _operation = scheduled.onError((Object error, StackTrace stackTrace) {
      debugPrint('Realtime lifecycle error: $error');
    });
    return _operation;
  }

  Future<void> _replaceConnections(String token) async {
    await _stopConnections();
    _connectionToken = token;
    _bookingConnection = _buildConnection('booking', token);
    _chatConnection = _buildConnection('chat', token);
    _notificationConnection = _buildConnection('notifications', token);
    _registerBookingEvents(_bookingConnection!);
    _registerChatEvents(_chatConnection!);
    _registerReconnectHandlers();
  }

  HubConnection _buildConnection(String hub, String token) {
    final uri = Uri.parse(
      '${AppConfig.origin}/hubs/$hub',
    ).replace(queryParameters: <String, String>{'access_token': token});
    return HubConnectionBuilder()
        .withUrl(uri.toString())
        .withAutomaticReconnect()
        .build();
  }

  void _registerReconnectHandlers() {
    _bookingConnection!.onreconnected(
      ({String? connectionId}) =>
          unawaited(_restoreConnection(RealtimeHub.booking)),
    );
    _chatConnection!.onreconnected(
      ({String? connectionId}) =>
          unawaited(_restoreConnection(RealtimeHub.chat)),
    );
    _notificationConnection!.onreconnected(
      ({String? connectionId}) => _connectedController.add(
        const RealtimeHubConnected(RealtimeHub.notifications),
      ),
    );
  }

  Future<void> _startConnections() async {
    await Future.wait<void>(<Future<void>>[
      _startConnection(_bookingConnection, RealtimeHub.booking),
      _startConnection(_chatConnection, RealtimeHub.chat),
      _startConnection(_notificationConnection, RealtimeHub.notifications),
    ]);
  }

  Future<void> _startConnection(
    HubConnection? connection,
    RealtimeHub hub,
  ) async {
    if (connection == null ||
        connection.state == HubConnectionState.Connected ||
        connection.state == HubConnectionState.Connecting ||
        connection.state == HubConnectionState.Reconnecting) {
      return;
    }
    try {
      await connection.start();
      await _restoreConnection(hub);
    } on Exception catch (error) {
      debugPrint('Realtime ${hub.name} connection unavailable: $error');
    }
  }

  Future<void> _restoreConnection(RealtimeHub hub) async {
    if (hub == RealtimeHub.booking) {
      await _rejoinGroups(
        _bookingConnection,
        'JoinBookingGroup',
        _bookingGroups,
      );
    } else if (hub == RealtimeHub.chat) {
      await _rejoinGroups(_chatConnection, 'JoinBooking', _chatGroups);
    }
    _connectedController.add(RealtimeHubConnected(hub));
  }

  Future<void> _rejoinGroups(
    HubConnection? connection,
    String method,
    Set<String> bookingIds,
  ) async {
    for (final bookingId in bookingIds) {
      await _invokeIfConnected(connection, method, <Object>[bookingId]);
    }
  }

  Future<void> _invokeIfConnected(
    HubConnection? connection,
    String method,
    List<Object> arguments,
  ) async {
    if (connection?.state != HubConnectionState.Connected) {
      return;
    }
    try {
      await connection!.invoke(method, args: arguments);
    } on Exception catch (error) {
      debugPrint('Realtime $method failed: $error');
    }
  }

  Future<void> _disconnect({required bool clearGroups}) async {
    _authenticated = false;
    await _stopConnections();
    _bookingConnection = null;
    _chatConnection = null;
    _notificationConnection = null;
    _connectionToken = null;
    if (clearGroups) {
      _bookingGroups.clear();
      _chatGroups.clear();
    }
  }

  Future<void> _stopConnections() async {
    await Future.wait<void>(<Future<void>>[
      _stopConnection(_bookingConnection),
      _stopConnection(_chatConnection),
      _stopConnection(_notificationConnection),
    ]);
  }

  Future<void> _stopConnection(HubConnection? connection) async {
    if (connection == null ||
        connection.state == HubConnectionState.Disconnected) {
      return;
    }
    try {
      await connection.stop();
    } on Exception catch (error) {
      debugPrint('Realtime disconnect failed: $error');
    }
  }

  void _registerBookingEvents(HubConnection connection) {
    _registerProviderBookingEvents(connection);
    _registerCustomerBookingEvents(connection);
  }

  void _registerProviderBookingEvents(HubConnection connection) {
    _listen(connection, 'JobDispatched', _pendingJob, _jobDispatchedController);
    connection.on(
      'JobDispatchExpired',
      (arguments) =>
          _publishDismissal(arguments, JobOfferDismissalKind.expired),
    );
    connection.on(
      'JobTaken',
      (arguments) => _publishDismissal(arguments, JobOfferDismissalKind.taken),
    );
    connection.on(
      'JobCancelled',
      (arguments) =>
          _publishDismissal(arguments, JobOfferDismissalKind.cancelled),
    );
  }

  void _registerCustomerBookingEvents(HubConnection connection) {
    _listen(
      connection,
      'BookingStatusChanged',
      _bookingStatus,
      _bookingStatusController,
    );
    _listen(
      connection,
      'ProviderAssigned',
      _providerAssigned,
      _providerAssignedController,
    );
    _listen(
      connection,
      'ProviderLocation',
      _providerLocation,
      _providerLocationController,
    );
    _listen(
      connection,
      'NoProviderFound',
      _noProviderFound,
      _noProviderController,
    );
    _listen(
      connection,
      'PaymentStatusChanged',
      PaymentStatusChangedEvent.new,
      _paymentStatusController,
    );
  }

  void _registerChatEvents(HubConnection connection) {
    _listen(connection, 'ReceiveMessage', _chatMessage, _chatMessageController);
    _listen(connection, 'MessageRead', _messageRead, _messageReadController);
    _listen(
      connection,
      'ChatLocked',
      (payload) => ChatLockedEvent(_requiredString(payload, 'bookingId')),
      _chatLockedController,
    );
    _listen(
      connection,
      'PresenceChanged',
      _presenceChanged,
      _presenceController,
    );
  }

  void _listen<T>(
    HubConnection connection,
    String eventName,
    T Function(Map<String, dynamic>) parser,
    StreamController<T> controller,
  ) {
    connection.on(
      eventName,
      (arguments) => _publish(eventName, arguments, parser, controller),
    );
  }

  void _publish<T>(
    String eventName,
    List<Object?>? arguments,
    T Function(Map<String, dynamic>) parser,
    StreamController<T> controller,
  ) {
    try {
      controller.add(parser(_payload(arguments)));
    } on FormatException catch (error) {
      debugPrint('Realtime $eventName payload ignored: ${error.message}');
    }
  }

  void _publishDismissal(List<Object?>? arguments, JobOfferDismissalKind kind) {
    _publish(
      kind.name,
      arguments,
      (payload) => JobOfferDismissed(
        bookingId: _requiredString(payload, 'bookingId'),
        kind: kind,
        reason: kind == JobOfferDismissalKind.cancelled
            ? _requiredString(payload, 'reason')
            : null,
      ),
      _jobDismissedController,
    );
  }

  PendingJobEntity _pendingJob(Map<String, dynamic> json) {
    final expiresAt = _requiredDate(json, 'expiresAt');
    final seconds = _optionalInt(json, 'secondsRemaining');
    return PendingJobEntity(
      bookingId: _requiredString(json, 'bookingId'),
      serviceNameEn: _requiredString(json, 'serviceNameEn'),
      serviceNameAr: _requiredString(json, 'serviceNameAr'),
      categoryNameEn: _requiredString(json, 'categoryNameEn'),
      categoryNameAr: _requiredString(json, 'categoryNameAr'),
      customerFirstName: _requiredString(json, 'customerFirstName'),
      customerAvatarUrl: _optionalString(json, 'customerAvatarUrl'),
      distanceKm: _requiredDouble(json, 'distanceKm'),
      providerEarning: _requiredDouble(json, 'providerEarning'),
      currency: _requiredString(json, 'currency'),
      estimatedDurationMin: _optionalInt(json, 'estimatedDurationMin'),
      estimatedDurationMax: _optionalInt(json, 'estimatedDurationMax'),
      bookingType: _optionalString(json, 'bookingType') ?? '',
      scheduledTime: _optionalDate(json, 'scheduledTime'),
      expiresAt: expiresAt,
      secondsRemaining:
          seconds ??
          expiresAt
              .difference(DateTime.now().toUtc())
              .inSeconds
              .clamp(0, 86400)
              .toInt(),
    );
  }

  BookingStatusChangedEvent _bookingStatus(Map<String, dynamic> json) =>
      BookingStatusChangedEvent(
        bookingId: _requiredString(json, 'bookingId'),
        status: _requiredInt(json, 'status'),
        statusLabelEn: _requiredString(json, 'statusLabelEn'),
        statusLabelAr: _requiredString(json, 'statusLabelAr'),
        changedAt: _requiredDate(json, 'changedAt'),
        etaMinutes: _optionalInt(json, 'etaMinutes'),
        message: _optionalString(json, 'message'),
      );

  ProviderAssignedEvent _providerAssigned(Map<String, dynamic> json) =>
      ProviderAssignedEvent(
        providerId: _requiredString(json, 'providerId'),
        fullName: _requiredString(json, 'fullName'),
        jobTitle: _optionalString(json, 'jobTitle'),
        avatarUrl: _optionalString(json, 'avatarUrl'),
        rating: _optionalDouble(json, 'rating'),
        reviewCount: _requiredInt(json, 'reviewCount'),
        isVerified: _requiredBool(json, 'isVerified'),
        etaMinutes: _optionalInt(json, 'etaMinutes'),
        distanceKm: _optionalDouble(json, 'distanceKm'),
        phoneNumber: _optionalString(json, 'phoneNumber'),
        currentLatitude: _optionalDouble(json, 'currentLatitude'),
        currentLongitude: _optionalDouble(json, 'currentLongitude'),
      );

  ProviderLocationEvent _providerLocation(Map<String, dynamic> json) =>
      ProviderLocationEvent(
        bookingId: _requiredString(json, 'bookingId'),
        providerId: _requiredString(json, 'providerId'),
        latitude: _requiredDouble(json, 'latitude'),
        longitude: _requiredDouble(json, 'longitude'),
        headingDegrees: _optionalDouble(json, 'headingDegrees'),
        etaMinutes: _optionalInt(json, 'etaMinutes'),
        updatedAt: _requiredDate(json, 'updatedAt'),
      );

  NoProviderFoundEvent _noProviderFound(Map<String, dynamic> json) =>
      NoProviderFoundEvent(
        bookingId: _requiredString(json, 'bookingId'),
        roundsTried: _requiredInt(json, 'roundsTried'),
      );

  ChatMessageEntity _chatMessage(Map<String, dynamic> json) =>
      ChatMessageEntity(
        id: _requiredString(json, 'id'),
        bookingId: _requiredString(json, 'bookingId'),
        senderId: _requiredString(json, 'senderId'),
        senderName: _optionalString(json, 'senderName'),
        isMine: _requiredBool(json, 'isMine'),
        messageType: _requiredString(json, 'messageType'),
        messageText: _optionalString(json, 'messageText'),
        attachmentUrl: _optionalString(json, 'attachmentUrl'),
        sentAt: _requiredDate(json, 'sentAt'),
        isRead: _requiredBool(json, 'isRead'),
      );

  MessageReadEvent _messageRead(Map<String, dynamic> json) => MessageReadEvent(
    bookingId: _requiredString(json, 'bookingId'),
    messageId: _requiredString(json, 'messageId'),
  );

  PresenceChangedEvent _presenceChanged(Map<String, dynamic> json) =>
      PresenceChangedEvent(
        userId: _requiredString(json, 'userId'),
        isOnline: _requiredBool(json, 'isOnline'),
      );

  Map<String, dynamic> _payload(List<Object?>? arguments) {
    if (arguments == null || arguments.isEmpty) {
      throw const FormatException('missing payload');
    }
    return _responseMap(arguments.first);
  }

  Map<String, dynamic> _responseMap(Object? response) {
    if (response is! Map) {
      throw const FormatException('payload is not an object');
    }
    final payload = <String, dynamic>{};
    for (final entry in response.entries) {
      if (entry.key is! String) {
        throw const FormatException('payload contains a non-string key');
      }
      payload[entry.key as String] = entry.value;
    }
    return payload;
  }

  String _requiredString(Map<String, dynamic> json, String key) {
    final raw = json[key];
    if (raw is! String || raw.isEmpty) {
      throw FormatException('$key must be a non-empty string');
    }
    return raw;
  }

  String? _optionalString(Map<String, dynamic> json, String key) {
    final raw = json[key];
    if (raw == null) {
      return null;
    }
    if (raw is! String) {
      throw FormatException('$key must be a string');
    }
    return raw;
  }

  int _requiredInt(Map<String, dynamic> json, String key) {
    final raw = json[key];
    if (raw is! num) {
      throw FormatException('$key must be a number');
    }
    return raw.toInt();
  }

  int? _optionalInt(Map<String, dynamic> json, String key) {
    final raw = json[key];
    if (raw == null) {
      return null;
    }
    if (raw is! num) {
      throw FormatException('$key must be a number');
    }
    return raw.toInt();
  }

  double _requiredDouble(Map<String, dynamic> json, String key) {
    final raw = json[key];
    if (raw is! num) {
      throw FormatException('$key must be a number');
    }
    return raw.toDouble();
  }

  double? _optionalDouble(Map<String, dynamic> json, String key) {
    final raw = json[key];
    if (raw == null) {
      return null;
    }
    if (raw is! num) {
      throw FormatException('$key must be a number');
    }
    return raw.toDouble();
  }

  bool _requiredBool(Map<String, dynamic> json, String key) {
    final raw = json[key];
    if (raw is! bool) {
      throw FormatException('$key must be a boolean');
    }
    return raw;
  }

  DateTime _requiredDate(Map<String, dynamic> json, String key) {
    final parsed = _optionalDate(json, key);
    if (parsed == null) {
      throw FormatException('$key must be an ISO-8601 date');
    }
    return parsed;
  }

  DateTime? _optionalDate(Map<String, dynamic> json, String key) {
    final raw = json[key];
    if (raw == null) {
      return null;
    }
    if (raw is! String) {
      throw FormatException('$key must be an ISO-8601 date');
    }
    // UTC-aware: a zone-less server timestamp is UTC, not device-local. Parsing
    // it as local pushed dispatch deadlines hours into the past, so a live offer
    // expired the instant it was received.
    final parsed = parseServerDateTime(raw);
    if (parsed == null) {
      throw FormatException('$key must be an ISO-8601 date');
    }
    return parsed;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _backgrounded = false;
      if (_authenticated) {
        unawaited(connect());
      }
      return;
    }
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden) {
      _backgrounded = true;
      unawaited(_serialize(_stopConnections));
    }
  }
}

class RealtimeUnavailableException implements Exception {
  const RealtimeUnavailableException();
}
