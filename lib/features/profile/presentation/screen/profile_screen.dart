import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/core/widgets/gaps.dart';
import '/features/profile/presentation/widgets/profile_header_section.dart';
import '/features/profile/presentation/widgets/profile_sign_out_button.dart';
import '/features/profile/presentation/widgets/profile_support_section.dart';
import '/features/profile/presentation/widgets/profile_top_providers_card.dart';
import '/features/profile/presentation/widgets/profile_account_settings_section.dart';
import '/injection_container.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      body: Column(
        children: <Widget>[
          const ProfileHeaderSection(),
          Expanded(
            child: ListView(
              padding: EdgeInsetsDirectional.only(
                start: 16.w,
                end: 16.w,
                top: 14.h,
                bottom: 18.h,
              ),
              children: <Widget>[
                const ProfileTopProvidersCard(),
                Gaps.vGap16,
                const ProfileAccountSettingsSection(),
                Gaps.vGap16,
                const ProfileSupportSection(),
                Gaps.vGap20,
                const ProfileSignOutButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
