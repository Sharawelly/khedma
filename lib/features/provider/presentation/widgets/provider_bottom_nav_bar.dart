import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/injection_container.dart';

enum ProviderNavItem { home, schedule, wallet, profile }

class ProviderBottomNavBar extends StatelessWidget {
  const ProviderBottomNavBar({
    super.key,
    required this.current,
    required this.onTap,
  });

  final ProviderNavItem current;
  final ValueChanged<ProviderNavItem> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 72.h,
      decoration: BoxDecoration(
        color: colors.whiteColor,
        border: Border(
          top: BorderSide(color: colors.onboardingBorderNeutral),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: _Item(
              icon: Icons.home_rounded,
              labelKey: 'provider_tab_home',
              item: ProviderNavItem.home,
              current: current,
              onTap: onTap,
            ),
          ),
          Expanded(
            child: _Item(
              icon: Icons.calendar_month_rounded,
              labelKey: 'provider_tab_schedule',
              item: ProviderNavItem.schedule,
              current: current,
              onTap: onTap,
            ),
          ),
          Expanded(
            child: _Item(
              icon: Icons.account_balance_wallet_outlined,
              labelKey: 'provider_tab_wallet',
              item: ProviderNavItem.wallet,
              current: current,
              onTap: onTap,
            ),
          ),
          Expanded(
            child: _Item(
              icon: Icons.person_outline_rounded,
              labelKey: 'provider_tab_profile',
              item: ProviderNavItem.profile,
              current: current,
              onTap: onTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.icon,
    required this.labelKey,
    required this.item,
    required this.current,
    required this.onTap,
  });

  final IconData icon;
  final String labelKey;
  final ProviderNavItem item;
  final ProviderNavItem current;
  final ValueChanged<ProviderNavItem> onTap;

  @override
  Widget build(BuildContext context) {
    final bool active = current == item;
    final Color itemColor =
        active ? colors.authBrandRed : colors.lightTextColor;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(item),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: itemColor, size: 22.r),
          Gaps.vGap4,
          Text(
            labelKey.tr,
            style: TextStyles.medium11(color: itemColor),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
