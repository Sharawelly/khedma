import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/core/widgets/filter_button.dart';
import '/core/widgets/form_reason_selector_shimmer.dart';

/// Reusable widget for selecting a reason from multiple options
/// Used in Contact Us, Report Trader, and similar forms
class FormReasonSelector extends StatelessWidget {
  final List<String> reasons;
  final String selectedReason;
  final Function(String) onReasonSelected;
  final bool isLoading;
  final bool hasLanguage;

  const FormReasonSelector({
    super.key,
    required this.reasons,
    required this.selectedReason,
    required this.onReasonSelected,
    this.isLoading = false,
    this.hasLanguage = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading || reasons.isEmpty) {
      return FormReasonSelectorShimmer(itemCount: reasons.isEmpty ? 4 : reasons.length);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(reasons.length, (index) {
          final reason = reasons[index];
          return Padding(
            padding: EdgeInsetsDirectional.only(
              end: index < reasons.length - 1 ? 10.w : 0,
            ),
            child: FilterButton(
              labelKey: reason,
              isActive: selectedReason == reason,
              onTap: () => onReasonSelected(reason),
              hasLanguage: hasLanguage,
            ),
          );
        }),
      ),
    );
  }
}
