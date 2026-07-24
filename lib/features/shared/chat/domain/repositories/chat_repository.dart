import 'dart:io';

import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '../entities/chat_entities.dart';
import '../usecases/params/chat_params.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ChatThreadEntity>>> getThreads();
  Future<Either<Failure, ChatHistoryEntity>> getHistory(
    ChatHistoryParams params,
  );
  Future<Either<Failure, ChatMessageEntity>> sendMessage(
    SendMessageParams params,
  );
  Future<Either<Failure, String>> uploadAttachment(String bookingId, File file);
  Future<Either<Failure, Unit>> markRead(String bookingId);
}
