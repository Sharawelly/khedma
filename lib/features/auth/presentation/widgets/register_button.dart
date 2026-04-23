import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/widgets/loading_view.dart';
import '/core/widgets/my_default_button.dart';
import '/features/auth/presentation/cubit/register_cubit/register_cubit.dart';
import '/injection_container.dart';

class RegisterButton extends StatelessWidget {
  final VoidCallback onPressed;

  const RegisterButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return state is RegisterIsLoading
            ? LoadingView(bgColor: colors.main)
            : MyDefaultButton(
                color: colors.main,
                borderColor: colors.main,
                onPressed: onPressed,
                btnText: 'create_account',
                // textStyle: TextStyles.bold32(color: Colors.white),
              );
      },
    );
  }
}
