part of 'chat_threads_cubit.dart';

sealed class ChatThreadsState extends Equatable {
  const ChatThreadsState();
  @override
  List<Object?> get props => <Object?>[];
}

class ChatThreadsInitial extends ChatThreadsState {
  const ChatThreadsInitial();
}

class ChatThreadsLoading extends ChatThreadsState {
  const ChatThreadsLoading();
}

class ChatThreadsFailure extends ChatThreadsState {
  const ChatThreadsFailure(this.message);
  final String message;
  @override
  List<Object?> get props => <Object?>[message];
}

class ChatThreadsSuccess extends ChatThreadsState {
  const ChatThreadsSuccess(this.threads);
  final List<ChatThreadEntity> threads;
  @override
  List<Object?> get props => <Object?>[threads];
}
