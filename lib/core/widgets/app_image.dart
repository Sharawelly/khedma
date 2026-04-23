import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/core/utils/values/img_manager.dart';
import 'app_shimmer.dart';

class AppImage extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile;
  final String? imageAsset;
  final double? width;
  final double? height;
  final double? borderRadius;
  final BoxFit fit;
  final Color? color;
  final bool? isCached;
  final bool? isCircle;

  const AppImage({
    this.imageUrl,
    this.imageFile,
    this.imageAsset,
    this.borderRadius,
    this.width,
    this.height,
    this.fit = BoxFit.scaleDown,
    this.color,
    this.isCached = false,
    this.isCircle = false,
    super.key,
  });

  factory AppImage.network({
    String? imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.scaleDown,
    Color? color,
    bool? isCached,
    bool? isCircle,
  }) {
    return AppImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      color: color,
      isCached: isCached ?? false,
      isCircle: isCircle ?? false,
    );
  }

  factory AppImage.file({
    File? imageFile,
    double? width,
    double? height,
    BoxFit fit = BoxFit.scaleDown,
    Color? color,
    bool? isCircle,
  }) {
    return AppImage(
      imageFile: imageFile,
      width: width,
      height: height,
      fit: fit,
      color: color,
      isCircle: isCircle ?? false,
    );
  }

  factory AppImage.asset({
    String? imageAsset,
    double? width,
    double? height,
    BoxFit fit = BoxFit.scaleDown,
    Color? color,
    bool? isCircle,
  }) {
    return AppImage(
      imageAsset: imageAsset,
      width: width,
      height: height,
      fit: fit,
      color: color,
      isCircle: isCircle ?? false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        if (imageUrl != null && imageUrl!.isNotEmpty) {
          return _imageNetwork;
        }
        if (imageFile != null) {
          return _imageFile;
        }
        if (imageAsset != null && imageAsset!.isNotEmpty) {
          return _imageAsset;
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildBaseCircle(ImageProvider child) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(image: child, fit: fit),
      ),
    );
  }

  Image get _imageAssetItem {
    final assetPath = imageAsset ?? '';
    if (assetPath.isEmpty) {
      // Return a placeholder image instead of trying to load empty path
      return Image.asset(
        'assets/images/logo.png', // Fallback asset
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (BuildContext context, Object url, StackTrace? error) =>
            _errorWidget,
      );
    }
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (BuildContext context, Object url, StackTrace? error) =>
          _errorWidget,
    );
  }

  Widget get _imageAsset {
    if (isCircle == true) {
      return _buildBaseCircle(_imageAssetItem.image);
    }
    return _imageAssetItem;
  }

  Image get _imageFileItem => Image.file(
    imageFile!,
    width: width,
    height: height,
    fit: fit,
    errorBuilder: (BuildContext context, Object url, StackTrace? error) =>
        _errorWidget,
  );

  Widget get _imageFile {
    if (isCircle == true) {
      return _buildBaseCircle(_imageFileItem.image);
    }
    return _imageFileItem;
  }

  CachedNetworkImage get _imageNetworkItem {
    final url = imageUrl ?? '';
    // This should not be called if url is empty (handled in _imageNetwork)
    return CachedNetworkImage(
      imageUrl: url,
      color: color,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => _loadingWidget,
      errorWidget: (context, url, error) => _errorWidget,
    );
  }

  Widget get _imageNetwork {
    final url = imageUrl ?? '';
    if (url.isEmpty) {
      return _errorWidget;
    }

    if (isCached == true) {
      if (isCircle == true) {
        // Use ClipOval with CachedNetworkImage for proper error handling
        return ClipOval(
          child: CachedNetworkImage(
            imageUrl: url,
            width: width,
            height: height,
            fit: fit,
            placeholderFadeInDuration: const Duration(milliseconds: 500),
            placeholder: (BuildContext context, String url) => _loadingWidget,
            errorWidget: (BuildContext context, String url, dynamic error) =>
                _errorWidget,
          ),
        );
      }
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 6.r),
        child: CachedNetworkImage(
          imageUrl: url,
          color: color,
          width: width,
          height: height,
          fit: fit,
          placeholderFadeInDuration: const Duration(milliseconds: 500),
          placeholder: (BuildContext context, String url) => _loadingWidget,
          errorWidget: (BuildContext context, String url, dynamic error) =>
              _errorWidget,
        ),
      );
    }
    if (isCircle == true) {
      // Use ClipOval with CachedNetworkImage for proper error handling
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: url,
          width: width,
          height: height,
          fit: fit,
          placeholder: (BuildContext context, String url) => _loadingWidget,
          errorWidget: (BuildContext context, String url, dynamic error) =>
              _errorWidget,
        ),
      );
    }
    return _imageNetworkItem;
  }

  Widget get _loadingWidget => Center(
    child: AppShimmer(
      child: Container(
        width: width,
        height: height,
        color: Colors.grey.shade300,
      ),
    ),
  );

  Widget get _errorWidget => Center(
    child: Container(
      width: width,
      height: height,
      color: Colors.white,
      child: Image.asset(ImageAssets.logo),
    ),
  );
}
