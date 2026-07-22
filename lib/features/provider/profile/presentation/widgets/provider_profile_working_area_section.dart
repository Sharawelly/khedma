import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/features/provider/profile/presentation/widgets/provider_profile_section_card.dart';
import 'package:khedma/injection_container.dart';

class ProviderProfileWorkingAreaSection extends StatelessWidget {
  const ProviderProfileWorkingAreaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderProfileSectionCard(
      titleKey: 'provider_working_area'.tr,
      child: Container(
        width: double.infinity,
        padding: EdgeInsetsDirectional.all(8.w),
        decoration: BoxDecoration(
          color: colors.backGround,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: colors.onboardingBorderNeutral),
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: 90.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.pathsInfoSurface,
                borderRadius: BorderRadius.circular(8.r),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.location_on_rounded,
                size: 34.r,
                color: colors.authBrandRed,
              ),
            ),
            Gaps.vGap8,
            Row(
              children: <Widget>[
                Icon(Icons.place_rounded, size: 16.r, color: colors.authBrandRed),
                Gaps.hGap4,
                Expanded(
                  child: Text(
                    'provider_working_area_value'.tr,
                    style: TextStyles.medium12(color: colors.onboardingHeadline),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
