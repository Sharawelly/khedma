// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '/config/locale/app_localizations.dart';
// import '/config/routes/app_routes.dart';
// import '/core/params/auth_params.dart';
// import '/core/utils/constants.dart';
// import '/core/utils/values/text_styles.dart';
// import '/core/widgets/gaps.dart';
// import '/core/widgets/loading_view.dart';
// import '/core/widgets/my_default_button.dart';
// import '/features/auth/presentation/cubit/auto_login/auto_login_cubit.dart';
// import '/features/auth/presentation/cubit/verfiy_register_otp_cubit/verfiy_register_otp_cubit.dart';
// import '/features/auth/presentation/cubit/verify_login_otp_cubit/verify_login_otp_cubit.dart';
// import '/features/auth/presentation/widgets/auth_app_bar.dart';
// import '/features/auth/presentation/widgets/pin_widget.dart';
// import '/injection_container.dart';
// import '../../../../core/utils/enums.dart';

// class OtpAuthScreen extends StatefulWidget {
//   final AuthParams authParams;

//   const OtpAuthScreen({super.key, required this.authParams});

//   @override
//   State<OtpAuthScreen> createState() => _OtpAuthScreenState();
// }

// class _OtpAuthScreenState extends State<OtpAuthScreen>
//     with TickerProviderStateMixin {
//   final TextEditingController codeController = TextEditingController();
//   final FocusNode codeFocus = FocusNode();

//   late AnimationController timeController;

//   final Duration timeOut = const Duration(minutes: 2);

//   @override
//   void initState() {
//     super.initState();
//     timeController = AnimationController(vsync: this, duration: timeOut);
//     timeController.reverse(from: 1.0);
//   }

//   @override
//   void dispose() {
//     timeController.dispose();
//     codeController.dispose();
//     super.dispose();
//   }

//   String get timerString {
//     final duration = timeController.duration! * timeController.value;
//     final minutes = duration.inMinutes.toString().padLeft(2, '0');
//     final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
//     return "$minutes:$seconds";
//   }

//   void _onOtpSuccess() {
//     BlocProvider.of<AutoLoginCubit>(
//       context,
//     ).saveUserCycle(type: UserCycle.auth);
//     BlocProvider.of<AutoLoginCubit>(
//       context,
//     ).saveUserType(type: UserType.approved);
//     Navigator.pushNamedAndRemoveUntil(
//       context,
//       Routes.mainPageRoute,
//       (route) => false,
//     );
//   }

//   void _onOtpError(String message) {
//     Constants.showSnakToast(context: context, type: 3, message: message);
//   }

//   void _onConfirmPressed() {
//     final code = codeController.text;
//     if (code.length < 4) return;

//     if (widget.authParams.otpType == 'login') {
//       context.read<VerifyLoginOtpCubit>().verifyLoginOtp(
//         AuthParams(
//           otp: codeController.text,
//           passwordResetId: widget.authParams.passwordResetId,
//         ),
//       );
//     } else {
//       context.read<VerfiyRegisterOtpCubit>().verfiyRegisterOtp(
//         AuthParams(
//           otp: codeController.text,
//           passwordResetId: widget.authParams.passwordResetId,
//         ),
//       );
//     }
//   }

//   Widget _buildOtpUI({required bool isLoading, required String? errorMessage}) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Gaps.vGap32,
//           Padding(
//             padding: EdgeInsets.all(16.w),
//             child: const AuthAppBar(showBackButton: true),
//           ),
//           Container(
//             height: ScreenUtil().screenHeight * 0.6,
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Gaps.vGap20,
//                 Text('activation_code'.tr, style: TextStyles.semiBold24()),
//                 Gaps.vGap10,
//                 Text(
//                   'enter_verification_code'.tr,
//                   style: TextStyles.semiBold14(color: colors.lightTextColor),
//                 ),
//                 Gaps.vGap40,
//                 PinCodeWidget(
//                   pinLength: 4,
//                   controller: codeController,
//                   focus: codeFocus,
//                   textSubmit: (_) => _onConfirmPressed(),
//                 ),
//                 Gaps.vGap35,
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'resend_code'.tr,
//                       style: TextStyles.medium14(color: colors.main),
//                     ),
//                     Gaps.hGap10,
//                     AnimatedBuilder(
//                       animation: timeController,
//                       builder: (context, _) =>
//                           Text(timerString, style: TextStyles.medium12()),
//                     ),
//                   ],
//                 ),
//                 Gaps.vGap40,
//                 isLoading
//                     ? const LoadingView()
//                     : MyDefaultButton(
//                         color: colors.main,
//                         btnText: 'confirm_button',
//                         onPressed: _onConfirmPressed,
//                       ),
//                 if (errorMessage != null) ...[
//                   Gaps.vGap10,
//                   Center(
//                     child: Text(
//                       errorMessage,
//                       style: TextStyles.medium14(color: Colors.red),
//                     ),
//                   ),
//                 ],
//                 Gaps.vGap30,
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isLogin = widget.authParams.otpType == 'login';

//     return Scaffold(
//       body: isLogin
//           ? BlocConsumer<VerifyLoginOtpCubit, VerifyLoginOtpState>(
//               listener: (context, state) {
//                 if (state is VerifyLoginOtpLoaded) {
//                   _onOtpSuccess();
//                 } else if (state is VerifyLoginOtpError) {
//                   _onOtpError(state.message);
//                 }
//               },
//               builder: (context, state) => _buildOtpUI(
//                 isLoading: state is VerifyLoginOtpIsLoading,
//                 errorMessage: state is VerifyLoginOtpError
//                     ? state.message
//                     : null,
//               ),
//             )
//           : BlocConsumer<VerfiyRegisterOtpCubit, VerfiyRegisterOtpState>(
//               listener: (context, state) {
//                 if (state is VerfiyRegisterOtpLoaded) {
//                   _onOtpSuccess();
//                 } else if (state is VerfiyRegisterOtpError) {
//                   _onOtpError(state.message);
//                 }
//               },
//               builder: (context, state) => _buildOtpUI(
//                 isLoading: state is VerfiyRegisterOtpIsLoading,
//                 errorMessage: state is VerfiyRegisterOtpError
//                     ? state.message
//                     : null,
//               ),
//             ),
//     );
//   }
// }
