import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/img_manager.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/app_image.dart';
import 'package:khedma/core/widgets/app_notification_bell_button.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/injection_container.dart';

class ProviderHomeHeader extends StatelessWidget {
  const ProviderHomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        AppImage.asset(
          imageAsset: ImageAssets.profileMainAvatar,
          width: 48.r,
          height: 48.r,
          isCircle: true,
          fit: BoxFit.cover,
        ),
        Gaps.hGap12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'provider_header_subtitle'.tr,
                style: TextStyles.regular12(color: colors.homeCaption),
              ),
              Gaps.vGap2,
              Text(
                'provider_greeting_line'.tr,
                style: TextStyles.bold18(color: colors.onboardingTextStrong),
              ),
            ],
          ),
        ),
        const AppNotificationBellButton(),
      ],
    );
  }
}
