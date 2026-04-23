import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/app_image.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class ProviderProfilePortfolioSection extends StatelessWidget {
  const ProviderProfilePortfolioSection({super.key, required this.imageUrls});

  final List<String> imageUrls;

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
          Text(
            'provider_profile_portfolio_title'.tr,
            style: TextStyles.bold20(color: colors.onboardingHeadline),
          ),
          Gaps.vGap10,
          SizedBox(
            height: 80.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: AppImage.network(
                    imageUrl: imageUrls[index],
                    width: 92.w,
                    height: 80.h,
                    fit: BoxFit.cover,
                    isCached: true,
                  ),
                );
              },
              separatorBuilder: (_, _) => Gaps.hGap8,
              itemCount: imageUrls.length,
            ),
          ),
        ],
      ),
    );
  }
}
