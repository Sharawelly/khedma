import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/app_centered_header_bar.dart';
import '/core/widgets/gaps.dart';
import '/features/client/home/presentation/widgets/provider_tracking_provider_card.dart';
import '/injection_container.dart';

class ProviderTrackingScreen extends StatefulWidget {
  const ProviderTrackingScreen({super.key});

  @override
  State<ProviderTrackingScreen> createState() => _ProviderTrackingScreenState();
}

class _ProviderTrackingScreenState extends State<ProviderTrackingScreen> {
  Timer? _autoNavigateTimer;

  @override
  void initState() {
    super.initState();
    _autoNavigateTimer = Timer(const Duration(seconds: 5), () {
      if (!mounted) return;
      context.pushReplacementNamed(Routes.providerFoundRoute);
    });
  }

  @override
  void dispose() {
    _autoNavigateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            AppCenteredHeaderBar(
              title: 'home_provider_tracking_brand'.tr,
              onBack: context.pop,
              trailing: SizedBox(width: 48.w),
              showBottomBorder: false,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 20.h),
                children: <Widget>[
                  _TrackingHeroSection(),
                  Gaps.vGap16,
                  _TrackingStepper(),
                  Gaps.vGap24,
                  Gaps.vGap4,
                  const ProviderTrackingProviderCard(),
                  Gaps.vGap24,
                  Center(
                    child: Text(
                      'home_provider_tracking_cancel_request'.tr,
                      style: TextStyles.medium20(color: colors.homeCaption),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackingHeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 230.r,
          width: 230.r,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: 230.r,
                height: 230.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.errorColor.withValues(alpha: 0.06),
                ),
              ),
              Container(
                width: 170.r,
                height: 170.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.errorColor.withValues(alpha: 0.08),
                ),
              ),
              Container(
                width: 68.r,
                height: 68.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.errorColor,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: colors.errorColor.withValues(alpha: 0.25),
                      blurRadius: 14.r,
                      offset: Offset(0, 6.h),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.location_on_rounded,
                  size: 28.r,
                  color: colors.whiteColor,
                ),
              ),
            ],
          ),
        ),
        Gaps.vGap8,
        Text(
          'home_provider_tracking_title'.tr,
          style: TextStyles.bold30(color: colors.onboardingHeadline),
        ),
        Gaps.vGap2,
        Text(
          'home_provider_tracking_subtitle'.tr,
          style: TextStyles.bold14(color: colors.homeCaption),
        ),
      ],
    );
  }
}

class _TrackingStepper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const <Widget>[
        _TrackingStep(
          titleKey: 'home_provider_tracking_step_paid',
          isDone: true,
        ),
        _TrackingStep(
          titleKey: 'home_provider_tracking_step_searching',
          isDone: true,
        ),
        _TrackingStep(
          titleKey: 'home_provider_tracking_step_accepted',
          isActive: true,
        ),
        _TrackingStep(titleKey: 'home_provider_tracking_step_en_route'),
      ],
    );
  }
}

class _TrackingStep extends StatelessWidget {
  const _TrackingStep({
    required this.titleKey,
    this.isDone = false,
    this.isActive = false,
  });

  final String titleKey;
  final bool isDone;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final Color activeColor = isDone || isActive
        ? colors.errorColor
        : colors.onboardingBorderNeutral;
    final Color textColor = isActive
        ? colors.errorColor
        : isDone
        ? colors.main
        : colors.homeCaption;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              if (!isDone)
                Container(
                  width: 16.r,
                  height: 16.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? colors.whiteColor
                        : colors.onboardingBorderNeutral,
                    border: Border.all(color: activeColor, width: 2.w),
                  ),
                  alignment: Alignment.center,
                  child: isActive
                      ? Container(
                          width: 7.r,
                          height: 7.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors.errorColor,
                          ),
                        )
                      : null,
                )
              else
                Container(
                  width: 16.r,
                  height: 16.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.main,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.check,
                    size: 10.r,
                    color: colors.whiteColor,
                  ),
                ),
              Expanded(
                child: Container(
                  height: 1.h,
                  margin: EdgeInsetsDirectional.symmetric(horizontal: 4.w),
                  color: colors.onboardingBorderNeutral,
                ),
              ),
            ],
          ),
          Gaps.vGap6,
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
