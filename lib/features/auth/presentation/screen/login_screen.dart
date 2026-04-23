import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/config/routes/app_routes.dart';
import 'package:khedma/core/utils/enums.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/core/widgets/my_default_button.dart';
import 'package:khedma/features/auth/presentation/cubit/auto_login/auto_login_cubit.dart';
import 'package:khedma/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:khedma/features/auth/presentation/widgets/login_brand_header.dart';
import 'package:khedma/features/auth/presentation/widgets/login_invitation_code_field.dart';
import 'package:khedma/features/auth/presentation/widgets/login_secure_footer.dart';
import 'package:khedma/injection_container.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _codeController;
  late final FocusNode _codeFocus;
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _codeController = TextEditingController();
    _codeFocus = FocusNode();
    _initializeUserState();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _codeFocus.dispose();
    super.dispose();
  }

  void _initializeUserState() {
    final autoLoginCubit = context.read<AutoLoginCubit>();
    autoLoginCubit.saveUserCycle(type: UserCycle.login);
    autoLoginCubit.saveUserType(type: UserType.pending);
    autoLoginCubit.getUserType();
  }

  Future<void> _onVerifyPressed() async {
    if (_formKey.currentState?.validate() ?? false) {
      // final deviceType = Platform.isAndroid ? 'android' : 'ios';
      // final deviceName = await Constants.getModel();
      // if (!mounted) return;
      // context.read<LoginCubit>().login(
      //   AuthParams(
      //     invitationCode: _codeController.text.trim().toUpperCase(),
      //     fcmDeviceToken: _fcmToken,
      //     deviceType: deviceType,
      //     deviceName: deviceName,
      //   ),
      // );
      context.push(Routes.languagePreferenceRoute);
    }
  }

  void _unFocus() {
    _codeFocus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unFocus,
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginLoaded) {
            context
                .read<AutoLoginCubit>()
                .saveUserCycle(type: UserCycle.auth)
                .then((_) {
                  if (context.mounted) {
                    context.push(Routes.languagePreferenceRoute);
                  }
                });
          }
        },
        child: Scaffold(
          backgroundColor: colors.whiteColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Gaps.vGap32,
                    LoginBrandHeader(colors: colors),
                    Gaps.vGap40,
                    Text(
                      'loginInvitationTitle'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyles.bold28(
                        color: colors.onboardingHeadline,
                      ),
                    ),
                    Gaps.vGap12,
                    Text(
                      'loginInvitationSubtitle'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyles.medium16(color: colors.onboardingBody),
                    ),
                    SizedBox(height: 36.h),
                    LoginInvitationCodeField(
                      controller: _codeController,
                      focusNode: _codeFocus,
                      onFieldSubmitted: _onVerifyPressed,
                    ),
                    // if (err != null && err.isNotEmpty) ...[
                    //   Gaps.vGap12,
                    //   SelectableText.rich(
                    //     TextSpan(
                    //       text: err,
                    //       style: TextStyles.medium14(
                    //         color: colors.errorColor,
                    //       ),
                    //     ),
                    //     textAlign: TextAlign.center,
                    //   ),
                    // ],
                    Gaps.vGap24,
                    // if (loading)
                    //   AppShimmer(
                    //     child: Container(
                    //       width: double.infinity,
                    //       height: 56.h,
                    //       decoration: BoxDecoration(
                    //         color: colors.whiteColor,
                    //         borderRadius: BorderRadius.circular(14.r),
                    //       ),
                    //     ),
                    //   )
                    // else
                    MyDefaultButton(
                      width: double.infinity,
                      height: 56,
                      borderRadius: 14,
                      btnText: 'loginVerifyCode',
                      color: colors.main,
                      textColor: colors.whiteColor,
                      borderColor: colors.main,
                      textStyle: TextStyles.bold16(color: colors.whiteColor),
                      onPressed: _onVerifyPressed,
                    ),
                    Gaps.vGap32,
                    LoginSecureFooter(colors: colors),
                    Gaps.vGap24,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
