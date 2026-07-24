import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/chat_entities.dart';
import '../../domain/usecases/chat_use_cases.dart';
import '../../domain/usecases/params/chat_params.dart';

part 'chat_details_state.dart';

sealed class ChatCommand {
  const ChatCommand();
}

class LoadChatHistory extends ChatCommand {
  const LoadChatHistory(this.bookingId);
  final String bookingId;
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
  }) : super(const ChatDetailsInitial());

  final GetChatHistory getChatHistory;
  final SendChatMessage sendChatMessage;
  final UploadChatAttachment uploadChatAttachment;
  final MarkChatRead markChatRead;
  final List<ChatMessageEntity> _messages = <ChatMessageEntity>[];

  Future<void> execute(ChatCommand command) async {
    if (command is LoadChatHistory) {
      await _load(command.bookingId);
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

  Future<void> _load(String bookingId) async {
    emit(const ChatDetailsLoading());
    final response = await getChatHistory(
      ChatHistoryParams(bookingId: bookingId),
    );
    response.fold(
      (failure) => emit(ChatDetailsFailure(failure.message ?? '')),
      (history) {
        _messages
          ..clear()
          ..addAll(history.messages);
        emit(ChatDetailsSuccess(List.unmodifiable(_messages)));
      },
    );
    await markChatRead(bookingId);
  }

  Future<void> _send(SendMessageParams params) async {
    final response = await sendChatMessage(params);
    response.fold(
      (failure) => emit(ChatDetailsFailure(failure.message ?? '')),
      (message) {
        _messages.add(message);
        emit(ChatDetailsSuccess(List.unmodifiable(_messages)));
      },
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
}
