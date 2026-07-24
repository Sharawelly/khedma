import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/app_notification_bell_button.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/injection_container.dart';

class ProviderHomeHeader extends StatelessWidget {
  const ProviderHomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = sharedPreferences.getUser();
    final avatarUrl = profile?.profilePictureUrl;
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 24.r,
          backgroundImage: avatarUrl?.isNotEmpty == true
              ? NetworkImage(avatarUrl!)
              : null,
          child: avatarUrl?.isNotEmpty == true
              ? null
              : const Icon(Icons.person_rounded),
        ),
        Gaps.hGap12,
        Expanded(
          child: Text(
            '${'provider_welcome'.tr} ${profile?.fullName ?? ''}',
            style: TextStyles.bold18(color: colors.onboardingTextStrong),
          ),
        ),
        const AppNotificationBellButton(),
      ],
    );
  }
}
