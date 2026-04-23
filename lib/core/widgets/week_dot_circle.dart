import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Circular status dot (week progress, block history, etc.).
class WeekDotCircle extends StatelessWidget {
  const WeekDotCircle({
    super.key,
    required this.decoration,
    this.diameter,
    this.opacity = 1,
    required this.child,
  });

  final BoxDecoration decoration;
  final double? diameter;
  final double opacity;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double side = diameter ?? 32.r;
    return Opacity(
      opacity: opacity,
      child: Container(
        width: side,
        height: side,
        alignment: Alignment.center,
        decoration: decoration,
        child: child,
      ),
    );
  }
}
