import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/my_default_button.dart';
import 'package:khedma/injection_container.dart';

class ProviderProfileSaveChangesButton extends StatelessWidget {
  const ProviderProfileSaveChangesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MyDefaultButton(
      btnText: 'provider_save_changes'.tr,
      localeText: true,
      onPressed: () {},
      height: 44.h,
      color: colors.authBrandRed,
      borderColor: colors.authBrandRed,
      borderRadius: 10.r,
      textStyle: TextStyles.semiBold16(color: colors.whiteColor),
      icon: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.lock_rounded, color: colors.whiteColor, size: 16.r),
          SizedBox(width: 6.w),
          Text(
            'provider_save_changes'.tr,
            style: TextStyles.semiBold16(color: colors.whiteColor),
          ),
        ],
      ),
    );
  }
}
