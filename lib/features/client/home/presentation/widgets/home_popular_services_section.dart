import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/cached_network_image_with_fallback.dart';
import '/core/widgets/gaps.dart';
import '/features/client/home/presentation/widgets/category_service_card.dart';
import '/injection_container.dart';

class HomePopularServicesSection extends StatelessWidget {
  const HomePopularServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Text(
              'home_popular_services'.tr,
              style: TextStyles.bold24(color: colors.onboardingHeadline),
            ),
            const Spacer(),
            Text(
              'home_see_all'.tr,
              style: TextStyles.bold16(color: colors.errorColor),
            ),
          ],
        ),

        Gaps.vGap12,
        GridView.builder(
          itemCount: _cards.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 0.5,
          ),
          itemBuilder: (BuildContext context, int index) {
            return HomeServiceCard(item: _cards[index]);
          },
        ),
      ],
    );
  }
}

class HomeServiceCard extends StatelessWidget {
  const HomeServiceCard({super.key, required this.item});

  final HomeServiceCardData item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(
        Routes.serviceDetailsRoute,
        extra: CategoryServiceItemData(
          categoryTitleKey: item.categoryTitleKey,
          titleKey: item.titleKey,
          subtitleKey: item.subtitleKey,
          durationKey: item.durationKey,
          imageUrl: item.imageUrl,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colors.whiteColor,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(color: colors.homeCardBorder),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: colors.shadowCardLight,
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 110.h,
              child: ClipRRect(
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(22.r),
                  topEnd: Radius.circular(22.r),
                ),
                child: CachedNetworkImageWithFallback(
                  imageUrl: item.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: 10.w,
                  end: 10.w,
                  top: 8.h,
                  bottom: 8.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.star_rounded,
                          size: 14.r,
                          color: colors.secondary,
                        ),
                        Gaps.hGap2,
                        Text(
                          item.ratingLabel,
                          style: TextStyles.medium12(
                            color: colors.lightTextColor,
                          ),
                        ),
                      ],
                    ),
                    Gaps.vGap4,
                    Text(
                      item.titleKey.tr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.bold16(color: colors.onboardingHeadline),
                    ),
                    Gaps.vGap2,
                    Text(
                      item.subtitleKey.tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.medium10(color: colors.homeCaption),
                    ),
                    const Spacer(),
                    Row(
                      children: <Widget>[
                        const Spacer(),
                        Container(
                          width: 35.r,
                          height: 35.r,
                          decoration: BoxDecoration(
                            color: colors.errorColor.withValues(alpha: 0.22),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add,
                            size: 16.r,
                            color: colors.upBackGround,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeServiceCardData {
  const HomeServiceCardData({
    required this.categoryTitleKey,
    required this.titleKey,
    required this.subtitleKey,
    required this.durationKey,
    required this.ratingLabel,
    required this.imageUrl,
  });

  final String categoryTitleKey;
  final String titleKey;
  final String subtitleKey;
  final String durationKey;
  final String ratingLabel;
  final String imageUrl;
}

const List<HomeServiceCardData> _cards = <HomeServiceCardData>[
  HomeServiceCardData(
    categoryTitleKey: 'home_category_cleaning',
    titleKey: 'home_service_deep_house_cleaning',
    subtitleKey: 'home_service_category_home_cleaning',
    durationKey: 'home_duration_90_min',
    ratingLabel: '4.9 (120+)',
    imageUrl:
        'https://images.unsplash.com/photo-1581578731548-c64695cc6952?auto=format&fit=crop&w=600&q=80',
  ),
  HomeServiceCardData(
    categoryTitleKey: 'home_category_plumbing',
    titleKey: 'home_service_kitchen_sink_repair',
    subtitleKey: 'home_service_category_plumbing',
    durationKey: 'home_duration_45_min',
    ratingLabel: '4.8 (85)',
    imageUrl:
        'https://images.unsplash.com/photo-1621905251918-48416bd8575a?auto=format&fit=crop&w=600&q=80',
  ),
  HomeServiceCardData(
    categoryTitleKey: 'home_category_hvac',
    titleKey: 'home_service_ac_maintenance',
    subtitleKey: 'home_service_category_hvac',
    durationKey: 'home_duration_50_min',
    ratingLabel: '4.7 (200+)',
    imageUrl:
        'https://images.unsplash.com/photo-1486299267070-83823f5448dd?auto=format&fit=crop&w=600&q=80',
  ),
  HomeServiceCardData(
    categoryTitleKey: 'home_category_cleaning',
    titleKey: 'home_service_sofa_steam_cleaning',
    subtitleKey: 'home_service_category_home_cleaning',
    durationKey: 'home_duration_60_min',
    ratingLabel: '4.9 (50)',
    imageUrl:
        'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=600&q=80',
  ),
];
