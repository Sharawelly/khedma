import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/core/widgets/my_default_button.dart';
import '/injection_container.dart';

class ApprovedMerchantCongratulationsDialog extends StatelessWidget {
  const ApprovedMerchantCongratulationsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: colors.whiteColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'congratulations'.tr,
              style: TextStyles.bold20(color: colors.main),
              textAlign: TextAlign.center,
            ),
            Gaps.vGap16,
            Text(
              'you_have_been_added_as_approved_merchant'.tr,
              style: TextStyles.bold20(color: colors.main),
              textAlign: TextAlign.center,
            ),
            Gaps.vGap32,
            MyDefaultButton(
              btnText: 'home',
              onPressed: () {
                Navigator.of(context).pop();
                // context.go(Routes.mainNavigationRoute);
              },
              color: colors.main,
              textColor: colors.whiteColor,
              borderColor: colors.main,
              textStyle: TextStyles.bold20(color: colors.whiteColor),
              borderRadius: 12.r,
              height: 55,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> show(BuildContext context) async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const ApprovedMerchantCongratulationsDialog();
      },
    );
  }
}
