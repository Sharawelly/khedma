import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/app_image.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class ProviderProfileReviewsSection extends StatelessWidget {
  const ProviderProfileReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(14.r),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.onboardingBorderNeutral),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'provider_profile_reviews_title'.tr,
                style: TextStyles.bold20(color: colors.onboardingHeadline),
              ),
              const Spacer(),
              Text(
                'provider_profile_rating_value'.tr,
                style: TextStyles.bold16(color: colors.review),
              ),
              Gaps.hGap2,
              Icon(Icons.star_rounded, size: 14.r, color: colors.review),
            ],
          ),
          Gaps.vGap12,
          const _ProviderReviewItem(
            nameKey: 'provider_profile_review_name_1',
            messageKey: 'provider_profile_review_message_1',
          ),
          Gaps.vGap8,
          const _ProviderReviewItem(
            nameKey: 'provider_profile_review_name_2',
            messageKey: 'provider_profile_review_message_2',
          ),
        ],
      ),
    );
  }
}

class _ProviderReviewItem extends StatelessWidget {
  const _ProviderReviewItem({required this.nameKey, required this.messageKey});

  final String nameKey;
  final String messageKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(10.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.onboardingBorderNeutral),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              ClipOval(
                child: AppImage.network(
                  imageUrl:
                      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=100&q=80',
                  width: 28.r,
                  height: 28.r,
                  fit: BoxFit.cover,
                  isCached: true,
                  isCircle: true,
                ),
              ),
              Gaps.hGap6,
              Expanded(
                child: Text(
                  nameKey.tr,
                  style: TextStyles.semiBold14(color: colors.onboardingHeadline),
                ),
              ),
              Row(
                children: List<Widget>.generate(
                  5,
                  (_) => Icon(Icons.star_rounded, size: 12.r, color: colors.review),
                ),
              ),
            ],
          ),
          Gaps.vGap8,
          Text(
            messageKey.tr,
            style: TextStyles.regular13(color: colors.lightTextColor).copyWith(height: 1.4),
          ),
        ],
      ),
    );
  }
}
