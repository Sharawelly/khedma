
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '/core/constants/deep_link_constants.dart';

/// Service for sharing product links.
/// Supports deep linking: when someone opens the shared link,
/// the app opens directly to the product details screen.
abstract class ShareProductService {
  /// Shares a product by ID and name. The shared content is formatted
  /// for optimal link detection and clickability.
  /// Uses [DeepLinkConstants.productShareUrl] for the shareable link.
  Future<void> shareProduct({
    required int productId,
    required String productName,
    BuildContext? context,
  });
}

class ShareProductServiceImpl implements ShareProductService {
  @override
  Future<void> shareProduct({
    required int productId,
    required String productName,
    BuildContext? context,
  }) async {
    final link = DeepLinkConstants.productShareUrl(productId);
    final text = 'Check out: $productName\n$link';

    final box = context?.findRenderObject() as RenderBox?;
    final sharePositionOrigin =
        box != null ? box.localToGlobal(Offset.zero) & box.size : null;

    await SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: productName,
        sharePositionOrigin: sharePositionOrigin,
      ),
    );
  }
}
