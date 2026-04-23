import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/core/cubit/writing_field_cubit.dart';
import '/core/utils/values/text_styles.dart';
import '/injection_container.dart';

/// Reusable multi-line text area with a live character counter.
///
/// All state (char count, current text) is owned by a [WritingFieldCubit]
/// scoped to this widget — no [setState] used.
/// [onChanged] is forwarded to the caller on every keystroke.
class BlockWritingField extends StatelessWidget {
  const BlockWritingField({
    super.key,
    required this.hintText,
    this.maxChars = 500,
    this.minLines = 5,
    this.onChanged,
  });

  final String hintText;
  final int maxChars;
  final int minLines;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WritingFieldCubit>(
      create: (_) => WritingFieldCubit(),
      child: BlocBuilder<WritingFieldCubit, WritingFieldState>(
        buildWhen: (WritingFieldState prev, WritingFieldState curr) =>
            prev.charCount != curr.charCount,
        builder: (BuildContext context, WritingFieldState state) {
          return Container(
            decoration: BoxDecoration(
              color: colors.blocksStatSurface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: colors.blocksStatBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 4.h),
                  child: TextField(
                    maxLines: null,
                    minLines: minLines,
                    maxLength: maxChars,
                    buildCounter:
                        (
                          _, {
                          required currentLength,
                          required isFocused,
                          maxLength,
                        }) => null,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.newline,
                    style: TextStyles.regular14(
                      color: colors.onboardingHeadline,
                    ),
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyles.regular14(
                        color: colors.onboardingCaption,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (String value) {
                      context.read<WritingFieldCubit>().onChanged(value);
                      onChanged?.call(value);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 10.h),
                  child: Text(
                    '${state.charCount} / $maxChars',
                    textAlign: TextAlign.end,
                    style: TextStyles.regular12(
                      color: colors.onboardingCaption,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
