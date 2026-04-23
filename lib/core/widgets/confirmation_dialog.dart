import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/core/widgets/my_default_button.dart';
import '/injection_container.dart';

/// Global Success Dialog
///
/// Usage:
/// ```dart
/// await showSuccessDialog(
///   context: context,
///   title: 'success'.tr,
///   message: 'operation_successful'.tr,
/// );
/// ```
Future<void> showSuccessDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? buttonText,
  Color? buttonColor,
  bool isDismissible = true,
}) async {
  return await showDialog<void>(
    context: context,
    barrierDismissible: isDismissible,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: colors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                title,
                style: TextStyles.bold20(color: colors.textColor),
                textAlign: TextAlign.center,
              ),
              Gaps.vGap16,
              // Message
              Text(
                message,
                style: TextStyles.bold20(color: colors.main),
                textAlign: TextAlign.center,
              ),
              Gaps.vGap50,
              // OK Button
              MyDefaultButton(
                btnText: buttonText ?? 'back_to_home',
                color: colors.whiteColor,

                borderRadius: 20,
                textStyle: TextStyles.bold16(color: colors.main),
                height: 48.h,
                width: double.infinity,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Global Confirmation Dialog
///
/// Usage:
/// ```dart
/// final result = await showConfirmationDialog(
///   context: context,
///   title: 'confirm_delete'.tr,
///   message: 'confirm_delete_message'.tr,
///   confirmText: 'yes'.tr,
///   cancelText: 'no'.tr,
/// );
/// if (result == true) {
///   // User confirmed
/// }
/// ```
Future<bool?> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? confirmText,
  String? cancelText,
  Color? confirmColor,
  Color? cancelColor,
  bool isDismissible = true,
}) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: isDismissible,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: colors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                title,
                style: TextStyles.bold20(color: colors.main),
                textAlign: TextAlign.center,
              ),
              Gaps.vGap16,
              // Message
              Text(
                message,
                style: TextStyles.regular16(color: colors.textColor),
                textAlign: TextAlign.center,
              ),
              Gaps.vGap24,
              // Buttons
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: MyDefaultButton(
                      btnText: cancelText ?? 'no_cancel',
                      color: cancelColor ?? colors.whiteColor,
                      textColor: colors.main,
                      borderColor: colors.main,
                      borderRadius: 12,
                      height: 48.h,
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ),
                  Gaps.hGap10,
                  // Confirm Button
                  Expanded(
                    child: MyDefaultButton(
                      btnText: confirmText ?? 'yes_participate',
                      color: confirmColor ?? colors.main,
                      textColor: colors.whiteColor,
                      borderRadius: 12,
                      borderColor: confirmColor ?? colors.main,
                      height: 48.h,
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Global Warning Dialog
///
/// Usage:
/// ```dart
/// await showWarningDialog(
///   context: context,
///   title: 'important_warning'.tr,
///   message: 'incorrect_price_warning_message'.tr,
/// );
/// ```
Future<void> showWarningDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? buttonText,
  bool isDismissible = true,
}) async {
  return await showDialog<void>(
    context: context,
    barrierDismissible: isDismissible,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: colors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Warning Icon
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.errorColor.withValues(alpha: 0.1),
                  border: Border.all(color: colors.errorColor, width: 2.w),
                ),
                child: Icon(
                  Icons.warning,
                  color: colors.errorColor,
                  size: 32.sp,
                ),
              ),
              Gaps.vGap24,
              // Title
              Text(
                title,
                style: TextStyles.bold20(color: colors.errorColor),
                textAlign: TextAlign.center,
              ),
              Gaps.vGap16,
              // Message
              Text(
                message,
                style: TextStyles.regular16(color: colors.textColor),
                textAlign: TextAlign.center,
              ),
              Gaps.vGap32,
              // OK Button
              MyDefaultButton(
                btnText: buttonText ?? 'ok_i_understand',
                color: colors.errorColor,
                textColor: colors.whiteColor,
                borderColor: colors.errorColor,

                borderRadius: 12,
                height: 48.h,
                width: double.infinity,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      );
    },
  );
}
