import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/injection_container.dart';
import '../cubit/create_account_form_cubit/create_account_form_cubit.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({
    super.key,
    required this.strength,
    required this.hasMinLength,
    required this.hasUppercase,
    required this.hasNumber,
    required this.showMeter,
  });

  final PasswordStrength strength;
  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasNumber;
  final bool showMeter;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showMeter) ...[
          _StrengthMeterRow(strength: strength),
          SizedBox(height: 12.h),
        ],
        _CriterionRow(
          met: hasMinLength,
          label: 'pwdMinLength'.tr,
        ),
        SizedBox(height: 4.h),
        _CriterionRow(
          met: hasUppercase,
          label: 'pwdUppercase'.tr,
        ),
        SizedBox(height: 4.h),
        _CriterionRow(
          met: hasNumber,
          label: 'pwdNumber'.tr,
        ),
      ],
    );
  }
}

class _StrengthMeterRow extends StatelessWidget {
  const _StrengthMeterRow({required this.strength});

  final PasswordStrength strength;

  String get _label {
    switch (strength) {
      case PasswordStrength.fair:
        return 'pwdFair'.tr;
      case PasswordStrength.strong:
        return 'pwdStrong'.tr;
      default:
        return '';
    }
  }

  Color get _labelColor {
    switch (strength) {
      case PasswordStrength.fair:
        return colors.strengthFair;
      case PasswordStrength.strong:
        return colors.strengthStrong;
      default:
        return colors.strengthFair;
    }
  }

  int get _filledBars {
    switch (strength) {
      case PasswordStrength.weak:
        return 1;
      case PasswordStrength.fair:
        return 2;
      case PasswordStrength.strong:
        return 4;
      default:
        return 0;
    }
  }

  Color get _barColor {
    switch (strength) {
      case PasswordStrength.strong:
        return colors.main;
      case PasswordStrength.fair:
        return colors.main;
      default:
        return colors.main;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'pwdStrengthLabel'.tr,
              style: TextStyles.medium12(color: colors.onboardingBody),
            ),
            Text(
              _label,
              style: TextStyles.medium12(color: _labelColor),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Row(
          children: List.generate(4, (index) {
            final filled = index < _filledBars;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: index < 3 ? 4.w : 0),
                height: 4.h,
                decoration: BoxDecoration(
                  color: filled ? _barColor : colors.disabledButtonBg,
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _CriterionRow extends StatelessWidget {
  const _CriterionRow({required this.met, required this.label});

  final bool met;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 7.r,
          height: 7.r,
          decoration: BoxDecoration(
            color: met ? colors.main : colors.invitationInputBorder,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 9.w),
        Text(
          label,
          style: TextStyles.medium13(color: colors.onboardingBody),
        ),
      ],
    );
  }
}
