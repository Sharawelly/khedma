import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/realtime/realtime_events.dart';
import '/core/realtime/realtime_service.dart';
import '../../domain/entities/chat_entities.dart';
import '../../domain/usecases/chat_use_cases.dart';

part 'chat_threads_state.dart';

class ChatThreadsCubit extends Cubit<ChatThreadsState> {
  ChatThreadsCubit(this.getChatThreads, this.realtimeService)
    : super(const ChatThreadsInitial()) {
    _subscriptions
      ..add(realtimeService.chatMessage.listen(_messageReceived))
      ..add(realtimeService.presenceChanged.listen(_presenceChanged))
      ..add(realtimeService.chatLocked.listen(_chatLocked));
  }

  final GetChatThreads getChatThreads;
  final RealtimeService realtimeService;
  final List<ChatThreadEntity> _threads = <ChatThreadEntity>[];
  final List<StreamSubscription<Object?>> _subscriptions =
      <StreamSubscription<Object?>>[];
  final Set<String> _receivedMessageIds = <String>{};

  Future<void> load() async {
    emit(const ChatThreadsLoading());
    final response = await getChatThreads();
    response.fold(
      (failure) => emit(ChatThreadsFailure(failure.message ?? '')),
      (threads) {
        _threads
          ..clear()
          ..addAll(threads);
        _emitThreads();
      },
    );
  }

  void _messageReceived(ChatMessageEntity message) {
    if (!_receivedMessageIds.add(message.id)) {
      return;
    }
    final index = _threads.indexWhere(
      (thread) => thread.bookingId == message.bookingId,
    );
    if (index < 0) {
      return;
    }
    final thread = _threads[index];
    _threads[index] = thread.copyWith(
      lastMessage: message.messageText ?? thread.lastMessage,
      lastMessageAt: message.sentAt,
      unreadCount: message.isMine ? thread.unreadCount : thread.unreadCount + 1,
    );
    _emitThreads();
  }

  void _presenceChanged(PresenceChangedEvent event) {
    _updateThreads(
      (thread) => thread.peerId == event.userId
          ? thread.copyWith(isOnline: event.isOnline)
          : thread,
    );
  }

  void _chatLocked(ChatLockedEvent event) {
    _updateThreads(
      (thread) => thread.bookingId == event.bookingId
          ? thread.copyWith(isLocked: true)
          : thread,
    );
  }

  void _updateThreads(ChatThreadEntity Function(ChatThreadEntity) update) {
    for (var index = 0; index < _threads.length; index++) {
      _threads[index] = update(_threads[index]);
    }
    _emitThreads();
  }

  void _emitThreads() {
    emit(ChatThreadsSuccess(List<ChatThreadEntity>.unmodifiable(_threads)));
  }

  @override
  Future<void> close() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    return super.close();
  }
}
