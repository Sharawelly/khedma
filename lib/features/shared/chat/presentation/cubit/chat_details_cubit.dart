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

  Future<void> execute(ChatCommand command) async {
    if (command is LoadChatHistory) {
      await _load(command.thread);
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
    }
  }

  Future<void> _load(ChatThreadEntity thread) async {
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
      (failure) => emit(ChatDetailsFailure(failure.message ?? '')),
      (history) {
        final merged = <String, ChatMessageEntity>{
          for (final message in history.messages) message.id: message,
          for (final message in _messages) message.id: message,
        };
        _messages
          ..clear()
          ..addAll(merged.values)
          ..sort((left, right) => left.sentAt.compareTo(right.sentAt));
        _emitMessages();
      },
    );
    if (realtimeService.isChatConnected) {
      await realtimeService.markChatRead(thread.bookingId);
    } else {
      await markChatRead(thread.bookingId);
    }
  }

  Future<void> _send(SendMessageParams params) async {
    if (realtimeService.isChatConnected) {
      try {
        _append(
          await realtimeService.sendChatMessage(
            params.bookingId,
            params.toJson(),
          ),
        );
      } on Exception {
        emit(const ChatDetailsFailure('chat_realtime_send_failed'));
      }
      return;
    }
    final response = await sendChatMessage(params);
    response.fold(
      (failure) => emit(ChatDetailsFailure(failure.message ?? '')),
      _append,
    );
  }

  Future<void> _sendImage(SendImageMessage command) async {
    final uploadResponse = await uploadChatAttachment(
      command.bookingId,
      command.file,
    );
    await uploadResponse.fold(
      (failure) async => emit(ChatDetailsFailure(failure.message ?? '')),
      (url) => _send(
        SendMessageParams(
          bookingId: command.bookingId,
          messageType: 'Image',
          attachmentUrl: url,
        ),
      ),
    );
  }

  void _messageReceived(ChatMessageEntity message) {
    if (message.bookingId == _bookingId) {
      _append(message);
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

  void _emitMessages() {
    emit(
      ChatDetailsSuccess(
        List<ChatMessageEntity>.unmodifiable(_messages),
        isLocked: _isLocked,
        isPeerOnline: _isPeerOnline,
      ),
    );
  }

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
