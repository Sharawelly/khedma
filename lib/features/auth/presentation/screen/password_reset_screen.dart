import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/values/text_styles.dart';
import '/injection_container.dart';
import '/core/widgets/app_snack_bar.dart' show ToastType, showAppSnackBar;
import '/core/widgets/gaps.dart';
import '/core/widgets/loading_view.dart';
import '/core/widgets/my_default_button.dart';
import '../../domain/usecases/params/forgot_password_params.dart';
import '../cubit/forgot_password_cubit/forgot_password_cubit.dart';
import '../widgets/auth_app_bar.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key, this.initialEmail});

  final String? initialEmail;

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      context.read<ForgotPasswordCubit>().forgotPassword(
        ForgotPasswordParams(email: email),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = appLocalizations.isArLocale;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: colors.whiteColor,
        appBar: AuthAppBar(
          showBackButton: true,
          text: 'forgot_password_text'.tr,
        ),
        body: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
          listener: (context, state) {
            if (state is ForgotPasswordSuccess) {
              if (context.mounted) {
                showAppSnackBar(
                  context: context,
                  message: state.message,
                  type: ToastType.success,
                );
                final email = _emailController.text.trim();
                context.push(
                  Routes.resetPasswordRoute,
                  extra: <String, dynamic>{'email': email},
                );
              }
            }
            if (state is ForgotPasswordError && context.mounted) {
              showAppSnackBar(
                context: context,
                message: state.message,
                type: ToastType.error,
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is ForgotPasswordLoading;

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
                        Text(
                          'enter_email_for_reset'.tr,
                          style: TextStyles.medium24(color: colors.main),
                        ),
                        Gaps.vGap20,
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          style: TextStyles.medium14(color: colors.textColor),
                          decoration: InputDecoration(
                            hintText: 'email'.tr,
                            hintStyle: TextStyles.regular14(
                              color: colors.lightTextColor,
                            ),
                            fillColor: colors.whiteColor,
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 16.h,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(color: colors.main),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: colors.main,
                                width: 1.5,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(color: colors.errorColor),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(color: colors.errorColor),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'error_field_required'.tr;
                            }
                            return null;
                          },
                        ),
                        Gaps.vGap40,
                        SizedBox(
                          width: double.infinity,
                          height: 80.h,
                          child: isLoading
                              ? LoadingView(bgColor: colors.main)
                              : MyDefaultButton(
                                  color: colors.main,
                                  borderColor: colors.main,
                                  onPressed: _submit,
                                  btnText: 'send_reset_link',
                                  textStyle: TextStyles.bold24Heavy(
                                    color: colors.whiteColor,
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
