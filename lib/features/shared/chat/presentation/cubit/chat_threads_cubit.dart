import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/chat_entities.dart';
import '../../domain/usecases/chat_use_cases.dart';

part 'chat_threads_state.dart';

class ChatThreadsCubit extends Cubit<ChatThreadsState> {
  ChatThreadsCubit(this.getChatThreads) : super(const ChatThreadsInitial());
  final GetChatThreads getChatThreads;

  Future<void> load() async {
    emit(const ChatThreadsLoading());
    final response = await getChatThreads();
    response.fold(
      (failure) => emit(ChatThreadsFailure(failure.message ?? '')),
      (threads) => emit(ChatThreadsSuccess(threads)),
    );
  }
}
