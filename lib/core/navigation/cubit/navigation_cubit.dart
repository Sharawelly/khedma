import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/widgets/app_bottom_nav_bar.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit()
    : super(const NavigationState(currentIndex: BottomNavItem.home));

  void changeNavigationIndex(BottomNavItem index) {
    if (state.currentIndex == index) return;
    // Check if the cubit is still open before emitting
    if (!isClosed) {
      emit(NavigationState(currentIndex: index));
    }
  }

  /// Reset navigation to home - useful when user logs out
  void resetNavigation() {
    if (!isClosed) {
      emit(const NavigationState(currentIndex: BottomNavItem.home));
    }
  }

  /// Reset cubit to initial state - used on logout
  void reset() {
    if (!isClosed) {
      emit(const NavigationState(currentIndex: BottomNavItem.home));
    }
  }
}
