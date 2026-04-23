import 'package:flutter/material.dart';

import '/core/widgets/loading_view.dart';
import '/core/widgets/my_default_button.dart';
import '/injection_container.dart';

class AuthButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String btnText;
  final bool isLoading;

  const AuthButton({
    super.key,
    required this.onPressed,
    required this.btnText,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LoadingView(bgColor: colors.main)
        : MyDefaultButton(
            color: colors.main,
            borderColor: colors.main,
            onPressed: onPressed,
            btnText: btnText,
          );
  }
}

