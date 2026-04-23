import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/core/utils/values/text_styles.dart';
import '/core/widgets/my_default_button.dart';
import '/injection_container.dart';

class ProfileSignOutButton extends StatelessWidget {
  const ProfileSignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: MyDefaultButton(
        btnText: 'profile_sign_out',
        onPressed: () {},
        color: colors.whiteColor,
        borderColor: colors.onboardingBorderNeutral,
        // borderRadius: 999,
        borderRadius: 20.r,
        height: 50.h,
        textStyle: TextStyles.bold20(color: colors.errorColor),
      ),
    );
  }
}
