import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/core/params/auth_params.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/app_shimmer.dart';
import '/core/widgets/app_text_form_field.dart';
import '/core/widgets/back_button.dart';
import '/core/widgets/my_default_button.dart';
import '/injection_container.dart';
import '../auth_role_navigation.dart';
import '../cubit/create_account_form_cubit/create_account_form_cubit.dart';
import '../cubit/register_cubit/register_cubit.dart';
import '../widgets/password_strength_indicator.dart';
import '../widgets/registration_progress_bar.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key, this.registrationRole});

  final String? registrationRole;

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  final _serviceAreaController = TextEditingController();
  final _experienceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _jobTitleFocus = FocusNode();
  final _hourlyRateFocus = FocusNode();
  final _serviceAreaFocus = FocusNode();
  final _experienceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  bool _providerDetailsStep = false;

  bool get _isProvider => widget.registrationRole == 'Provider';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _jobTitleController.dispose();
    _hourlyRateController.dispose();
    _serviceAreaController.dispose();
    _experienceController.dispose();
    _descriptionController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    _jobTitleFocus.dispose();
    _hourlyRateFocus.dispose();
    _serviceAreaFocus.dispose();
    _experienceFocus.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  void _syncAccountForm(CreateAccountFormCubit cubit) {
    cubit.onFormInputChanged(
      name: _nameController.text,
      email: _emailController.text,
      phoneNumber: _phoneController.text,
      password: _passwordController.text,
    );
  }

  void _continueAccount(CreateAccountFormState formState) {
    if (!(_formKey.currentState?.validate() ?? false) ||
        formState.strength != PasswordStrength.strong) {
      return;
    }
    if (_isProvider) {
      setState(() => _providerDetailsStep = true);
      return;
    }
    _registerCustomer();
  }

  void _registerCustomer() {
    context.read<RegisterCubit>().register(
      RegisterCustomerParams(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  void _registerProvider() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    context.read<RegisterCubit>().register(
      RegisterProviderParams(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        password: _passwordController.text,
        jobTitle: _jobTitleController.text.trim(),
        hourlyRate: double.parse(_hourlyRateController.text.trim()),
        serviceArea: _serviceAreaController.text.trim(),
        experienceYears: int.parse(_experienceController.text.trim()),
        description: _descriptionController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ServiceLocator.instance<CreateAccountFormCubit>(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterLoaded) {
            final destination = AuthRoleNavigation.routeForRole(
              state.response.token!.role,
            );
            if (destination != null) {
              context.go(destination);
            }
          }
        },
        builder: (context, registerState) {
          return Scaffold(
            backgroundColor: colors.whiteColor,
            body: SafeArea(
              child:
                  BlocBuilder<CreateAccountFormCubit, CreateAccountFormState>(
                    builder: (context, formState) {
                      final formCubit = context.read<CreateAccountFormCubit>();
                      return Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: SingleChildScrollView(
                                padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: 20.w,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: 6.h),
                                    _TopBar(
                                      progress: _providerDetailsStep ? 1 : 0.6,
                                      onBack: _goBack,
                                    ),
                                    SizedBox(height: 36.h),
                                    Text(
                                      _providerDetailsStep
                                          ? 'providerRegisterTitle'.tr
                                          : 'createAccountTitle'.tr,
                                      style: TextStyles.bold20(
                                        color: colors.onboardingHeadline,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      _providerDetailsStep
                                          ? 'providerRegisterSubtitle'.tr
                                          : 'createAccountSubtitle'.tr,
                                      style: TextStyles.medium16(
                                        color: colors.registerSubtitle,
                                      ),
                                    ),
                                    SizedBox(height: 24.h),
                                    if (_providerDetailsStep)
                                      ..._providerFields()
                                    else
                                      ..._accountFields(formCubit, formState),
                                    if (registerState
                                        is RegisterError) ...<Widget>[
                                      SizedBox(height: 16.h),
                                      SelectableText.rich(
                                        TextSpan(
                                          text: registerState.message,
                                          style: TextStyles.medium14(
                                            color: colors.errorColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                    SizedBox(height: 24.h),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                20.w,
                                12.h,
                                20.w,
                                16.h,
                              ),
                              child: _submitButton(registerState, formState),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _accountFields(
    CreateAccountFormCubit cubit,
    CreateAccountFormState state,
  ) {
    return <Widget>[
      _FieldLabel(label: 'createAccountFullName'.tr),
      SizedBox(height: 8.h),
      AppTextFormField(
        controller: _nameController,
        focusNode: _nameFocus,
        hintText: 'createAccountNameHint'.tr,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        wrapWithElasticAnimation: false,
        onChanged: (_) => _syncAccountForm(cubit),
        validator: _requiredValidator('createAccountNameRequired'),
      ),
      SizedBox(height: 16.h),
      _FieldLabel(label: 'authEmailLabel'.tr),
      SizedBox(height: 8.h),
      AppTextFormField(
        controller: _emailController,
        focusNode: _emailFocus,
        hintText: 'authEmailHint'.tr,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        wrapWithElasticAnimation: false,
        onChanged: (_) => _syncAccountForm(cubit),
        validator: _validateEmail,
      ),
      SizedBox(height: 16.h),
      _FieldLabel(label: 'createAccountPhone'.tr),
      SizedBox(height: 8.h),
      AppTextFormField(
        controller: _phoneController,
        focusNode: _phoneFocus,
        hintText: 'createAccountPhoneHint'.tr,
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        wrapWithElasticAnimation: false,
        onChanged: (_) => _syncAccountForm(cubit),
        validator: _requiredValidator('createAccountPhoneRequired'),
      ),
      SizedBox(height: 16.h),
      _FieldLabel(label: 'authPasswordLabel'.tr),
      SizedBox(height: 8.h),
      AppTextFormField(
        controller: _passwordController,
        focusNode: _passwordFocus,
        hintText: 'authPasswordHint'.tr,
        obscureText: state.obscurePassword,
        wrapWithElasticAnimation: false,
        onChanged: (_) => _syncAccountForm(cubit),
        validator: _requiredValidator('authPasswordRequired'),
        suffix: GestureDetector(
          onTap: cubit.togglePasswordVisibility,
          child: Icon(
            state.obscurePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: colors.invitationInputBorder,
          ),
        ),
      ),
      SizedBox(height: 12.h),
      PasswordStrengthIndicator(
        strength: state.strength,
        hasMinLength: state.hasMinLength,
        hasUppercase: state.hasUppercase,
        hasNumber: state.hasNumber,
        showMeter: state.passwordNotEmpty,
      ),
    ];
  }

  List<Widget> _providerFields() {
    return <Widget>[
      _providerTextField(
        _ProviderFieldConfig(
          labelKey: 'providerRegisterJobTitle',
          hintKey: 'providerRegisterJobTitleHint',
          controller: _jobTitleController,
          focusNode: _jobTitleFocus,
        ),
      ),
      _providerTextField(
        _ProviderFieldConfig(
          labelKey: 'providerRegisterHourlyRate',
          hintKey: 'providerRegisterHourlyRateHint',
          controller: _hourlyRateController,
          focusNode: _hourlyRateFocus,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: _validatePositiveNumber,
        ),
      ),
      _providerTextField(
        _ProviderFieldConfig(
          labelKey: 'providerRegisterServiceArea',
          hintKey: 'providerRegisterServiceAreaHint',
          controller: _serviceAreaController,
          focusNode: _serviceAreaFocus,
        ),
      ),
      _providerTextField(
        _ProviderFieldConfig(
          labelKey: 'providerRegisterExperience',
          hintKey: 'providerRegisterExperienceHint',
          controller: _experienceController,
          focusNode: _experienceFocus,
          keyboardType: TextInputType.number,
          validator: _validateExperience,
        ),
      ),
      _providerTextField(
        _ProviderFieldConfig(
          labelKey: 'providerRegisterDescription',
          hintKey: 'providerRegisterDescriptionHint',
          controller: _descriptionController,
          focusNode: _descriptionFocus,
          maxLines: 4,
        ),
      ),
    ];
  }

  Widget _providerTextField(_ProviderFieldConfig config) {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _FieldLabel(label: config.labelKey.tr),
          SizedBox(height: 8.h),
          AppTextFormField(
            controller: config.controller,
            focusNode: config.focusNode,
            hintText: config.hintKey.tr,
            keyboardType: config.keyboardType,
            maxLines: config.maxLines,
            wrapWithElasticAnimation: false,
            validator:
                config.validator ??
                _requiredValidator('providerRegisterFieldRequired'),
          ),
        ],
      ),
    );
  }

  Widget _submitButton(
    RegisterState registerState,
    CreateAccountFormState formState,
  ) {
    if (registerState is RegisterIsLoading) {
      return AppShimmer(
        child: Container(
          height: 56.h,
          decoration: BoxDecoration(
            color: colors.whiteColor,
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
      );
    }
    final accountReady =
        formState.formFieldsFilled &&
        formState.strength == PasswordStrength.strong;
    final enabled = _providerDetailsStep || accountReady;
    return MyDefaultButton(
      btnText:
          (_providerDetailsStep
                  ? 'providerRegisterSubmit'
                  : 'createAccountContinue')
              .tr,
      localeText: true,
      onPressed: enabled
          ? (_providerDetailsStep
                ? _registerProvider
                : () => _continueAccount(formState))
          : () {},
      color: enabled ? colors.main : colors.disabledButtonBg,
      textColor: enabled ? colors.whiteColor : colors.disabledButtonText,
      borderColor: enabled ? colors.main : colors.disabledButtonBg,
      borderRadius: 14,
      height: 56,
      textStyle: TextStyles.bold16(
        color: enabled ? colors.whiteColor : colors.disabledButtonText,
      ),
    );
  }

  void _goBack() {
    if (_providerDetailsStep) {
      setState(() => _providerDetailsStep = false);
      return;
    }
    context.pop();
  }

  String? Function(String?) _requiredValidator(String key) {
    return (value) => value == null || value.trim().isEmpty ? key.tr : null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'authEmailRequired'.tr;
    }
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(email)) {
      return 'authEmailInvalid'.tr;
    }
    return null;
  }

  String? _validatePositiveNumber(String? value) {
    final parsed = double.tryParse(value?.trim() ?? '');
    return parsed == null || parsed <= 0
        ? 'providerRegisterNumberInvalid'.tr
        : null;
  }

  String? _validateExperience(String? value) {
    final parsed = int.tryParse(value?.trim() ?? '');
    return parsed == null || parsed < 0
        ? 'providerRegisterExperienceInvalid'.tr
        : null;
  }
}

class _TopBar extends StatelessWidget {
  final double progress;
  final VoidCallback onBack;

  const _TopBar({required this.progress, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CustomBackButton(onTap: onBack, iconColor: colors.onboardingHeadline),
        SizedBox(width: 14.w),
        Expanded(child: RegistrationProgressBar(progress: progress)),
      ],
    );
  }
}

class _ProviderFieldConfig {
  final String labelKey;
  final String hintKey;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;

  const _ProviderFieldConfig({
    required this.labelKey,
    required this.hintKey,
    required this.controller,
    required this.focusNode,
    this.keyboardType,
    this.validator,
    this.maxLines,
  });
}

class _FieldLabel extends StatelessWidget {
  final String label;

  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyles.medium14(color: colors.registerLabelText),
    );
  }
}
