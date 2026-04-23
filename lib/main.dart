import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_locale_cubit.dart';
import 'package:khedma/config/locale/app_localizations_setup.dart';
import 'package:khedma/config/routes/app_routes.dart';
import 'package:khedma/config/themes/app_theme.dart';
import 'package:khedma/core/navigation/navigation_injection.dart';
import 'package:khedma/features/auth/auth_injection.dart';
import 'package:khedma/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<AppLocaleCubit>(
          create: (_) => ServiceLocator.instance<AppLocaleCubit>(),
        ),
        ...authBlocs,
        ...navigationBlocs,
      ],
      child: ScreenUtilInit(
        // designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return BlocBuilder<AppLocaleCubit, Locale>(
            builder: (context, locale) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                routerConfig: Routes.router,
                locale: locale,
                supportedLocales: AppLocalizationsSetup.supportedLocales,
                localizationsDelegates:
                    AppLocalizationsSetup.localizationsDelegates,
                localeResolutionCallback:
                    AppLocalizationsSetup.localeResolutionCallback,
                theme: getAppTheme(context),
                builder: (buildContext, widgetChild) =>
                    widgetChild ?? child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
