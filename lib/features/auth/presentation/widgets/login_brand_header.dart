import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/app_colors.dart';
import 'package:khedma/core/utils/values/img_manager.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/app_image.dart';
import 'package:khedma/core/widgets/gaps.dart';

class LoginBrandHeader extends StatelessWidget {
  const LoginBrandHeader({super.key, required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final logoSize = 200.w;
    return Column(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(colors.main, BlendMode.srcIn),
          child: AppImage.asset(
            imageAsset: ImageAssets.logo,
            width: logoSize,
            height: logoSize,
            fit: BoxFit.contain,
          ),
        ),
        Gaps.vGap8,
        Text(
          'splashTitle'.tr,
          textAlign: TextAlign.center,
          style: TextStyles.bold28(color: colors.main),
        ),
        Gaps.vGap4,
        Text(
          'splashSubtitle'.tr,
          textAlign: TextAlign.center,
          style: TextStyles.medium14(color: colors.main),
        ),
      ],
    );
  }
}
