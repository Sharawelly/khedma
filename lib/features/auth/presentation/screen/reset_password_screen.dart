import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/validator.dart';
import '/core/utils/values/app_colors.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/app_snack_bar.dart' show ToastType, showAppSnackBar;
import '/core/widgets/gaps.dart';
import '/core/widgets/loading_view.dart';
import '/core/widgets/my_default_button.dart';
import '../../domain/usecases/params/reset_password_params.dart';
import '../cubit/reset_password_cubit/reset_password_cubit.dart';
import '../widgets/auth_app_bar.dart';
import '../widgets/labeled_text_field.dart';
import '/injection_container.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, this.initialEmail});

  final String? initialEmail;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _tokenController;
  late final TextEditingController _passwordController;
  late final TextEditingController _passwordConfirmationController;
  late final FocusNode _emailFocus;
  late final FocusNode _tokenFocus;
  late final FocusNode _passwordFocus;
  late final FocusNode _passwordConfirmationFocus;
  bool _obscurePassword = true;
  bool _obscurePasswordConfirmation = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
    _tokenController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmationController = TextEditingController();
    _emailFocus = FocusNode();
    _tokenFocus = FocusNode();
    _passwordFocus = FocusNode();
    _passwordConfirmationFocus = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    _emailFocus.dispose();
    _tokenFocus.dispose();
    _passwordFocus.dispose();
    _passwordConfirmationFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      showAppSnackBar(
        context: context,
        message: 'there_is_required_field'.tr,
        type: ToastType.error,
      );
      return;
    }
    context.read<ResetPasswordCubit>().resetPassword(
      ResetPasswordParams(
        email: _emailController.text.trim(),
        token: _tokenController.text.trim(),
        password: _passwordController.text,
        passwordConfirmation: _passwordConfirmationController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = appLocalizations.isArLocale;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: MyColors.whiteColor,
        appBar: AuthAppBar(
          showBackButton: true,
          text: 'reset_password_title'.tr,
        ),
        body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
          listener: (context, state) {
            if (state is ResetPasswordSuccess) {
              if (context.mounted) {
                showAppSnackBar(
                  context: context,
                  message: state.message,
                  type: ToastType.success,
                );
                context.go(Routes.loginScreenRoute);
              }
            }
            if (state is ResetPasswordError && context.mounted) {
              showAppSnackBar(
                context: context,
                message: state.message,
                type: ToastType.error,
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is ResetPasswordLoading;

            return Form(
              key: _formKey,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: isArabic
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Gaps.vGap40,
                        LabeledTextField(
                          label: '${'email'.tr} *',
                          controller: _emailController,
                          focusNode: _emailFocus,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validatorType: ValidatorType.email,
                        ),
                        Gaps.vGap20,
                        LabeledTextField(
                          label: '${'reset_token'.tr} *',
                          controller: _tokenController,
                          focusNode: _tokenFocus,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validatorType: ValidatorType.standard,
                        ),
                        Gaps.vGap20,
                        LabeledTextField(
                          label: '${'password_field'.tr} *',
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.next,
                          validatorType: null,
                          obscureText: _obscurePassword,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'error_field_required'.tr;
                            }
                            if (value.trim().length < 8) {
                              return 'error_valid_password'.tr;
                            }
                            return null;
                          },
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: MyColors.lightTextColor,
                            ),
                            onPressed: () {
                              setState(
                                () => _obscurePassword = !_obscurePassword,
                              );
                            },
                          ),
                        ),
                        Gaps.vGap20,
                        LabeledTextField(
                          label: '${'confirm_password'.tr} *',
                          controller: _passwordConfirmationController,
                          focusNode: _passwordConfirmationFocus,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          obscureText: _obscurePasswordConfirmation,
                          validatorType: null,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'error_field_required'.tr;
                            }
                            if (value != _passwordController.text) {
                              return 'error_valid_password_confirm'.tr;
                            }
                            return null;
                          },
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePasswordConfirmation
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: MyColors.lightTextColor,
                            ),
                            onPressed: () {
                              setState(
                                () => _obscurePasswordConfirmation =
                                    !_obscurePasswordConfirmation,
                              );
                            },
                          ),
                        ),
                        Gaps.vGap40,
                        SizedBox(
                          width: double.infinity,
                          height: 80.h,
                          child: isLoading
                              ? LoadingView(bgColor: MyColors.main)
                              : MyDefaultButton(
                                  color: MyColors.main,
                                  borderColor: MyColors.main,
                                  onPressed: _submit,
                                  btnText: 'reset_password_btn',
                                  textStyle: TextStyles.bold24Heavy(
                                    color: MyColors.whiteColor,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
