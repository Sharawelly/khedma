import 'dart:io';

import 'package:dio/dio.dart';

import '/core/api/dio_consumer.dart';
import '/core/error/exceptions.dart';
import '/injection_container.dart';
import '../../domain/usecases/params/chat_params.dart';
import '../models/chat_models.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatThreadModel>> getThreads();
  Future<ChatHistoryModel> getHistory(ChatHistoryParams params);
  Future<ChatMessageModel> sendMessage(SendMessageParams params);
  Future<String> uploadAttachment(String bookingId, File file);
  Future<void> markRead(String bookingId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  @override
  Future<List<ChatThreadModel>> getThreads() async {
    final response = await dioConsumer.get(ApiConstants.chatThreads);
    return _list(response).map(ChatThreadModel.fromJson).toList();
  }

  @override
  Future<ChatHistoryModel> getHistory(ChatHistoryParams params) async {
    final response = await dioConsumer.get(
      ApiConstants.chatHistory(params.bookingId),
      queryParameters: <String, dynamic>{
        'page': params.page,
        'pageSize': params.pageSize,
      },
    );
    return ChatHistoryModel.fromJson(_responseMap(response));
  }

  @override
  Future<ChatMessageModel> sendMessage(SendMessageParams params) async {
    final response = await dioConsumer.post(
      ApiConstants.chatMessages(params.bookingId),
      body: params.toJson(),
    );
    return ChatMessageModel.fromJson(_dataMap(response));
  }

  @override
  Future<String> uploadAttachment(String bookingId, File file) async {
    final response = await dioConsumer.post(
      ApiConstants.chatAttachments(bookingId),
      formData: FormData.fromMap(<String, dynamic>{
        'file': await MultipartFile.fromFile(file.path),
      }),
    );
    final attachmentUrl = _responseMap(response)['data'];
    if (attachmentUrl is! String) {
      throw const ServerException();
    }
    return attachmentUrl;
  }

  @override
  Future<void> markRead(String bookingId) async {
    _responseMap(await dioConsumer.post(ApiConstants.markChatRead(bookingId)));
  }

  List<Map<String, dynamic>> _list(Object? response) {
    final payload = _responseMap(response)['data'];
    if (payload is! List) {
      throw const ServerException();
    }
    return payload.cast<Map<String, dynamic>>();
  }

  Map<String, dynamic> _dataMap(Object? response) {
    final payload = _responseMap(response)['data'];
    if (payload is! Map<String, dynamic>) {
      throw const ServerException();
    }
    return payload;
  }

  Map<String, dynamic> _responseMap(Object? response) {
    if (response is! Map<String, dynamic> || response['success'] != true) {
      throw ServerException(
        message: response is Map<String, dynamic>
            ? response['message'] as String?
            : null,
      );
    }
    return response;
  }
}
