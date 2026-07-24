import 'dart:io';

import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '../entities/chat_entities.dart';
import '../repositories/chat_repository.dart';
import 'params/chat_params.dart';

class GetChatThreads {
  const GetChatThreads(this.repository);
  final ChatRepository repository;
  Future<Either<Failure, List<ChatThreadEntity>>> call() =>
      repository.getThreads();
}

class GetChatHistory {
  const GetChatHistory(this.repository);
  final ChatRepository repository;
  Future<Either<Failure, ChatHistoryEntity>> call(ChatHistoryParams params) =>
      repository.getHistory(params);
}

class SendChatMessage {
  const SendChatMessage(this.repository);
  final ChatRepository repository;
  Future<Either<Failure, ChatMessageEntity>> call(SendMessageParams params) =>
      repository.sendMessage(params);
}

class UploadChatAttachment {
  const UploadChatAttachment(this.repository);
  final ChatRepository repository;
  Future<Either<Failure, String>> call(String bookingId, File file) =>
      repository.uploadAttachment(bookingId, file);
}

class MarkChatRead {
  const MarkChatRead(this.repository);
  final ChatRepository repository;
  Future<Either<Failure, Unit>> call(String bookingId) =>
      repository.markRead(bookingId);
}
