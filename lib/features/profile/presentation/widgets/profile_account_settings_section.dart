import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class ProfileAccountSettingsSection extends StatelessWidget {
  const ProfileAccountSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileSettingsCard(
      titleKey: 'profile_account_settings',
      items: const <({String labelKey, IconData iconData})>[
        (labelKey: 'profile_my_addresses', iconData: Icons.location_on_rounded),
        (labelKey: 'profile_payment_methods', iconData: Icons.payments_rounded),
        (
          labelKey: 'profile_notifications',
          iconData: Icons.notifications_rounded,
        ),
        (labelKey: 'profile_change_password', iconData: Icons.lock_rounded),
      ],
    );
  }
}

class ProfileSettingsCard extends StatelessWidget {
  const ProfileSettingsCard({
    super.key,
    required this.titleKey,
    required this.items,
  });

  final String titleKey;
  final List<({String labelKey, IconData iconData})> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 14.w,
        vertical: 12.h,
      ),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.onboardingBorderNeutral),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            titleKey.tr,
            style: TextStyles.semiBold14(color: colors.homeCaption),
          ),
          Gaps.vGap8,
          ...items.asMap().entries.map((
            MapEntry<int, ({String labelKey, IconData iconData})> entry,
          ) {
            return _ProfileSettingsItem(
              labelKey: entry.value.labelKey,
              iconData: entry.value.iconData,
              showDivider: entry.key != items.length - 1,
            );
          }),
        ],
      ),
    );
  }
}

class _ProfileSettingsItem extends StatelessWidget {
  const _ProfileSettingsItem({
    required this.labelKey,
    required this.iconData,
    required this.showDivider,
  });

  final String labelKey;
  final IconData iconData;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(vertical: 10.h),
            child: Row(
              children: <Widget>[
                Container(
                  width: 34.r,
                  height: 34.r,
                  decoration: BoxDecoration(
                    color: colors.errorColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(iconData, color: colors.errorColor, size: 18.r),
                ),
                Gaps.hGap10,
                Expanded(
                  child: Text(
                    labelKey.tr,
                    style: TextStyles.semiBold16(
                      color: colors.onboardingHeadline,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22.r,
                  color: colors.lightTextColor,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(color: colors.onboardingBorderNeutral, height: 1.h),
      ],
    );
  }
}
