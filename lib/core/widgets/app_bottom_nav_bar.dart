import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

enum BottomNavItem { home, bookings, chats, profile }

class AppBottomNavBar extends StatelessWidget {
  final BottomNavItem currentIndex;
  final Function(BottomNavItem) onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 75.h,
      decoration: BoxDecoration(
        color: colors.whiteColor,
        border: Border(
          top: BorderSide(color: colors.onboardingBorderNeutral),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: _buildNavItem(
              icon: Icons.home_rounded,
              label: 'home_tab_home'.tr,
              index: BottomNavItem.home,
            ),
          ),
          Expanded(
            child: _buildNavItem(
              icon: Icons.calendar_month_rounded,
              label: 'home_tab_bookings'.tr,
              index: BottomNavItem.bookings,
            ),
          ),
          Expanded(
            child: _buildNavItem(
              icon: Icons.chat_bubble_outline_rounded,
              label: 'home_tab_chats'.tr,
              index: BottomNavItem.chats,
            ),
          ),
          Expanded(
            child: _buildNavItem(
              icon: Icons.person_outline_rounded,
              label: 'home_tab_profile'.tr,
              index: BottomNavItem.profile,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required BottomNavItem index,
  }) {
    final bool isActive = currentIndex == index;
    final Color itemColor = isActive ? colors.errorColor : colors.lightTextColor;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, color: itemColor, size: 22.r),
          Gaps.vGap4,
          SizedBox(
            height: 22.h,
            child: Text(
              label,
              style: TextStyles.medium12(color: itemColor),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
