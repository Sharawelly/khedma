import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/routes/app_routes.dart';
import '/injection_container.dart';

class AppSettingsButton extends StatelessWidget {
  const AppSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.all(8.r),
      onPressed: () => context.push(Routes.settingsRoute),
      icon: Icon(
        Icons.settings_rounded,
        size: 20.r,
        color: colors.onboardingHeadline,
      ),
    );
  }
}

