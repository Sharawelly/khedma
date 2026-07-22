import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/img_manager.dart';
import 'package:khedma/core/widgets/app_image.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/features/provider/profile/presentation/widgets/provider_profile_section_card.dart';

class ProviderProfilePortfolioSection extends StatelessWidget {
  const ProviderProfilePortfolioSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderProfileSectionCard(
      titleKey: 'provider_profile_portfolio'.tr,
      child: Row(
        children: <Widget>[
          Expanded(
            child: _PortfolioThumb(imageUrl: ImageAssets.bookingsServiceFaucet),
          ),
          Gaps.hGap8,
          Expanded(
            child: _PortfolioThumb(imageUrl: ImageAssets.bookingsLocationMap),
          ),
          Gaps.hGap8,
          Expanded(
            child: _PortfolioThumb(imageUrl: ImageAssets.homeProfileAvatarDemo),
          ),
        ],
      ),
    );
  }
}

class _PortfolioThumb extends StatelessWidget {
  const _PortfolioThumb({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: AppImage.network(
        imageUrl: imageUrl,
        height: 58.h,
        fit: BoxFit.cover,
        isCached: true,
      ),
    );
  }
}
