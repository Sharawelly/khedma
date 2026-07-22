import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/injection_container.dart';

class ProviderCustomerInfoRow extends StatelessWidget {
  const ProviderCustomerInfoRow({
    super.key,
    required this.customerNameKey,
    required this.customerNameStyle,
    this.avatarRadius = 20,
    this.showCallChip = false,
    this.showChatChip = false,
    this.showChatIconOnly = false,
    this.avatarBackgroundColor,
    this.avatarIconColor,
    this.avatarIconData = Icons.person_rounded,
  });

  final String customerNameKey;
  final TextStyle customerNameStyle;
  final double avatarRadius;
  final bool showCallChip;
  final bool showChatChip;
  final bool showChatIconOnly;
  final Color? avatarBackgroundColor;
  final Color? avatarIconColor;
  final IconData avatarIconData;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CircleAvatar(
          radius: avatarRadius.r,
          backgroundColor: avatarBackgroundColor ?? colors.mainAlpha20,
          child: Icon(
            avatarIconData,
            size: (avatarRadius + 4).r,
            color: avatarIconColor ?? colors.main,
          ),
        ),
        Gaps.hGap10,
        Expanded(
          child: Text(
            customerNameKey.tr,
            style: customerNameStyle,
          ),
        ),
        if (showCallChip) ...<Widget>[
          const _ActionChip(
            icon: Icons.call_outlined,
            labelKey: 'provider_job_details_call',
          ),
          Gaps.hGap8,
        ],
        if (showChatChip)
          const _ActionChip(
            icon: Icons.chat_bubble_outline_rounded,
            labelKey: 'provider_job_details_chat',
          ),
        if (showChatIconOnly)
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 22.r,
            color: colors.homeCaption,
          ),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.icon, required this.labelKey});

  final IconData icon;
  final String labelKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: colors.backGround,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: colors.onboardingBorderNeutral),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 16.r, color: colors.onboardingTextStrong),
          Gaps.hGap4,
          Text(
            labelKey.tr,
            style: TextStyles.medium16(color: colors.onboardingTextStrong),
          ),
        ],
      ),
    );
  }
}
