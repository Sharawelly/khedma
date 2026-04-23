import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class BookingsTabSelector extends StatelessWidget {
  const BookingsTabSelector({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  final BookingsTab selectedTab;
  final ValueChanged<BookingsTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: BookingsTab.values
            .map(
              (BookingsTab tab) => Padding(
                padding: EdgeInsetsDirectional.only(end: 20.w),
                child: _BookingsTabItem(
                  tab: tab,
                  isSelected: tab == selectedTab,
                  onTap: () => onTabSelected(tab),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _BookingsTabItem extends StatelessWidget {
  const _BookingsTabItem({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  final BookingsTab tab;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsetsDirectional.only(top: 6.h, bottom: 8.h),
        child: Column(
          children: <Widget>[
            Text(
              tab.titleKey.tr,
              style: isSelected
                  ? TextStyles.semiBold16(color: colors.onboardingHeadline)
                  : TextStyles.semiBold16(color: colors.homeCaption),
            ),
            Gaps.vGap8,
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 30.w,
              height: 2.2.h,
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.errorColor
                    : colors.errorColor.withValues(alpha: 0),
                borderRadius: BorderRadius.circular(999.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum BookingsTab {
  all('bookings_tab_all'),
  active('bookings_tab_active'),
  completed('bookings_tab_completed'),
  cancelled('bookings_tab_cancelled');

  const BookingsTab(this.titleKey);

  final String titleKey;
}
