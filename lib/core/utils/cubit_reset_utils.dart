import 'package:flutter/foundation.dart';

import '/core/navigation/cubit/navigation_cubit.dart';
import '/features/provider/home/presentation/cubit/provider_navigation_cubit/provider_navigation_cubit.dart';

import '/injection_container.dart';

/// Utility class to reset all cubits to their initial state
/// This is called during logout to ensure no stale data persists
class CubitResetUtils {
  /// Reset all LazySingleton cubits to their initial state
  /// This ensures no user-specific data persists after logout
  static Future<void> resetAllCubits() async {
    // Reset NavigationCubit (LazySingleton)
    try {
      final navigationCubit = ServiceLocator.instance<NavigationCubit>();
      if (!navigationCubit.isClosed) {
        navigationCubit.reset();
      }
    } catch (e) {
      debugPrint('Error resetting NavigationCubit: $e');
    }

    // Reset ProviderNavigationCubit (LazySingleton) so the next provider that
    // signs in lands on the home tab instead of the previous session's tab.
    try {
      final providerNavigationCubit =
          ServiceLocator.instance<ProviderNavigationCubit>();
      if (!providerNavigationCubit.isClosed) {
        providerNavigationCubit.reset();
      }
    } catch (e) {
      debugPrint('Error resetting ProviderNavigationCubit: $e');
    }
  }
}
