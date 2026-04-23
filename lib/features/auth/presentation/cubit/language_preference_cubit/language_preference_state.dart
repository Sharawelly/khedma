part of 'language_preference_cubit.dart';

class LanguagePreferenceState extends Equatable {
  const LanguagePreferenceState({required this.selected});

  final LanguageCode selected;

  @override
  List<Object?> get props => [selected];
}
