import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/enums.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/back_button.dart';
import '/core/widgets/my_default_button.dart';
import '../cubit/language_preference_cubit/language_preference_cubit.dart';
import '../widgets/language_option_tile.dart';
import '../widgets/registration_progress_bar.dart';
import '/injection_container.dart';

class LanguagePreferenceScreen extends StatelessWidget {
  const LanguagePreferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LanguagePreferenceCubit>(
      create: (_) => ServiceLocator.instance<LanguagePreferenceCubit>(),
      child: const _LanguagePreferenceView(),
    );
  }
}

class _LanguagePreferenceView extends StatelessWidget {
  const _LanguagePreferenceView();

  Future<void> _onGetStarted(BuildContext context) async {
    await context.read<LanguagePreferenceCubit>().persistSelectedLanguage();
    if (!context.mounted) return;
    context.push(Routes.createAccountRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: BlocBuilder<LanguagePreferenceCubit, LanguagePreferenceState>(
            builder: (context, state) {
              return _LanguagePreferenceBody(
                state: state,
                onGetStarted: () => _onGetStarted(context),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LanguagePreferenceBody extends StatelessWidget {
  const _LanguagePreferenceBody({
    required this.state,
    required this.onGetStarted,
  });

  final LanguagePreferenceState state;
  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 6.h),
        _TopBar(onBack: () => context.pop()),
        SizedBox(height: 44.h),
        Text(
          'languagePreferenceTitle'.tr,
          style: TextStyles.bold20(color: colors.onboardingHeadline),
        ),
        SizedBox(height: 8.h),
        Text(
          'languagePreferenceSubtitle'.tr,
          style: TextStyles.medium16(color: colors.registerSubtitle),
        ),
        SizedBox(height: 24.h),
        _LanguageOptions(
          selectedLanguage: state.selected,
          onSelect: (LanguageCode lang) {
            context.read<LanguagePreferenceCubit>().selectLanguage(lang);
          },
        ),
        const Spacer(),
        MyDefaultButton(
          btnText: 'languageGetStarted'.tr,
          localeText: true,
          onPressed: onGetStarted,
          color: colors.main,
          textColor: colors.whiteColor,
          borderRadius: 14,
          height: 56,
          textStyle: TextStyles.bold16(color: colors.whiteColor),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomBackButton(onTap: onBack, iconColor: colors.onboardingHeadline),
        SizedBox(width: 14.w),
        const Expanded(child: RegistrationProgressBar(progress: 0.3)),
      ],
    );
  }
}

class _LanguageOptions extends StatelessWidget {
  const _LanguageOptions({
    required this.selectedLanguage,
    required this.onSelect,
  });

  final LanguageCode selectedLanguage;
  final ValueChanged<LanguageCode> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LanguageOptionTile(
          label: 'languageOptionArabic'.tr,
          selected: selectedLanguage == LanguageCode.ar,
          onTap: () => onSelect(LanguageCode.ar),
        ),
        SizedBox(height: 12.h),
        LanguageOptionTile(
          label: 'languageOptionEnglish'.tr,
          selected: selectedLanguage == LanguageCode.en,
          onTap: () => onSelect(LanguageCode.en),
        ),
      ],
    );
  }
}
