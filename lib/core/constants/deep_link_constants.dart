/// Constants for deep linking and share links.
/// Same domain for web and app. One URL works for both.
abstract class DeepLinkConstants {
  /// Base URL for share links. Same as website - one URL for app + web.
  /// App installed → opens in app. Not installed → opens in browser.
  static const String shareBaseUrl = 'https://world-apm.com';

  /// Custom URL scheme for direct app opening (apm://).
  /// Used as fallback when App Links / Universal Links are not verified.
  static const String customScheme = 'apm';

  /// Path template for product details. Use [productDetailsPath] for full path.
  static const String productPathTemplate = '/product-details';

  /// Full path for a product details deep link.
  static String productDetailsPath(int productId) => '$productPathTemplate/$productId';

  /// Full shareable URL for a product (https). Use for sharing to WhatsApp, etc.
  static String productShareUrl(int productId) =>
      '$shareBaseUrl${productDetailsPath(productId)}';

  /// Custom scheme URL for product (apm://product-details/123). Opens app directly.
  static String productCustomSchemeUrl(int productId) =>
      '$customScheme:${productDetailsPath(productId)}';
}
