import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/cubit_reset_utils.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/my_default_button.dart';
import '/features/auth/presentation/cubit/logout_cubit/logout_cubit.dart';
import '/injection_container.dart';

class ProfileSignOutButton extends StatelessWidget {
  const ProfileSignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LogoutCubit>(
      create: (_) => ServiceLocator.instance<LogoutCubit>(),
      child: BlocConsumer<LogoutCubit, LogoutState>(
        listener: _onStateChanged,
        builder: (context, state) {
          final isLoading = state is LogoutIsLoading;
          return SizedBox(
            width: double.infinity,
            height: 50.h,
            child: MyDefaultButton(
              btnText: 'profile_sign_out',
              onPressed: isLoading ? () {} : () => _confirmAndSignOut(context),
              color: colors.whiteColor,
              borderColor: colors.onboardingBorderNeutral,
              borderRadius: 20.r,
              height: 50.h,
              textStyle: TextStyles.bold20(color: colors.errorColor),
            ),
          );
        },
      ),
    );
  }

  Future<void> _onStateChanged(BuildContext context, LogoutState state) async {
    if (state is LogoutSuccess) {
      await CubitResetUtils.resetAllCubits();
      if (context.mounted) {
        context.go(Routes.loginScreenRoute);
      }
    } else if (state is LogoutError) {
      final message = state.message.isEmpty
          ? 'profile_sign_out_failed'.tr
          : state.message;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _confirmAndSignOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('profile_sign_out'.tr),
        content: Text('profile_sign_out_confirm'.tr),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text('profile_sign_out'.tr),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<LogoutCubit>().logout();
    }
  }
}
