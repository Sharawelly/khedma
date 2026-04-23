import 'package:bloc/bloc.dart';

class AcceptTermsCubit extends Cubit<bool> {
  AcceptTermsCubit() : super(false);
  void toggleCheckbox() {
    emit(!state);
  }
}
