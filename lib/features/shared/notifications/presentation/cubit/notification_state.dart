part of 'notification_cubit.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();
  @override
  List<Object?> get props => <Object?>[];
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

class NotificationFailure extends NotificationState {
  const NotificationFailure(this.message);
  final String message;
  @override
  List<Object?> get props => <Object?>[message];
}

class NotificationSuccess extends NotificationState {
  const NotificationSuccess(this.notifications, this.hasNextPage);
  final List<NotificationEntity> notifications;
  final bool hasNextPage;
  @override
  List<Object?> get props => <Object?>[notifications, hasNextPage];
}
