import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/app_centered_header_bar.dart';
import '/core/widgets/gaps.dart';
import '/core/widgets/my_default_button.dart';
import '/features/client/home/presentation/cubit/choose_date_time_cubit.dart';
import '/features/client/home/presentation/widgets/home_booking_date_chip.dart';
import '/features/client/home/presentation/widgets/home_booking_mode_toggle.dart';
import '/features/client/home/presentation/widgets/home_booking_time_slots_section.dart';
import '/injection_container.dart';

class ChooseDateTimeScreen extends StatefulWidget {
  const ChooseDateTimeScreen({super.key});

  @override
  State<ChooseDateTimeScreen> createState() => _ChooseDateTimeScreenState();
}

class _ChooseDateTimeScreenState extends State<ChooseDateTimeScreen> {
  static const List<String> _weekdayKeys = <String>[
    'home_choose_date_time_weekday_mon',
    'home_choose_date_time_weekday_tue',
    'home_choose_date_time_weekday_wed',
    'home_choose_date_time_weekday_thu',
    'home_choose_date_time_weekday_fri',
  ];

  static const List<String> _dayKeys = <String>[
    'home_choose_date_time_day_12',
    'home_choose_date_time_day_13',
    'home_choose_date_time_day_14',
    'home_choose_date_time_day_15',
    'home_choose_date_time_day_16',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChooseDateTimeCubit>(
      create: (_) => ChooseDateTimeCubit(),
      child: BlocBuilder<ChooseDateTimeCubit, ChooseDateTimeState>(
        builder: (BuildContext context, ChooseDateTimeState state) {
          return Scaffold(
            bottomNavigationBar: SafeArea(
              minimum: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
              child: SizedBox(
                height: 52.h,
                child: MyDefaultButton(
                  btnText: 'home_choose_date_time_next',
                  onPressed: () => context.pushNamed(Routes.almostDoneRoute),
                  color: colors.errorColor,
                  borderColor: colors.errorColor,
                  borderRadius: 18,
                  height: 52,
                ),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  AppCenteredHeaderBar(
                    title: 'home_choose_date_time_title'.tr,
                    onBack: context.pop,
                    trailing: SizedBox(width: 48.w),
                    showBottomBorder: false,
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsetsDirectional.fromSTEB(
                        16.w,
                        8.h,
                        16.w,
                        96.h,
                      ),
                      children: <Widget>[
                        HomeBookingModeToggle(
                          isNowSelected: state.isNowSelected,
                          onNowTap: () => context
                              .read<ChooseDateTimeCubit>()
                              .selectNowMode(),
                          onScheduleTap: () => context
                              .read<ChooseDateTimeCubit>()
                              .selectScheduleMode(),
                        ),
                        Gaps.vGap24,
                        Row(
                          children: <Widget>[
                            Text(
                              'home_choose_date_time_select_date'.tr,
                              style: TextStyles.bold22(
                                color: colors.onboardingHeadline,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'home_choose_date_time_month_year'.tr,
                              style: TextStyles.bold22(
                                color: colors.errorColor,
                              ),
                            ),
                          ],
                        ),
                        Gaps.vGap12,
                        SizedBox(
                          height: 85.h,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _weekdayKeys.length,
                            separatorBuilder: (_, _) => Gaps.hGap10,
                            itemBuilder: (BuildContext context, int index) {
                              return HomeBookingDateChip(
                                weekdayLabel: _weekdayKeys[index].tr,
                                dayNumberLabel: _dayKeys[index].tr,
                                isSelected: state.selectedDateIndex == index,
                                onTap: () => context
                                    .read<ChooseDateTimeCubit>()
                                    .selectDate(index),
                              );
                            },
                          ),
                        ),
                        Gaps.vGap24,
                        Text(
                          'home_choose_date_time_available_time_slots'.tr,
                          style: TextStyles.bold22(
                            color: colors.onboardingHeadline,
                          ),
                        ),
                        Gaps.vGap16,
                        HomeBookingTimeSlotsSection(
                          title: 'home_choose_date_time_morning'.tr,
                          timeKeys: const <String>[
                            'home_choose_date_time_slot_0800_am',
                            'home_choose_date_time_slot_0900_am',
                            'home_choose_date_time_slot_1000_am',
                          ],
                          selectedTimeKey: state.selectedTimeKey,
                          onTimeSelected: (String value) => context
                              .read<ChooseDateTimeCubit>()
                              .selectTime(value),
                        ),
                        Gaps.vGap16,
                        HomeBookingTimeSlotsSection(
                          title: 'home_choose_date_time_afternoon'.tr,
                          timeKeys: const <String>[
                            'home_choose_date_time_slot_0100_pm',
                            'home_choose_date_time_slot_0200_pm',
                            'home_choose_date_time_slot_0330_pm',
                            'home_choose_date_time_slot_0400_pm',
                            'home_choose_date_time_slot_0500_pm',
                          ],
                          selectedTimeKey: state.selectedTimeKey,
                          onTimeSelected: (String value) => context
                              .read<ChooseDateTimeCubit>()
                              .selectTime(value),
                        ),
                        Gaps.vGap16,
                        HomeBookingTimeSlotsSection(
                          title: 'home_choose_date_time_evening'.tr,
                          timeKeys: const <String>[
                            'home_choose_date_time_slot_0700_pm',
                            'home_choose_date_time_slot_0830_pm',
                          ],
                          selectedTimeKey: state.selectedTimeKey,
                          onTimeSelected: (String value) => context
                              .read<ChooseDateTimeCubit>()
                              .selectTime(value),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
