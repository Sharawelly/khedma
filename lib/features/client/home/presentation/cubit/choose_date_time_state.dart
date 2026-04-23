part of 'choose_date_time_cubit.dart';

class ChooseDateTimeState extends Equatable {
  const ChooseDateTimeState({
    this.isNowSelected = true,
    this.selectedDateIndex = 0,
    this.selectedTimeKey = 'home_choose_date_time_slot_1000_am',
  });

  final bool isNowSelected;
  final int selectedDateIndex;
  final String selectedTimeKey;

  ChooseDateTimeState copyWith({
    bool? isNowSelected,
    int? selectedDateIndex,
    String? selectedTimeKey,
  }) {
    return ChooseDateTimeState(
      isNowSelected: isNowSelected ?? this.isNowSelected,
      selectedDateIndex: selectedDateIndex ?? this.selectedDateIndex,
      selectedTimeKey: selectedTimeKey ?? this.selectedTimeKey,
    );
  }

  @override
  List<Object> get props => <Object>[
    isNowSelected,
    selectedDateIndex,
    selectedTimeKey,
  ];
}
