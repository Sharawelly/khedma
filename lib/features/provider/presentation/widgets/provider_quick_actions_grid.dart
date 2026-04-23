import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/injection_container.dart';

class ProviderQuickActionsGrid extends StatelessWidget {
  const ProviderQuickActionsGrid({
    super.key,
    this.onPayouts,
    this.onHelp,
  });

  final VoidCallback? onPayouts;
  final VoidCallback? onHelp;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _ActionTile(
            icon: Icons.account_balance_wallet_outlined,
            labelKey: 'provider_quick_payouts',
            onTap: onPayouts,
          ),
        ),
        Gaps.hGap12,
        Expanded(
          child: _ActionTile(
            icon: Icons.headset_mic_outlined,
            labelKey: 'provider_quick_help',
            onTap: onHelp,
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.labelKey,
    this.onTap,
  });

  final IconData icon;
  final String labelKey;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.whiteColor,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsetsDirectional.symmetric(vertical: 20.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: colors.shadowCardLight,
                blurRadius: 6,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 28.r, color: colors.authBrandRed),
              Gaps.vGap8,
              Text(
                labelKey.tr,
                style: TextStyles.semiBold14(color: colors.onboardingTextStrong),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
