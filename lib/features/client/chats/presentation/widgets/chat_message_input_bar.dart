import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class ChatMessageInputBar extends StatefulWidget {
  const ChatMessageInputBar({super.key});

  @override
  State<ChatMessageInputBar> createState() => _ChatMessageInputBarState();
}

class _ChatMessageInputBarState extends State<ChatMessageInputBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54.h,
      padding: EdgeInsetsDirectional.only(start: 14.w, end: 4.w),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(27.r),
        border: Border.all(color: colors.onboardingBorderNeutral),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.attach_file_rounded,
            color: colors.homeCaption,
            size: 22.r,
          ),
          Gaps.hGap8,
          Expanded(
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.send,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.text,
              style: TextStyles.medium16(color: colors.homeHeadline),
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                hintText: 'chat_input_hint'.tr,
                hintStyle: TextStyles.medium16(color: colors.homeCaption),
              ),
            ),
          ),
          Container(
            width: 45.r,
            height: 45.r,
            decoration: BoxDecoration(
              color: colors.errorColor,
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: colors.shadowCardMedium,
                  blurRadius: 7.r,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_forward_rounded,
              color: colors.whiteColor,
              size: 28.r,
            ),
          ),
        ],
      ),
    );
  }
}
