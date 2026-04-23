import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/app_colors.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class HomeServiceCategoriesRow extends StatelessWidget {
  const HomeServiceCategoriesRow({super.key});

  static const List<_CategoryItemData> _categories = <_CategoryItemData>[
    _CategoryItemData(
      categoryKey: 'cleaning',
      labelKey: 'home_category_cleaning',
      icon: Icons.cleaning_services_outlined,
      color: MyColors.errorColor,
      isActive: true,
    ),
    _CategoryItemData(
      categoryKey: 'plumbing',
      labelKey: 'home_category_plumbing',
      icon: Icons.plumbing_outlined,
      color: MyColors.main,
    ),
    _CategoryItemData(
      categoryKey: 'electrical',
      labelKey: 'home_category_electrical',
      icon: Icons.electric_bolt_outlined,
      color: MyColors.secondary,
    ),
    _CategoryItemData(
      categoryKey: 'hvac',
      labelKey: 'home_category_hvac',
      icon: Icons.ac_unit_outlined,
      color: MyColors.phoneButtonColor,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (BuildContext context, int index) => Gaps.hGap8,
        itemBuilder: (_, int index) {
          final _CategoryItemData item = _categories[index];
          return HomeServiceCategoryItem(
            categoryKey: item.categoryKey,
            labelKey: item.labelKey,
            icon: item.icon,
            color: item.color,
            isActive: item.isActive,
          );
        },
      ),
    );
  }
}

class _CategoryItemData {
  const _CategoryItemData({
    required this.categoryKey,
    required this.labelKey,
    required this.icon,
    required this.color,
    this.isActive = false,
  });

  final String categoryKey;
  final String labelKey;
  final IconData icon;
  final Color color;
  final bool isActive;
}

class HomeServiceCategoryItem extends StatelessWidget {
  const HomeServiceCategoryItem({
    super.key,
    required this.categoryKey,
    required this.labelKey,
    required this.icon,
    required this.color,
    this.isActive = false,
  });

  final String categoryKey;
  final String labelKey;
  final IconData icon;
  final Color color;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(
        Routes.categoryServicesRoute,
        pathParameters: <String, String>{'categoryKey': categoryKey},
      ),
      child: SizedBox(
        width: 82.w,
        child: Column(
          children: <Widget>[
            Container(
              width: 65.r,
              height: 65.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.whiteColor,
                border: Border.all(color: color, width: isActive ? 1.6.w : 1.w),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: colors.shadowCardLight,
                    blurRadius: 8.r,
                    offset: Offset(0, 3.h),
                  ),
                ],
              ),
              child: Icon(icon, color: color, size: 28.r),
            ),
            Gaps.vGap8,
            Text(
              labelKey.tr,
              textAlign: TextAlign.center,
              style: TextStyles.medium14(color: colors.onboardingHeadline),
            ),
          ],
        ),
      ),
    );
  }
}
