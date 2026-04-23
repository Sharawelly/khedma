import 'package:restart_app/restart_app.dart';

import '/config/locale/app_localizations.dart';

/// Service for restarting the Flutter app
/// Uses the restart_app package to restart the app using native APIs
class RestartAppService {
  /// Restarts the Flutter app
  /// 
  /// On iOS, the app will exit and send a local notification to the user.
  /// The user can then tap this notification to reopen the app.
  /// 
  /// On Android and Web, the app will restart normally.
  static Future<void> restartApp() async {
    await Restart.restartApp(
      // Customizing the restart notification message (only needed on iOS)
      notificationTitle: 'restarting_app'.tr,
      notificationBody: 'please_tap_to_reopen'.tr,
    );
  }
}
