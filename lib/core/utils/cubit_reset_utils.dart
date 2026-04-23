import 'package:flutter/foundation.dart';

import '/core/navigation/cubit/navigation_cubit.dart';

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
  }
}
