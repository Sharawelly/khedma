import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/features/client/customer/domain/usecases/params/customer_params.dart';

class ChooseDateTimeScreen extends StatefulWidget {
  const ChooseDateTimeScreen({super.key, required this.draft});
  final BookingDraft draft;

  @override
  State<ChooseDateTimeScreen> createState() => _ChooseDateTimeScreenState();
}

class _ChooseDateTimeScreenState extends State<ChooseDateTimeScreen> {
  int bookingType = 0;
  DateTime? scheduledTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home_choose_date_time_title'.tr),
        leading: BackButton(onPressed: context.pop),
      ),
      body: Padding(
        padding: EdgeInsetsDirectional.all(20.r),
        child: Column(
          children: <Widget>[
            SegmentedButton<int>(
              segments: <ButtonSegment<int>>[
                ButtonSegment<int>(
                  value: 0,
                  label: Text('home_choose_date_time_now'.tr),
                ),
                ButtonSegment<int>(
                  value: 1,
                  label: Text('home_choose_date_time_schedule'.tr),
                ),
              ],
              selected: <int>{bookingType},
              onSelectionChanged: (values) {
                setState(() {
                  bookingType = values.first;
                  if (bookingType == 0) {
                    scheduledTime = null;
                  }
                });
              },
            ),
            SizedBox(height: 24.h),
            if (bookingType == 1)
              ListTile(
                leading: const Icon(Icons.event_rounded),
                title: Text(
                  scheduledTime?.toLocal().toString() ??
                      'home_choose_date_time_select_date'.tr,
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date == null || !context.mounted) {
                    return;
                  }
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() {
                      scheduledTime = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );
                    });
                  }
                },
              ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: EdgeInsets.all(16.r),
        child: FilledButton(
          onPressed: bookingType == 1 && scheduledTime == null
              ? null
              : () => context.pushNamed(
                  Routes.almostDoneRoute,
                  extra: widget.draft.copyWith(
                    bookingType: bookingType,
                    scheduledTime: scheduledTime,
                  ),
                ),
          child: Text('home_choose_date_time_next'.tr),
        ),
      ),
    );
  }
}
