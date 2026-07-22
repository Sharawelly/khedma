import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/app_centered_header_bar.dart';
import 'package:khedma/features/provider/home/presentation/widgets/provider_request_details_sheet.dart';
import 'package:khedma/injection_container.dart';

class ProviderIncomingRequestScreen extends StatelessWidget {
  const ProviderIncomingRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Container(
          //   width: double.infinity,
          //   height: 360.h,
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       colors: <Color>[
          //         colors.backGround,
          //         colors.authSignUpBackgroundWash,
          //       ],
          //       begin: AlignmentDirectional.topCenter,
          //       end: AlignmentDirectional.bottomCenter,
          //     ),
          //   ),
          // ),
          PositionedDirectional(
            start: 16.w,
            end: 16.w,
            // top: MediaQuery.paddingOf(context).top + 8.h,
            child: AppCenteredHeaderBar(
              title: '',
              onBack: context.pop,
              showBottomBorder: false,
              backgroundColor: colors.whiteColor,
              titleStyle: TextStyles.bold16(color: colors.onboardingTextStrong),
            ),
          ),
          const Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: ProviderRequestDetailsSheet(),
          ),
        ],
      ),
    );
  }
}
