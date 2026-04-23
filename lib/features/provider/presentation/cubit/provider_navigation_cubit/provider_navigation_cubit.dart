import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:khedma/features/provider/presentation/widgets/provider_bottom_nav_bar.dart';

part 'provider_navigation_state.dart';

class ProviderNavigationCubit extends Cubit<ProviderNavigationState> {
  ProviderNavigationCubit()
      : super(
          const ProviderNavigationState(current: ProviderNavItem.home),
        );

  void changeIndex(ProviderNavItem index) {
    if (state.current == index) {
      return;
    }
    if (!isClosed) {
      emit(ProviderNavigationState(current: index));
    }
  }

  void reset() {
    if (!isClosed) {
      emit(
        const ProviderNavigationState(current: ProviderNavItem.home),
      );
    }
  }
}
