import 'package:flutter_bloc/flutter_bloc.dart';

class AcceptTermsCubit extends Cubit<bool> {
  AcceptTermsCubit() : super(false);
  void toggleCheckbox() {
    emit(!state);
  }
}
