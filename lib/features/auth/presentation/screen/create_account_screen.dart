import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:khedma/features/auth/presentation/widgets/registration_progress_bar.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/app_text_form_field.dart';
import '/core/widgets/back_button.dart';
import '/core/widgets/my_default_button.dart';
import '../cubit/create_account_form_cubit/create_account_form_cubit.dart';

import '/injection_container.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key, this.registrationRole});

  /// Role chosen on [RoleSelectionScreen], if any.
  final String? registrationRole;

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _syncForm(CreateAccountFormCubit cubit) {
    cubit.onFormInputChanged(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  void _onContinue(CreateAccountFormState formState) {
    if (!_formKey.currentState!.validate()) return;
    if (formState.strength != PasswordStrength.strong) return;
    context.go(
      Routes.appShellRoute,
      extra: <String, Object?>{
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
        if (widget.registrationRole != null)
          'registration_role': widget.registrationRole!,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ServiceLocator.instance<CreateAccountFormCubit>(),
      child: Scaffold(
        backgroundColor: colors.whiteColor,
        body: SafeArea(
          child: BlocBuilder<CreateAccountFormCubit, CreateAccountFormState>(
            builder: (ctx, formState) {
              final cubit = ctx.read<CreateAccountFormCubit>();
              final bool isEnabled =
                  formState.formFieldsFilled &&
                  formState.strength == PasswordStrength.strong;
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 6.h),
                            _TopBar(onBack: () => context.pop()),
                            SizedBox(height: 44.h),
                            Text(
                              'createAccountTitle'.tr,
                              style: TextStyles.bold20(
                                color: colors.onboardingHeadline,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'createAccountSubtitle'.tr,
                              style: TextStyles.medium16(
                                color: colors.registerSubtitle,
                              ),
                            ),
                            SizedBox(height: 24.h),
                            _FieldLabel(label: 'createAccountFullName'.tr),
                            SizedBox(height: 8.h),
                            AppTextFormField(
                              controller: _nameController,
                              focusNode: _nameFocus,
                              hintText: 'createAccountNameHint'.tr,
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              radius: 14,
                              wrapWithElasticAnimation: false,
                              onChanged: (_) => _syncForm(cubit),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'createAccountNameRequired'.tr
                                  : null,
                              onSubmit: (_) => FocusScope.of(
                                context,
                              ).requestFocus(_emailFocus),
                            ),
                            SizedBox(height: 16.h),
                            _FieldLabel(label: 'createAccountEmail'.tr),
                            SizedBox(height: 8.h),
                            AppTextFormField(
                              controller: _emailController,
                              focusNode: _emailFocus,
                              hintText: 'createAccountEmailHint'.tr,
                              textCapitalization: TextCapitalization.none,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              radius: 14,
                              wrapWithElasticAnimation: false,
                              onChanged: (_) => _syncForm(cubit),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'createAccountEmailRequired'.tr;
                                }
                                final emailRegex = RegExp(
                                  r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                                );
                                if (!emailRegex.hasMatch(v.trim())) {
                                  return 'createAccountEmailInvalid'.tr;
                                }
                                return null;
                              },
                              onSubmit: (_) => FocusScope.of(
                                context,
                              ).requestFocus(_passwordFocus),
                            ),
                            SizedBox(height: 16.h),
                            _FieldLabel(label: 'createAccountPassword'.tr),
                            SizedBox(height: 8.h),
                            AppTextFormField(
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              hintText: 'createAccountPasswordHint'.tr,
                              textCapitalization: TextCapitalization.none,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                              obscureText: formState.obscurePassword,
                              radius: 14,
                              wrapWithElasticAnimation: false,
                              suffix: GestureDetector(
                                onTap: () => cubit.togglePasswordVisibility(),
                                child: Icon(
                                  formState.obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: colors.invitationInputBorder,
                                  size: 20.r,
                                ),
                              ),
                              onChanged: (_) => _syncForm(cubit),
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'createAccountPasswordRequired'.tr
                                  : null,
                              onSubmit: (_) => _onContinue(cubit.state),
                            ),
                            SizedBox(height: 16.h),

                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      child: MyDefaultButton(
                        btnText: 'createAccountContinue'.tr,
                        localeText: true,
                        onPressed: () =>
                            isEnabled ? _onContinue(formState) : null,
                        color: isEnabled
                            ? colors.main
                            : colors.disabledButtonBg,
                        textColor: isEnabled
                            ? colors.whiteColor
                            : colors.disabledButtonText,
                        borderColor: isEnabled
                            ? colors.main
                            : colors.disabledButtonBg,
                        borderRadius: 14,
                        height: 56,
                        textStyle: TextStyles.bold16(
                          color: isEnabled
                              ? colors.whiteColor
                              : colors.disabledButtonText,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
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
        const Expanded(child: RegistrationProgressBar(progress: 0.6)),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyles.medium14(color: colors.registerLabelText),
    );
  }
}
