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
    this.transientError,
    this.errorNonce = 0,
  });
  final List<ChatMessageEntity> messages;
  final bool isLocked;
  final bool isPeerOnline;
  final bool hasNextPage;

  /// A one-shot error (e.g. an attachment upload that failed) to surface as a
  /// snackbar while keeping the conversation on screen. [errorNonce] makes two
  /// identical error messages distinct states so the listener fires each time.
  final String? transientError;
  final int errorNonce;

  @override
  List<Object?> get props => <Object?>[
    messages,
    isLocked,
    isPeerOnline,
    hasNextPage,
    transientError,
    errorNonce,
  ];
}
