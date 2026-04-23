import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'choose_date_time_state.dart';

class ChooseDateTimeCubit extends Cubit<ChooseDateTimeState> {
  ChooseDateTimeCubit() : super(const ChooseDateTimeState());

  void selectNowMode() {
    if (state.isNowSelected) return;
    emit(state.copyWith(isNowSelected: true));
  }

  void selectScheduleMode() {
    if (!state.isNowSelected) return;
    emit(state.copyWith(isNowSelected: false));
  }

  void selectDate(int index) {
    if (state.selectedDateIndex == index) return;
    emit(state.copyWith(selectedDateIndex: index));
  }

  void selectTime(String timeKey) {
    if (state.selectedTimeKey == timeKey) return;
    emit(state.copyWith(selectedTimeKey: timeKey));
  }
}
