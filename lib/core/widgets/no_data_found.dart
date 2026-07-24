import 'package:animate_do/animate_do.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/injection_container.dart';

import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';

class NoDataFound extends StatelessWidget {
  final String? text;
  const NoDataFound({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return ElasticIn(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 120.r, color: colors.main),
            Gaps.vGap12,
            Text(
              text ?? 'noDataFound'.tr,
              style: TextStyles.semiBold22(color: colors.textColor),
            ),
          ],
        ),
      ),
    );
  }
}
