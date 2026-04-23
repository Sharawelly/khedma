import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class ChatQuickRepliesRow extends StatelessWidget {
  const ChatQuickRepliesRow({super.key, required this.replyKeys});

  final List<String> replyKeys;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsetsDirectional.zero,
        itemCount: replyKeys.length,
        separatorBuilder: (_, _) => Gaps.hGap10,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            alignment: AlignmentDirectional.center,
            padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: colors.whiteColor,
              borderRadius: BorderRadius.circular(19.r),
              border: Border.all(color: colors.onboardingBorderNeutral),
            ),
            child: Text(
              replyKeys[index].tr,
              style: TextStyles.medium14(color: colors.lightTextColor),
            ),
          );
        },
      ),
    );
  }
}
