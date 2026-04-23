import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/img_manager.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/app_image.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class ProfileTopProvidersCard extends StatelessWidget {
  const ProfileTopProvidersCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(14.r),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.onboardingBorderNeutral),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'profile_favorite_providers'.tr,
                  style: TextStyles.bold18(color: colors.onboardingHeadline),
                ),
              ),
              Text(
                'profile_view_all'.tr,
                style: TextStyles.bold14(color: colors.errorColor),
              ),
            ],
          ),
          Gaps.vGap10,
          Row(
            children: <Widget>[
              _ProviderAvatar(imageUrl: ImageAssets.profileProviderAvatar1),
              Gaps.hGap8,
              _ProviderAvatar(imageUrl: ImageAssets.profileProviderAvatar2),
              Gaps.hGap8,
              _ProviderAvatar(imageUrl: ImageAssets.profileProviderAvatar3),
              Gaps.hGap8,
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: colors.errorColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  'profile_more_providers'.tr,
                  style: TextStyles.bold14(color: colors.errorColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProviderAvatar extends StatelessWidget {
  const _ProviderAvatar({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: AppImage.network(
        imageUrl: imageUrl,
        width: 44.r,
        height: 44.r,
        fit: BoxFit.cover,
        isCircle: true,
        isCached: true,
      ),
    );
  }
}
