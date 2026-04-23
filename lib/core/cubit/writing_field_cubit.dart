import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'writing_field_state.dart';

class WritingFieldCubit extends Cubit<WritingFieldState> {
  WritingFieldCubit() : super(const WritingFieldState());

  void onChanged(String text) {
    emit(WritingFieldState(charCount: text.length, text: text));
  }
}
