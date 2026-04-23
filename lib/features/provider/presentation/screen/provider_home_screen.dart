import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/features/provider/presentation/widgets/provider_availability_earnings_card.dart';
import 'package:khedma/features/provider/presentation/widgets/provider_home_header.dart';
import 'package:khedma/features/provider/presentation/widgets/provider_incoming_request_card.dart';
import 'package:khedma/features/provider/presentation/widgets/provider_quick_actions_grid.dart';
import 'package:khedma/features/provider/presentation/widgets/provider_todays_jobs_section.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/injection_container.dart';

class ProviderHomeScreen extends StatefulWidget {
  const ProviderHomeScreen({super.key});

  @override
  State<ProviderHomeScreen> createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
  bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const ProviderHomeHeader(),
          Gaps.vGap20,
          ProviderAvailabilityEarningsCard(
            isOnline: _isOnline,
            onChanged: (bool v) {
              setState(() {
                _isOnline = v;
              });
            },
          ),
          Gaps.vGap24,
          Text(
            'provider_incoming_section'.tr,
            style: TextStyles.bold16(color: colors.onboardingTextStrong),
          ),
          Gaps.vGap12,
          const ProviderIncomingRequestCard(),
          Gaps.vGap24,
          const ProviderTodaysJobsSection(),
          Gaps.vGap20,
          const ProviderQuickActionsGrid(),
          Gaps.vGap24,
        ],
      ),
    );
  }
}
