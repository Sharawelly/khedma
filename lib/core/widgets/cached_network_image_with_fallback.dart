import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/core/utils/values/img_manager.dart';
import '/core/widgets/app_shimmer.dart';
import '/injection_container.dart';

/// Cached network image with shimmer placeholder. On error or empty [imageUrl],
/// shows [fallbackSvgAsset] if set, otherwise [ImageAssets.logo].
class CachedNetworkImageWithFallback extends StatelessWidget {
  const CachedNetworkImageWithFallback({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.backgroundColor,
    this.placeholder,
    this.errorWidget,
    this.fallbackSvgAsset,
  });

  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? backgroundColor;
  final PlaceholderWidgetBuilder? placeholder;
  final LoadingErrorWidgetBuilder? errorWidget;

  /// When non-null, used instead of the logo for empty URL and load errors.
  final String? fallbackSvgAsset;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildFallbackImage();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      width: width,
      height: height,
      fit: fit,
      placeholder: placeholder ?? _buildPlaceholder,
      errorWidget: errorWidget ?? _buildErrorWidget,
    );
  }

  Widget _buildPlaceholder(BuildContext context, String url) {
    return AppShimmer(
      child: Container(
        width: width,
        height: height,
        color: colors.lightBackGroundColor,
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String url, dynamic error) {
    return _buildFallbackImage();
  }

  Widget _buildFallbackImage() {
    final String? svg = fallbackSvgAsset;
    return Container(
      width: width,
      height: height,
      color: backgroundColor ?? colors.upBackGround,
      alignment: Alignment.center,
      child: svg != null && svg.isNotEmpty
          ? SvgPicture.asset(
              svg,
              width: width,
              height: height,
              fit: BoxFit.contain,
            )
          : Image.asset(ImageAssets.logo, fit: BoxFit.contain),
    );
  }
}
