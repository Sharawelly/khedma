import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/cached_network_image_with_fallback.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class CategoryServiceCard extends StatelessWidget {
  const CategoryServiceCard({super.key, required this.item, required this.onTap});

  final CategoryServiceItemData item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 10.w,
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          color: colors.whiteColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: colors.onboardingBorderNeutral),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: colors.shadowCardLight,
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(18.r),
              child: CachedNetworkImageWithFallback(
                imageUrl: item.imageUrl,
                width: 92.r,
                height: 92.r,
                fit: BoxFit.cover,
              ),
            ),
            Gaps.hGap12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.titleKey.tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.bold20(color: colors.onboardingHeadline),
                  ),
                  Gaps.vGap2,
                  Text(
                    item.subtitleKey.tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.medium14(color: colors.lightTextColor),
                  ),
                  Gaps.vGap8,
                  Container(
                    padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: colors.onboardingBorderNeutral.withValues(
                        alpha: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.access_time_filled_rounded,
                          size: 13.r,
                          color: colors.homeCaption,
                        ),
                        Gaps.hGap4,
                        Text(
                          item.durationKey.tr,
                          style: TextStyles.semiBold12(
                            color: colors.lightTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Gaps.hGap8,
            Padding(
              padding: EdgeInsetsDirectional.only(top: 2.h),
              child: Icon(
                Icons.favorite_rounded,
                color: colors.errorColor,
                size: 21.r,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryServiceItemData {
  const CategoryServiceItemData({
    required this.categoryTitleKey,
    required this.titleKey,
    required this.subtitleKey,
    required this.durationKey,
    required this.imageUrl,
  });

  final String categoryTitleKey;
  final String titleKey;
  final String subtitleKey;
  final String durationKey;
  final String imageUrl;
}
