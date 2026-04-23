import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/core/widgets/my_default_button.dart';
import '/injection_container.dart';

class ProviderProfileBottomActions extends StatelessWidget {
  const ProviderProfileBottomActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.only(
        start: 16.w,
        end: 16.w,
        top: 12.h,
        bottom: 22.h,
      ),
      // decoration: BoxDecoration(
      //   color: colors.whiteColor,
      //   border: Border(top: BorderSide(color: colors.optionBorder)),
      // ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: SizedBox(
              height: 48.h,
              child: OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colors.onboardingBorderNeutral),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                // icon: Icon(
                //   Icons.message_outlined,
                //   color: colors.onboardingHeadline,
                //   size: 18.r,
                // ),
                label: Text(
                  'provider_profile_message'.tr,
                  style: TextStyles.semiBold14(
                    color: colors.onboardingHeadline,
                  ),
                ),
              ),
            ),
          ),
          Gaps.hGap12,
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 48.h,
              child: MyDefaultButton(
                btnText: 'provider_profile_book_now',
                onPressed: () {},
                color: colors.errorColor,
                borderColor: colors.errorColor,
                borderRadius: 14,
                height: 48.h,
                textStyle: TextStyles.bold18(color: colors.whiteColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
