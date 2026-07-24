import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/core/params/auth_params.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/app_shimmer.dart';
import '/core/widgets/app_text_form_field.dart';
import '/core/widgets/gaps.dart';
import '/core/widgets/my_default_button.dart';
import '/injection_container.dart';
import '../auth_role_navigation.dart';
import '../cubit/login/login_cubit.dart';
import '../widgets/login_brand_header.dart';
import '../widgets/login_secure_footer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    context.read<LoginCubit>().login(
      LoginParams(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoaded) {
          final destination = AuthRoleNavigation.routeForRole(
            state.response.token!.role,
          );
          if (destination != null) {
            context.go(destination);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: colors.whiteColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Gaps.vGap24,
                    LoginBrandHeader(colors: colors),
                    Gaps.vGap24,
                    Text(
                      'authLoginTitle'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyles.bold28(
                        color: colors.onboardingHeadline,
                      ),
                    ),
                    Gaps.vGap8,
                    Text(
                      'authLoginSubtitle'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyles.medium16(color: colors.onboardingBody),
                    ),
                    Gaps.vGap32,
                    _FieldLabel(label: 'authEmailLabel'.tr),
                    Gaps.vGap8,
                    AppTextFormField(
                      controller: _emailController,
                      focusNode: _emailFocus,
                      hintText: 'authEmailHint'.tr,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      wrapWithElasticAnimation: false,
                      validator: _validateEmail,
                      onSubmit: (_) => _passwordFocus.requestFocus(),
                    ),
                    Gaps.vGap16,
                    _FieldLabel(label: 'authPasswordLabel'.tr),
                    Gaps.vGap8,
                    AppTextFormField(
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      hintText: 'authPasswordHint'.tr,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      wrapWithElasticAnimation: false,
                      validator: (value) => value == null || value.isEmpty
                          ? 'authPasswordRequired'.tr
                          : null,
                      suffix: GestureDetector(
                        onTap: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        child: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: colors.invitationInputBorder,
                        ),
                      ),
                      onSubmit: (_) => _submit(),
                    ),
                    if (state is LoginError) ...<Widget>[
                      Gaps.vGap12,
                      SelectableText.rich(
                        TextSpan(
                          text: state.message,
                          style: TextStyles.medium14(color: colors.errorColor),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    Gaps.vGap24,
                    if (state is LoginIsLoading)
                      AppShimmer(
                        child: Container(
                          height: 56.h,
                          decoration: BoxDecoration(
                            color: colors.whiteColor,
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                      )
                    else
                      MyDefaultButton(
                        btnText: 'authLoginAction'.tr,
                        localeText: true,
                        onPressed: _submit,
                        height: 56,
                        borderRadius: 14,
                        color: colors.main,
                        textColor: colors.whiteColor,
                        textStyle: TextStyles.bold16(color: colors.whiteColor),
                      ),
                    Gaps.vGap24,
                    LoginSecureFooter(colors: colors),
                    Gaps.vGap24,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
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
