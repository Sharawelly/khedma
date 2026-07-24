import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/realtime/realtime_events.dart';
import '/core/realtime/realtime_service.dart';
import '../../domain/entities/chat_entities.dart';
import '../../domain/usecases/chat_use_cases.dart';
import '../../domain/usecases/params/chat_params.dart';

part 'chat_details_state.dart';

sealed class ChatCommand {
  const ChatCommand();
}

class LoadChatHistory extends ChatCommand {
  const LoadChatHistory(this.thread);
  final ChatThreadEntity thread;
}

class LoadEarlierChatMessages extends ChatCommand {
  const LoadEarlierChatMessages();
}

class SendTextMessage extends ChatCommand {
  const SendTextMessage(this.bookingId, this.text);
  final String bookingId;
  final String text;
}

class SendQuickReply extends ChatCommand {
  const SendQuickReply(this.bookingId, this.key);
  final String bookingId;
  final String key;
}

class SendImageMessage extends ChatCommand {
  const SendImageMessage(this.bookingId, this.file);
  final String bookingId;
  final File file;
}

class RetryMessage extends ChatCommand {
  const RetryMessage(this.message);
  final ChatMessageEntity message;
}

class ChatDetailsCubit extends Cubit<ChatDetailsState> {
  ChatDetailsCubit({
    required this.getChatHistory,
    required this.sendChatMessage,
    required this.uploadChatAttachment,
    required this.markChatRead,
    required this.realtimeService,
  }) : super(const ChatDetailsInitial()) {
    _subscriptions
      ..add(realtimeService.chatMessage.listen(_messageReceived))
      ..add(realtimeService.messageRead.listen(_messageRead))
      ..add(realtimeService.chatLocked.listen(_chatLocked))
      ..add(realtimeService.presenceChanged.listen(_presenceChanged));
  }

  final GetChatHistory getChatHistory;
  final SendChatMessage sendChatMessage;
  final UploadChatAttachment uploadChatAttachment;
  final MarkChatRead markChatRead;
  final RealtimeService realtimeService;
  final List<ChatMessageEntity> _messages = <ChatMessageEntity>[];
  final List<StreamSubscription<Object?>> _subscriptions =
      <StreamSubscription<Object?>>[];
  String? _bookingId;
  String? _peerId;
  bool _isLocked = false;
  bool _isPeerOnline = false;
  ChatThreadEntity? _thread;
  int _historyPage = 1;
  bool _historyHasNextPage = false;
  bool _isLoadingHistory = false;
  int _errorNonce = 0;

  Future<void> execute(ChatCommand command) async {
    if (command is LoadChatHistory) {
      await _load(command.thread);
    } else if (command is LoadEarlierChatMessages) {
      await _loadEarlier();
    } else if (command is SendTextMessage) {
      await _send(
        SendMessageParams(
          bookingId: command.bookingId,
          messageType: 'Text',
          messageText: command.text,
        ),
      );
    } else if (command is SendQuickReply) {
      await _send(
        SendMessageParams(
          bookingId: command.bookingId,
          messageType: 'QuickReply',
          messageText: command.key,
        ),
      );
    } else if (command is SendImageMessage) {
      await _sendImage(command);
    } else if (command is RetryMessage) {
      await _retry(command.message);
    }
  }

  Future<void> _load(ChatThreadEntity thread) async {
    if (_isLoadingHistory) {
      return;
    }
    _isLoadingHistory = true;
    _thread = thread;
    _bookingId = thread.bookingId;
    _peerId = thread.peerId;
    _isLocked = thread.isLocked;
    _isPeerOnline = thread.isOnline;
    await realtimeService.joinChat(thread.bookingId);
    emit(const ChatDetailsLoading());
    final response = await getChatHistory(
      ChatHistoryParams(bookingId: thread.bookingId),
    );
    response.fold(
      (failure) {
        _isLoadingHistory = false;
        emit(ChatDetailsFailure(failure.message ?? ''));
      },
      (history) {
        final merged = <String, ChatMessageEntity>{
          for (final message in history.messages) message.id: message,
          for (final message in _messages) message.id: message,
        };
        _messages
          ..clear()
          ..addAll(merged.values)
          ..sort((left, right) => left.sentAt.compareTo(right.sentAt));
        _historyPage = history.pagination.page ?? 1;
        _historyHasNextPage = history.pagination.hasNextPage ?? false;
        _isLoadingHistory = false;
        _emitMessages();
      },
    );
    if (realtimeService.isChatConnected) {
      await realtimeService.markChatRead(thread.bookingId);
    } else {
      await markChatRead(thread.bookingId);
    }
  }

  Future<void> _loadEarlier() async {
    final thread = _thread;
    if (thread == null || _isLoadingHistory || !_historyHasNextPage) {
      return;
    }
    _isLoadingHistory = true;
    final requestedPage = _historyPage + 1;
    final response = await getChatHistory(
      ChatHistoryParams(bookingId: thread.bookingId, page: requestedPage),
    );
    response.fold(
      (failure) {
        _isLoadingHistory = false;
        emit(ChatDetailsFailure(failure.message ?? ''));
      },
      (history) {
        final merged = <String, ChatMessageEntity>{
          for (final message in history.messages) message.id: message,
          for (final message in _messages) message.id: message,
        };
        _messages
          ..clear()
          ..addAll(merged.values)
          ..sort((left, right) => left.sentAt.compareTo(right.sentAt));
        _historyPage = history.pagination.page ?? requestedPage;
        _historyHasNextPage = history.pagination.hasNextPage ?? false;
        _isLoadingHistory = false;
        _emitMessages();
      },
    );
  }

