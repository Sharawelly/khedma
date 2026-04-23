import 'package:flutter/material.dart';

import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';

class DateRow extends StatelessWidget {
  final String? date;
  const DateRow({super.key, this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/calander.png'),
        Gaps.hGap4,
        Text('\t${date ?? ''}', style: TextStyles.semiBold14()),
      ],
    );
  }
}

class TimeRow extends StatelessWidget {
  final String? time;
  const TimeRow({super.key, this.time});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/alarm.png'),
        Gaps.hGap4,
        Text('\t${time ?? ''}', style: TextStyles.semiBold14()),
      ],
    );
  }
}
