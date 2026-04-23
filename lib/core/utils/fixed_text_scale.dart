import 'package:flutter/material.dart';

class FixedTextScale extends StatelessWidget {
  final Widget child;

  const FixedTextScale({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: child,
    );
  }
}
