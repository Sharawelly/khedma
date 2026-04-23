import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/app_centered_header_bar.dart';
import '/core/widgets/gaps.dart';
import '/core/widgets/my_default_button.dart';
import '/injection_container.dart';

class TrackLiveScreen extends StatelessWidget {
  const TrackLiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: colors.pathsInfoSurface.withValues(alpha: 0.35),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1577083552431-6e5fd01988f1?auto=format&fit=crop&w=900&q=80',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          PositionedDirectional(
            start: 16.w,
            end: 16.w,
            top: MediaQuery.paddingOf(context).top + 10.h,
            child: AppCenteredHeaderBar(
              title: 'home_track_live_header_title'.tr,
              titleStyle: TextStyles.bold16(color: colors.onboardingHeadline),
              onBack: context.pop,
              trailing: Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 10.w,
                  vertical: 6.h,
                ),

                decoration: BoxDecoration(
                  color: colors.mainAlpha20,
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  'home_track_live_eta_badge'.tr,
                  style: TextStyles.bold12(color: colors.main),
                ),
              ),
              showBottomBorder: false,
              backgroundColor: colors.whiteColor,
              contentPadding: EdgeInsetsDirectional.fromSTEB(
                4.w,
                6.h,
                8.w,
                6.h,
              ),
            ),
          ),
          PositionedDirectional(
            end: 16.w,
            top: 270.h,
            child: Column(
              children: <Widget>[
                _MapControlButton(icon: Icons.add_rounded),
                Gaps.vGap8,
                _MapControlButton(icon: Icons.remove_rounded),
                Gaps.vGap10,
                _MapControlButton(
                  icon: Icons.navigation_rounded,
                  iconColor: colors.errorColor,
                ),
              ],
            ),
          ),
          PositionedDirectional(
            start: 0,
            end: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsetsDirectional.fromSTEB(16.w, 16.h, 16.w, 20.h),
              decoration: BoxDecoration(
                color: colors.whiteColor,
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(24.r),
                  topEnd: Radius.circular(24.r),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: colors.shadowCardMedium,
                    blurRadius: 14.r,
                    offset: Offset(0, -4.h),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 44.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: colors.onboardingBorderNeutral,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),
                  Gaps.vGap12,
                  Gaps.vGap2,
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 27.r,
                        backgroundColor: colors.mainAlpha20,
                        child: Icon(
                          Icons.person_rounded,
                          color: colors.main,
                          size: 30.r,
                        ),
                      ),
                      Gaps.hGap12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'home_provider_tracking_provider_name'.tr,
                              style: TextStyles.bold16(
                                color: colors.onboardingHeadline,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.circle,
                                  size: 8.r,
                                  color: colors.main,
                                ),
                                Gaps.hGap6,
                                Text(
                                  'home_track_live_status'.tr,
                                  style: TextStyles.bold14(color: colors.main),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: colors.onboardingSurfaceMuted,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          'home_track_live_plate'.tr,
                          style: TextStyles.bold14(
                            color: colors.onboardingHeadline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gaps.vGap12,
                  const _TrackStatusTimeline(),
                  Gaps.vGap12,
                  Gaps.vGap2,
                  Divider(color: colors.onboardingBorderNeutral, height: 1.h),
                  Gaps.vGap12,
                  Gaps.vGap2,
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          height: 48.h,
                          child: MyDefaultButton(
                            onPressed: () {},
                            color: colors.whiteColor,
                            borderColor: colors.onboardingBorderNeutral,
                            borderRadius: 20,
                            height: 48,
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.call_rounded,
                                  size: 18.r,
                                  color: colors.onboardingHeadline,
                                ),
                                Gaps.hGap8,
                                Text(
                                  'home_track_live_call'.tr,
                                  style: TextStyles.bold18(
                                    color: colors.onboardingHeadline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Gaps.hGap12,
                      Expanded(
                        child: SizedBox(
                          height: 48.h,
                          child: MyDefaultButton(
                            btnText: 'home_provider_found_chat',
                            onPressed: () {},
                            color: colors.errorColor,
                            borderColor: colors.errorColor,
                            borderRadius: 20,
                            height: 48,
                            textStyle: TextStyles.bold22(
                              color: colors.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gaps.vGap12,
                  Gaps.vGap2,
                  Text(
                    'home_provider_tracking_cancel_request'.tr,
                    style: TextStyles.medium20(color: colors.homeCaption),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapControlButton extends StatelessWidget {
  const _MapControlButton({required this.icon, this.iconColor});

  final IconData icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42.r,
      height: 42.r,
      child: MyDefaultButton(
        onPressed: () {},
        color: colors.whiteColor,
        borderColor: colors.onboardingBorderNeutral,
        borderRadius: 999,
        height: 36.h,
        width: 42.w,
        horizontalPadding: 0,
        icon: Icon(
          icon,
          size: 22.r,
          color: iconColor ?? colors.onboardingHeadline,
        ),
      ),
    );
  }
}

class _TrackStatusStep extends StatelessWidget {
  const _TrackStatusStep({
    required this.titleKey,
    required this.iconData,
    this.isDone = false,
    this.isActive = false,
  });

  final String titleKey;
  final IconData iconData;
  final bool isDone;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final Color iconColor = isDone
        ? colors.main
        : isActive
        ? colors.errorColor
        : colors.homeCaption;
    final Color textColor = isDone
        ? colors.onboardingHeadline
        : isActive
        ? colors.errorColor
        : colors.homeCaption;

    return SizedBox(
      width: 75.w,
      child: Column(
        children: <Widget>[
          Icon(iconData, size: 18.r, color: iconColor),
          Gaps.vGap4,
          Text(
            titleKey.tr,
            style: TextStyles.medium12(color: textColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _TrackStatusTimeline extends StatelessWidget {
  const _TrackStatusTimeline();

  @override
  Widget build(BuildContext context) {
    final List<Widget> steps = <Widget>[
      const _TrackStatusStep(
        titleKey: 'home_provider_tracking_step_accepted',
        iconData: Icons.check_circle_rounded,
        isDone: true,
      ),
      const _TrackStatusStep(
        titleKey: 'home_provider_tracking_step_en_route',
        iconData: Icons.directions_car_filled_rounded,
        isActive: true,
      ),
      const _TrackStatusStep(
        titleKey: 'home_track_live_step_arrived',
        iconData: Icons.location_on_rounded,
      ),
      const _TrackStatusStep(
        titleKey: 'home_track_live_step_in_progress',
        iconData: Icons.build_rounded,
      ),
      const _TrackStatusStep(
        titleKey: 'home_track_live_step_job_completed',
        iconData: Icons.task_alt_rounded,
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List<Widget>.generate(steps.length * 2 - 1, (int index) {
          if (index.isEven) {
            return steps[index ~/ 2];
          }
          return Container(
            width: 15.w,
            height: 1.h,
            margin: EdgeInsetsDirectional.only(top: 9.h),
            color: colors.onboardingBorderNeutral,
          );
        }),
      ),
    );
  }
}
