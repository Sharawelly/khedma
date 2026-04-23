import 'package:khedma/core/widgets/type_writer_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/core/utils/values/text_styles.dart';
import '/injection_container.dart';

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final String? text;
  const AuthAppBar({super.key, required this.showBackButton, this.text});

  @override
  Size get preferredSize => Size.fromHeight(60.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,

      automaticallyImplyLeading: true,
      iconTheme: IconThemeData(color: colors.main, size: 30),

      title: text != null
          ? TypeWriterEffect(
              text: text!,
              style: TextStyles.bold30(color: colors.main),
            )
          : null,
      centerTitle: true,
    );
  }
}
