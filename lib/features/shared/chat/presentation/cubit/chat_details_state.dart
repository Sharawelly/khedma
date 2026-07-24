part of 'chat_details_cubit.dart';

sealed class ChatDetailsState extends Equatable {
  const ChatDetailsState();
  @override
  List<Object?> get props => <Object?>[];
}

class ChatDetailsInitial extends ChatDetailsState {
  const ChatDetailsInitial();
}

class ChatDetailsLoading extends ChatDetailsState {
  const ChatDetailsLoading();
}

class ChatDetailsFailure extends ChatDetailsState {
  const ChatDetailsFailure(this.message);
  final String message;
  @override
  List<Object?> get props => <Object?>[message];
}

class ChatDetailsSuccess extends ChatDetailsState {
  const ChatDetailsSuccess(
    this.messages, {
    required this.isLocked,
    required this.isPeerOnline,
    required this.hasNextPage,
  });
  final List<ChatMessageEntity> messages;
  final bool isLocked;
  final bool isPeerOnline;
  final bool hasNextPage;
  @override
  List<Object?> get props => <Object?>[
    messages,
    isLocked,
    isPeerOnline,
    hasNextPage,
  ];
}
