part of 'navigation_cubit.dart';

class NavigationState extends Equatable {
  final BottomNavItem currentIndex;

  const NavigationState({required this.currentIndex});

  @override
  List<Object> get props => [currentIndex];
}
