import 'package:flutter/material.dart';

import '/core/widgets/cached_network_image_with_fallback.dart';

/// Opens [images] full screen at [initialIndex], zoomable and swipeable.
Future<void> showImageViewer(
  BuildContext context, {
  required List<String> images,
  int initialIndex = 0,
}) {
  if (images.isEmpty) {
    return Future<void>.value();
  }
  return Navigator.of(context).push(
    PageRouteBuilder<void>(
      opaque: false,
      barrierColor: Colors.black,
      pageBuilder: (_, _, _) =>
          ImageViewer(images: images, initialIndex: initialIndex),
      transitionsBuilder: (_, animation, _, child) =>
          FadeTransition(opacity: animation, child: child),
    ),
  );
}

/// Full-screen image gallery: pinch or double-tap to zoom, drag to pan, swipe
/// between images.
class ImageViewer extends StatefulWidget {
  const ImageViewer({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  final List<String> images;
  final int initialIndex;

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer>
    with SingleTickerProviderStateMixin {
  static const double _zoomedInScale = 2.5;

  late final PageController _pages = PageController(
    initialPage: widget.initialIndex,
  );
  final TransformationController _transform = TransformationController();

  late AnimationController _zoomController;
  Animation<Matrix4>? _zoom;

  late int _index = widget.initialIndex;
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    _zoomController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 200),
        )..addListener(() {
          if (_zoom != null) {
            _transform.value = _zoom!.value;
          }
        });
    _transform.addListener(_trackZoom);
  }

  @override
  void dispose() {
    _transform
      ..removeListener(_trackZoom)
      ..dispose();
    _zoomController.dispose();
    _pages.dispose();
    super.dispose();
  }

  /// Page swiping is disabled while zoomed in, so a drag pans the image instead
  /// of jumping to the next one - otherwise the picture is unreadable the moment
  /// you try to move around it.
  void _trackZoom() {
    final zoomed = _transform.value.getMaxScaleOnAxis() > 1.01;
    if (zoomed != _isZoomed) {
      setState(() => _isZoomed = zoomed);
    }
  }

  void _animateTo(Matrix4 target) {
    _zoom = Matrix4Tween(begin: _transform.value, end: target).animate(
      CurvedAnimation(parent: _zoomController, curve: Curves.easeOutCubic),
    );
    _zoomController.forward(from: 0);
  }

  void _handleDoubleTap(TapDownDetails details) {
    if (_isZoomed) {
      _animateTo(Matrix4.identity());
      return;
    }
    // Zoom around the point that was tapped rather than the centre, so the
    // detail the user aimed at is what ends up on screen.
    final position = details.localPosition;
    _animateTo(
      Matrix4.identity()
        ..translateByDouble(
          -position.dx * (_zoomedInScale - 1),
          -position.dy * (_zoomedInScale - 1),
          0,
          1,
        )
        ..scaleByDouble(_zoomedInScale, _zoomedInScale, _zoomedInScale, 1),
    );
  }

  void _resetZoom() {
    _zoomController.stop();
    _transform.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          PageView.builder(
            controller: _pages,
            itemCount: widget.images.length,
            physics: _isZoomed
                ? const NeverScrollableScrollPhysics()
                : const PageScrollPhysics(),
            onPageChanged: (page) {
              // Each image starts unzoomed; carrying the previous transform over
              // would drop the next one in mid-pan somewhere off screen.
              _resetZoom();
              setState(() => _index = page);
            },
            itemBuilder: (_, page) => GestureDetector(
              onDoubleTapDown: _handleDoubleTap,
              // The handler lives on onDoubleTapDown because it needs the tap
              // position, which onDoubleTap does not carry.
              onDoubleTap: () {},
              child: InteractiveViewer(
                transformationController: page == _index ? _transform : null,
                minScale: 1,
                maxScale: 5,
                child: Center(
                  child: CachedNetworkImageWithFallback(
                    imageUrl: widget.images[page],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: Navigator.of(context).pop,
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
                if (widget.images.length > 1)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 16),
                    child: Text(
                      '${_index + 1} / ${widget.images.length}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
