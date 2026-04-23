import 'package:flutter/material.dart';

import '/features/profile/presentation/widgets/profile_account_settings_section.dart';

class ProfileSupportSection extends StatelessWidget {
  const ProfileSupportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileSettingsCard(
      titleKey: 'profile_support',
      items: const <({String labelKey, IconData iconData})>[
        (labelKey: 'profile_help_support', iconData: Icons.help_rounded),
        (labelKey: 'profile_terms_privacy', iconData: Icons.verified_user_rounded),
      ],
    );
  }
}
