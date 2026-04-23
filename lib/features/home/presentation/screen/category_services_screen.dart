import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/widgets/app_centered_header_bar.dart';
import '/core/widgets/gaps.dart';
import '/features/home/presentation/widgets/category_service_card.dart';
import '/injection_container.dart';

class CategoryServicesScreen extends StatelessWidget {
  const CategoryServicesScreen({super.key, required this.categoryKey});

  final String categoryKey;

  @override
  Widget build(BuildContext context) {
    final String titleKey = _titleKeyByCategory(categoryKey);
    final List<CategoryServiceItemData> items = _itemsByCategory(categoryKey);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            AppCenteredHeaderBar(
              title: titleKey.tr,
              onBack: context.pop,
              showBottomBorder: false,
              contentPadding: EdgeInsetsDirectional.only(
                start: 6.w,
                end: 14.w,
                top: 2.h,
                bottom: 8.h,
              ),
              trailing: Icon(
                Icons.search_rounded,
                size: 24.r,
                color: colors.errorColor,
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsetsDirectional.only(
                  start: 16.w,
                  end: 16.w,
                  top: 8.h,
                  bottom: 16.h,
                ),
                itemCount: items.length,
                separatorBuilder: (BuildContext context, int index) => Gaps.vGap12,
                itemBuilder: (BuildContext context, int index) {
                  return CategoryServiceCard(
                    item: items[index],
                    onTap: () => context.pushNamed(
                      Routes.serviceDetailsRoute,
                      extra: items[index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _titleKeyByCategory(String categoryKey) {
  switch (categoryKey) {
    case 'plumbing':
      return 'home_category_plumbing';
    case 'electrical':
      return 'home_category_electrical';
    case 'hvac':
      return 'home_category_hvac';
    case 'cleaning':
    default:
      return 'home_category_cleaning';
  }
}

List<CategoryServiceItemData> _itemsByCategory(String categoryKey) {
  switch (categoryKey) {
    case 'plumbing':
      return _plumbingItems;
    case 'electrical':
      return _electricalItems;
    case 'hvac':
      return _hvacItems;
    case 'cleaning':
    default:
      return _cleaningItems;
  }
}

const List<CategoryServiceItemData> _plumbingItems = <CategoryServiceItemData>[
  CategoryServiceItemData(
    categoryTitleKey: 'home_category_plumbing',
    titleKey: 'home_plumbing_service_sink_leak_title',
    subtitleKey: 'home_plumbing_service_sink_leak_subtitle',
    durationKey: 'home_duration_45_min',
    imageUrl:
        'https://images.unsplash.com/photo-1585704032915-c3400ca199e7?auto=format&fit=crop&w=600&q=80',
  ),
  CategoryServiceItemData(
    categoryTitleKey: 'home_category_plumbing',
    titleKey: 'home_plumbing_service_drain_unclogging_title',
    subtitleKey: 'home_plumbing_service_drain_unclogging_subtitle',
    durationKey: 'home_duration_60_min',
    imageUrl:
        'https://images.unsplash.com/photo-1626806787461-102c1bfaaea1?auto=format&fit=crop&w=600&q=80',
  ),
  CategoryServiceItemData(
    categoryTitleKey: 'home_category_plumbing',
    titleKey: 'home_plumbing_service_toilet_installation_title',
    subtitleKey: 'home_plumbing_service_toilet_installation_subtitle',
    durationKey: 'home_duration_90_min',
    imageUrl:
        'https://images.unsplash.com/photo-1620626011761-996317b8d101?auto=format&fit=crop&w=600&q=80',
  ),
  CategoryServiceItemData(
    categoryTitleKey: 'home_category_plumbing',
    titleKey: 'home_plumbing_service_heater_repair_title',
    subtitleKey: 'home_plumbing_service_heater_repair_subtitle',
    durationKey: 'home_duration_50_min',
    imageUrl:
        'https://images.unsplash.com/photo-1632935185103-6b0f0f6f8d09?auto=format&fit=crop&w=600&q=80',
  ),
];

const List<CategoryServiceItemData> _electricalItems = <CategoryServiceItemData>[
  CategoryServiceItemData(
    categoryTitleKey: 'home_category_electrical',
    titleKey: 'home_electrical_service_panel_fix_title',
    subtitleKey: 'home_electrical_service_panel_fix_subtitle',
    durationKey: 'home_duration_60_min',
    imageUrl:
        'https://images.unsplash.com/photo-1621905252507-b35492cc74b4?auto=format&fit=crop&w=600&q=80',
  ),
  CategoryServiceItemData(
    categoryTitleKey: 'home_category_electrical',
    titleKey: 'home_electrical_service_socket_replace_title',
    subtitleKey: 'home_electrical_service_socket_replace_subtitle',
    durationKey: 'home_duration_45_min',
    imageUrl:
        'https://images.unsplash.com/photo-1581092921461-eab10380d5df?auto=format&fit=crop&w=600&q=80',
  ),
];

const List<CategoryServiceItemData> _hvacItems = <CategoryServiceItemData>[
  CategoryServiceItemData(
    categoryTitleKey: 'home_category_hvac',
    titleKey: 'home_hvac_service_ac_maintenance_title',
    subtitleKey: 'home_hvac_service_ac_maintenance_subtitle',
    durationKey: 'home_duration_50_min',
    imageUrl:
        'https://images.unsplash.com/photo-1631545805717-43b0f6e3e0ff?auto=format&fit=crop&w=600&q=80',
  ),
  CategoryServiceItemData(
    categoryTitleKey: 'home_category_hvac',
    titleKey: 'home_hvac_service_filter_cleaning_title',
    subtitleKey: 'home_hvac_service_filter_cleaning_subtitle',
    durationKey: 'home_duration_45_min',
    imageUrl:
        'https://images.unsplash.com/photo-1581092795360-fd1ca04f0952?auto=format&fit=crop&w=600&q=80',
  ),
];

const List<CategoryServiceItemData> _cleaningItems = <CategoryServiceItemData>[
  CategoryServiceItemData(
    categoryTitleKey: 'home_category_cleaning',
    titleKey: 'home_cleaning_service_deep_cleaning_title',
    subtitleKey: 'home_cleaning_service_deep_cleaning_subtitle',
    durationKey: 'home_duration_90_min',
    imageUrl:
        'https://images.unsplash.com/photo-1581578731548-c64695cc6952?auto=format&fit=crop&w=600&q=80',
  ),
  CategoryServiceItemData(
    categoryTitleKey: 'home_category_cleaning',
    titleKey: 'home_cleaning_service_sofa_cleaning_title',
    subtitleKey: 'home_cleaning_service_sofa_cleaning_subtitle',
    durationKey: 'home_duration_60_min',
    imageUrl:
        'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=600&q=80',
  ),
];