  /// Optimistically shows the caller's bubble immediately, then delivers it over
  /// whichever transport is available. A send failure marks that one bubble as
  /// failed (tap to retry) - it never wipes the conversation.
  Future<void> _send(SendMessageParams params) async {
    final pending = _pendingMessage(params);
    _append(pending);
    try {
      final sent = await _deliver(params);
      _replacePending(pending.id, sent);
    } on Exception catch (error) {
      _markFailed(pending.id);
      final reason = error is _ChatSendException ? error.message : null;
      if (reason != null && reason.isNotEmpty) {
        _emitTransientError(reason);
      }
    }
  }

  /// Realtime first, then REST. A socket that reports Connected can still fail an
  /// invoke, and the REST endpoint is the backend's designed fallback for a
  /// broken socket - so a realtime failure retries over HTTP before giving up.
  Future<ChatMessageEntity> _deliver(SendMessageParams params) async {
    if (realtimeService.isChatConnected) {
      try {
        return await realtimeService.sendChatMessage(
          params.bookingId,
          params.toJson(),
        );
      } on Exception {
        // Fall through to REST.
      }
    }
    final response = await sendChatMessage(params);
    return response.fold(
      (failure) => throw _ChatSendException(failure.message),
      (message) => message,
    );
  }

  Future<void> _sendImage(SendImageMessage command) async {
    // Upload has no bubble yet, so a failure here surfaces as a transient error
    // rather than a phantom failed image. The bubble only appears once we have a
    // url to render.
    final uploadResponse = await uploadChatAttachment(
      command.bookingId,
      command.file,
    );
    await uploadResponse.fold(
      (failure) async => _emitTransientError('chat_realtime_send_failed'),
      (url) => _send(
        SendMessageParams(
          bookingId: command.bookingId,
          messageType: 'Image',
          attachmentUrl: url,
        ),
      ),
    );
  }

  Future<void> _retry(ChatMessageEntity failed) async {
    _messages.removeWhere((message) => message.id == failed.id);
    await _send(
      SendMessageParams(
        bookingId: failed.bookingId,
        messageType: failed.messageType,
        messageText: failed.messageText,
        attachmentUrl: failed.attachmentUrl,
      ),
    );
  }

  ChatMessageEntity _pendingMessage(SendMessageParams params) =>
      ChatMessageEntity(
        id: 'local-${DateTime.now().microsecondsSinceEpoch}',
        bookingId: params.bookingId,
        senderId: '',
        isMine: true,
        messageType: params.messageType,
        messageText: params.messageText,
        attachmentUrl: params.attachmentUrl,
        sentAt: DateTime.now().toUtc(),
        isRead: false,
        deliveryStatus: ChatDeliveryStatus.sending,
      );

  void _replacePending(String pendingId, ChatMessageEntity sent) {
    _messages.removeWhere((message) => message.id == pendingId);
    _append(sent);
  }

  void _markFailed(String pendingId) {
    final index = _messages.indexWhere((message) => message.id == pendingId);
    if (index < 0) {
      return;
    }
    _messages[index] = _messages[index].copyWith(
      deliveryStatus: ChatDeliveryStatus.failed,
    );
    _emitMessages();
  }

  void _messageReceived(ChatMessageEntity message) {
    if (message.bookingId != _bookingId) {
      return;
    }
    // The server echoes our own message back over the socket; drop the matching
    // optimistic bubble so it is not shown twice while the invoke is in flight.
    if (message.isMine) {
      _dropMatchingPending(message);
    }
    _append(message);
  }

  void _dropMatchingPending(ChatMessageEntity real) {
    final index = _messages.indexWhere(
      (message) =>
          message.isPending &&
          message.isMine &&
          message.messageType == real.messageType &&
          message.messageText == real.messageText &&
          message.attachmentUrl == real.attachmentUrl,
    );
    if (index >= 0) {
      _messages.removeAt(index);
    }
  }

  void _messageRead(MessageReadEvent event) {
    if (event.bookingId != _bookingId) {
      return;
    }
    final index = _messages.indexWhere(
      (message) => message.id == event.messageId,
    );
    if (index >= 0) {
      _messages[index] = _messages[index].copyWith(isRead: true);
      _emitMessages();
    }
  }

  void _chatLocked(ChatLockedEvent event) {
    if (event.bookingId == _bookingId) {
      _isLocked = true;
      _emitMessages();
    }
  }

  void _presenceChanged(PresenceChangedEvent event) {
    if (event.userId == _peerId) {
      _isPeerOnline = event.isOnline;
      _emitMessages();
    }
  }

  void _append(ChatMessageEntity message) {
    if (_messages.any((existing) => existing.id == message.id)) {
      return;
    }
    _messages.add(message);
    _messages.sort((left, right) => left.sentAt.compareTo(right.sentAt));
    _emitMessages();
  }

  void _emitMessages({String? transientError}) {
    emit(
      ChatDetailsSuccess(
        List<ChatMessageEntity>.unmodifiable(_messages),
        isLocked: _isLocked,
        isPeerOnline: _isPeerOnline,
        hasNextPage: _historyHasNextPage,
        transientError: transientError,
        errorNonce: transientError == null ? _errorNonce : ++_errorNonce,
      ),
    );
  }

  void _emitTransientError(String message) =>
      _emitMessages(transientError: message);

  @override
  Future<void> close() async {
    final bookingId = _bookingId;
    if (bookingId != null) {
      await realtimeService.leaveChat(bookingId);
    }
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    return super.close();
  }
}

/// Raised when every transport has refused a message, carrying the server reason
/// so the failed bubble/snackbar can explain why.
class _ChatSendException implements Exception {
  const _ChatSendException(this.message);
  final String? message;
}
