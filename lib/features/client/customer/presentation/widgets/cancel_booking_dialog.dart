import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';

/// Asks for a cancellation reason. Returns the trimmed reason, or null when the
/// customer backed out.
Future<String?> showCancelBookingDialog(BuildContext context) =>
    showDialog<String>(
      context: context,
      builder: (_) => const CancelBookingDialog(),
    );

/// Dialogs own their controllers so disposal happens when the route is actually
/// removed. Disposing right after `showDialog` returns tears the controller down
/// while the exit animation is still rebuilding the live `TextField`.
class CancelBookingDialog extends StatefulWidget {
  const CancelBookingDialog({super.key});

  @override
  State<CancelBookingDialog> createState() => _CancelBookingDialogState();
}

class _CancelBookingDialogState extends State<CancelBookingDialog> {
  final TextEditingController _reason = TextEditingController();

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('customer_cancel_booking'.tr),
      content: TextField(
        controller: _reason,
        decoration: InputDecoration(hintText: 'customer_cancel_reason'.tr),
      ),
      actions: <Widget>[
        TextButton(onPressed: () => context.pop(), child: Text('cancel'.tr)),
        TextButton(
          onPressed: () => context.pop(_reason.text.trim()),
          child: Text('yes'.tr),
        ),
      ],
    );
  }
}
