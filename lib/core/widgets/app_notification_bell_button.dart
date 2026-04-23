import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/injection_container.dart';
import '/config/routes/app_routes.dart';

class AppNotificationBellButton extends StatelessWidget {
  const AppNotificationBellButton({super.key});

  @override
  Widget build(BuildContext context) {
    // if (useDarkFilledCircle) {
    //   return Material(
    //     color: colors.onboardingHeadline,
    //     shape: const CircleBorder(),
    //     clipBehavior: Clip.antiAlias,
    //     child: InkWell(
    //       customBorder: const CircleBorder(),
    //       onTap: () => context.push(Routes.notificationsRoute),
    //       child: SizedBox(
    //         width: 40.r,
    //         height: 40.r,
    //         child: Icon(
    //           Icons.notifications_none_rounded,
    //           size: 20.r,
    //           color: colors.whiteColor,
    //         ),
    //       ),
    //     ),
    //   );
    // }

    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        IconButton(
          padding: EdgeInsets.all(8.r),
          onPressed: () => context.push(Routes.notificationsRoute),
          icon: Icon(
            Icons.notifications_none_rounded,
            size: 20.r,
            color: colors.onboardingHeadline,
          ),
        ),
        Positioned(
          right: 8.w,
          top: 8.h,
          child: Container(
            width: 8.r,
            height: 8.r,
            decoration: BoxDecoration(
              color: colors.errorColor,
              shape: BoxShape.circle,
              border: Border.all(color: colors.whiteColor, width: 2.w),
            ),
          ),
        ),
      ],
    );
  }
}
