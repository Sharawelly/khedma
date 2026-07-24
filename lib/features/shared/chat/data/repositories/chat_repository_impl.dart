import 'dart:io';

import 'package:dartz/dartz.dart';

import '/core/error/exceptions.dart';
import '/core/error/failures.dart';
import '../../domain/entities/chat_entities.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/params/chat_params.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl(this.remote);
  final ChatRemoteDataSource remote;

  @override
  Future<Either<Failure, List<ChatThreadEntity>>> getThreads() {
    return _request(remote.getThreads);
  }

  @override
  Future<Either<Failure, ChatHistoryEntity>> getHistory(
    ChatHistoryParams params,
  ) {
    return _request(() => remote.getHistory(params));
  }

  @override
  Future<Either<Failure, ChatMessageEntity>> sendMessage(
    SendMessageParams params,
  ) {
    return _request(() => remote.sendMessage(params));
  }

  @override
  Future<Either<Failure, String>> uploadAttachment(
    String bookingId,
    File file,
  ) {
    return _request(() => remote.uploadAttachment(bookingId, file));
  }

  @override
  Future<Either<Failure, Unit>> markRead(String bookingId) async {
    try {
      await remote.markRead(bookingId);
      return const Right<Failure, Unit>(unit);
    } on AppException catch (error) {
      return Left<Failure, Unit>(error.toFailure());
    }
  }

  Future<Either<Failure, T>> _request<T>(Future<T> Function() request) async {
    try {
      return Right<Failure, T>(await request());
    } on AppException catch (error) {
      return Left<Failure, T>(error.toFailure());
    }
  }
}
