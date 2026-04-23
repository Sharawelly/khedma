part of 'writing_field_cubit.dart';

class WritingFieldState extends Equatable {
  const WritingFieldState({this.charCount = 0, this.text = ''});

  final int charCount;
  final String text;

  @override
  List<Object?> get props => <Object?>[charCount, text];
}
