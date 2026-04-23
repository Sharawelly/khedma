import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/injection_container.dart';

class AuthSignUpBrandHeader extends StatelessWidget {
  const AuthSignUpBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.home_repair_service_rounded,
            size: 28.r,
            color: colors.authBrandRed,
          ),
          Gaps.hGap8,
          Text(
            'home_brand_name'.tr,
            style: TextStyles.bold24(color: colors.authBrandRed),
          ),
        ],
      ),
    );
  }
}
