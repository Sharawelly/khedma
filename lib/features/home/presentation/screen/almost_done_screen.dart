import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/app_centered_header_bar.dart';
import '/core/widgets/app_text_form_field.dart';
import '/core/widgets/gaps.dart';
import '/core/widgets/my_default_button.dart';
import '/features/home/presentation/widgets/almost_done_booking_summary_card.dart';
import '/features/home/presentation/widgets/almost_done_photo_upload_card.dart';
import '/features/home/presentation/widgets/almost_done_price_breakdown_card.dart';
import '/injection_container.dart';

class AlmostDoneScreen extends StatefulWidget {
  const AlmostDoneScreen({super.key});

  @override
  State<AlmostDoneScreen> createState() => _AlmostDoneScreenState();
}

class _AlmostDoneScreenState extends State<AlmostDoneScreen> {
  final TextEditingController notesController = TextEditingController();
  final FocusNode notesFocusNode = FocusNode();

  @override
  void dispose() {
    notesController.dispose();
    notesFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        minimum: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
        child: SizedBox(
          height: 50.h,
          child: MyDefaultButton(
            btnText: 'home_almost_done_confirm_pay',
            onPressed: () => context.pushNamed(Routes.providerTrackingRoute),
            color: colors.errorColor,
            borderColor: colors.errorColor,
            borderRadius: 18,
            height: 50.h,
            textStyle: TextStyles.bold22(color: colors.whiteColor),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            AppCenteredHeaderBar(
              title: 'home_almost_done_title'.tr,
              onBack: context.pop,
              trailing: SizedBox(width: 48.w),
              showBottomBorder: false,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsetsDirectional.fromSTEB(16.w, 16.h, 16.w, 96.h),
                children: <Widget>[
                  const AlmostDoneBookingSummaryCard(),
                  Gaps.vGap24,
                  Text(
                    'home_almost_done_add_notes'.tr,
                    style: TextStyles.bold22(color: colors.lightTextColor),
                  ),
                  Gaps.vGap8,
                  AppTextFormField(
                    controller: notesController,
                    focusNode: notesFocusNode,
                    hintText: 'home_almost_done_notes_hint'.tr,
                    maxLines: 5,
                    minLines: 5,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    backgroundColor: colors.whiteColor,
                    borderColor: colors.onboardingBorderNeutral,
                    radius: 16,
                    enabledBorderWidth: 1,
                    focusedBorderWidth: 1,
                    wrapWithElasticAnimation: false,
                    contentPadding: EdgeInsetsDirectional.all(16.r),
                    hintTextStyle: TextStyles.medium16(
                      color: colors.homeCaption,
                    ),
                    textFieldStyle: TextStyles.medium16(
                      color: colors.onboardingHeadline,
                    ),
                  ),
                  Gaps.vGap20,
                  const AlmostDonePhotoUploadCard(),
                  Gaps.vGap20,
                  const AlmostDonePriceBreakdownCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
