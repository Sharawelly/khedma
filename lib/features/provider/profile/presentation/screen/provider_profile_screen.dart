import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/features/provider/profile/presentation/widgets/provider_profile_certificates_section.dart';
import 'package:khedma/features/provider/profile/presentation/widgets/provider_profile_header_card.dart';
import 'package:khedma/features/provider/profile/presentation/widgets/provider_profile_hourly_rate_section.dart';
import 'package:khedma/features/provider/profile/presentation/widgets/provider_profile_personal_info_section.dart';
import 'package:khedma/features/provider/profile/presentation/widgets/provider_profile_portfolio_section.dart';
import 'package:khedma/features/provider/profile/presentation/widgets/provider_profile_save_changes_button.dart';
import 'package:khedma/features/provider/profile/presentation/widgets/provider_profile_services_section.dart';
import 'package:khedma/features/provider/profile/presentation/widgets/provider_profile_working_area_section.dart';
import 'package:khedma/injection_container.dart';

class ProviderProfileScreen extends StatelessWidget {
  const ProviderProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      body: Column(
        children: [
          const ProviderProfileHeaderCard(),
          Expanded(
            child: ListView(
              padding: EdgeInsetsDirectional.fromSTEB(10.w, 10.h, 10.w, 16.h),
              children: <Widget>[
                Gaps.vGap10,
                const ProviderProfilePersonalInfoSection(),
                Gaps.vGap10,
                const ProviderProfileHourlyRateSection(),
                Gaps.vGap10,
                const ProviderProfileServicesSection(),
                Gaps.vGap10,
                const ProviderProfilePortfolioSection(),
                Gaps.vGap10,
                const ProviderProfileCertificatesSection(),
                Gaps.vGap10,
                const ProviderProfileWorkingAreaSection(),
                Gaps.vGap16,
                const ProviderProfileSaveChangesButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
