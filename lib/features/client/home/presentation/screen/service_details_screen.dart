import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/cached_network_image_with_fallback.dart';
import '/core/widgets/gaps.dart';
import '/core/widgets/my_default_button.dart';
import '/features/client/home/presentation/widgets/category_service_card.dart';
import '/injection_container.dart';

class ServiceDetailsScreen extends StatelessWidget {
  const ServiceDetailsScreen({super.key, required this.item});

  final CategoryServiceItemData item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        minimum: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
        child: SizedBox(
          height: 50.h,
          child: MyDefaultButton(
            btnText: 'home_service_book_now',
            onPressed: () => context.pushNamed(Routes.confirmLocationRoute),
            color: colors.errorColor,
            borderColor: colors.errorColor,
            borderRadius: 18,
            height: 50.h,
            textStyle: TextStyles.bold22(color: colors.whiteColor),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsetsDirectional.only(bottom: 88.h),
        children: <Widget>[
          _DetailsImageHeader(item: item),
          Transform.translate(
            offset: Offset(0, -24.h),
            child: Container(
              padding: EdgeInsetsDirectional.fromSTEB(20.w, 20.h, 20.w, 0),
              decoration: BoxDecoration(
                color: colors.whiteColor,
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(24.r),
                  topEnd: Radius.circular(24.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        item.categoryTitleKey.tr,
                        style: TextStyles.medium14(color: colors.homeCaption),
                      ),
                      Gaps.hGap4,
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 18.r,
                        color: colors.homeCaption,
                      ),
                      Gaps.hGap4,
                      Expanded(
                        child: Text(
                          item.titleKey.tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.semiBold14(
                            color: colors.lightTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gaps.vGap4,
                  Text(
                    item.titleKey.tr,
                    style: TextStyles.bold32(color: colors.onboardingHeadline),
                  ),
                  Gaps.vGap12,
                  Row(
                    children: <Widget>[
                      _InfoChip(
                        icon: Icons.star_rounded,
                        iconColor: colors.secondary,
                        label: 'home_service_rating_label'.tr,
                      ),
                      Gaps.hGap8,
                      _InfoChip(
                        icon: Icons.access_time_filled_rounded,
                        iconColor: colors.homeCaption,
                        label: item.durationKey.tr,
                      ),
                    ],
                  ),
                  Gaps.vGap16,
                  Divider(color: colors.onboardingBorderNeutral),
                  Gaps.vGap16,
                  Text(
                    'home_service_about_title'.tr,
                    style: TextStyles.bold24(color: colors.onboardingHeadline),
                  ),
                  Gaps.vGap8,
                  Text(
                    'home_service_about_description'.tr,
                    style: TextStyles.medium16(
                      color: colors.lightTextColor,
                    ).copyWith(height: 1.5),
                  ),
                  Gaps.vGap20,
                  Text(
                    'home_service_whats_included_title'.tr,
                    style: TextStyles.bold24(color: colors.onboardingHeadline),
                  ),
                  Gaps.vGap12,
                  _IncludedItem(textKey: 'home_service_include_item_1'),
                  Gaps.vGap10,
                  _IncludedItem(textKey: 'home_service_include_item_2'),
                  Gaps.vGap10,
                  _IncludedItem(textKey: 'home_service_include_item_3'),
                  Gaps.vGap24,
                  Container(
                    padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: colors.onboardingSurfaceMuted,
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(color: colors.onboardingBorderNeutral),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on_rounded,
                          color: colors.errorColor,
                          size: 20.r,
                        ),
                        Gaps.hGap10,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'home_service_location_title'.tr,
                                style: TextStyles.bold14(
                                  color: colors.homeCaption,
                                ),
                              ),
                              Text(
                                'home_service_location_value'.tr,
                                style: TextStyles.bold20(
                                  color: colors.onboardingHeadline,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'home_service_location_change'.tr,
                          style: TextStyles.bold18(color: colors.errorColor),
                        ),
                      ],
                    ),
                  ),
                  Gaps.vGap24,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsImageHeader extends StatelessWidget {
  const _DetailsImageHeader({required this.item});

  final CategoryServiceItemData item;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CachedNetworkImageWithFallback(
          imageUrl: item.imageUrl,
          width: double.infinity,
          height: 320.h,
          fit: BoxFit.cover,
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 14.w,
              vertical: 8.h,
            ),
            child: Row(
              children: <Widget>[
                _CircleActionIcon(
                  icon: Icons.arrow_back_rounded,
                  onTap: context.pop,
                ),
                const Spacer(),
                _CircleActionIcon(icon: Icons.favorite_rounded, onTap: () {}),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CircleActionIcon extends StatelessWidget {
  const _CircleActionIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38.r,
        height: 38.r,
        decoration: BoxDecoration(
          color: colors.whiteColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20.r, color: colors.errorColor),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: colors.onboardingSurfaceMuted,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 15.r, color: iconColor),
          Gaps.hGap4,
          Text(
            label,
            style: TextStyles.semiBold14(color: colors.lightTextColor),
          ),
        ],
      ),
    );
  }
}

class _IncludedItem extends StatelessWidget {
  const _IncludedItem({required this.textKey});

  final String textKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(Icons.check_rounded, size: 20.r, color: colors.main),
        Gaps.hGap10,
        Expanded(
          child: Text(
            textKey.tr,
            style: TextStyles.medium16(color: colors.lightTextColor),
          ),
        ),
      ],
    );
  }
}
