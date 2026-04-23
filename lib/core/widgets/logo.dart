import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../injection_container.dart';
import '../utils/values/assets.dart';

class Logo extends StatelessWidget {
  final double? radius;

  const Logo({
    super.key,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: AssetImage(
        appLocalizations.isEnLocale
            ? ImgAssets.imagesLogoEn
            : ImgAssets.imagesLogoAr,
      ),
      radius: radius ?? 40.r,
    );
  }
}
