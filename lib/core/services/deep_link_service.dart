import 'package:app_links/app_links.dart';

/// Handles incoming deep links and extracts the path for GoRouter.
/// Supports both https (App Links / Universal Links) and apm:// (custom scheme).
abstract class DeepLinkService {
  /// Returns the initial URI if the app was launched from a deep link.
  Future<Uri?> getInitialUri();

  /// Stream of incoming URIs when the app is opened from a link (e.g. from background).
  Stream<Uri> get uriLinkStream;
}

class DeepLinkServiceImpl implements DeepLinkService {
  DeepLinkServiceImpl() : _appLinks = AppLinks();

  final AppLinks _appLinks;

  @override
  Future<Uri?> getInitialUri() => _appLinks.getInitialLink();

  @override
  Stream<Uri> get uriLinkStream => _appLinks.uriLinkStream;
}

/// Extracts the GoRouter path from a deep link URI.
/// Returns the path if it matches a known route (e.g. /product-details/123), otherwise null.
/// Handles both https://api.world-apm.com/product-details/123 and apm://product-details/123.
String? extractPathFromDeepLinkUri(Uri? uri) {
  if (uri == null) return null;

  String path = uri.path;
  // apm://product-details/123 -> host=product-details, path=/123; construct /product-details/123
  if (uri.scheme == 'apm' && uri.host == 'product-details' && path.isNotEmpty) {
    path = '/product-details$path';
  }

  if (path.isEmpty) return null;

  // Match /product-details/:id - GoRouter route is /product-details/:id
  final productMatch = RegExp(r'^/product-details/(\d+)$').firstMatch(path);
  if (productMatch != null) return path;

  return null;
}
