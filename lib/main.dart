import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sample/global/bloc_providers.dart';
import 'package:sample/global/locator.dart';
import 'package:sample/global/router/my_router_observer.dart';
import 'package:sample/global/router/navigation_utils.dart';
import 'package:sample/global/router/router.dart';
import 'package:sample/main.dart';
import 'package:sample/utils/color_utils.dart';
import 'package:sample/utils/display.dart';
export 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  await setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    context.setOnlyPortrait();
    return MultiBlocProvider(
      providers: blocProviders,
      child: ScreenUtilInit(builder: (context, child) {
        return MaterialApp(
          title: 'Sample',
          theme: ThemeData(
            bottomAppBarTheme: const BottomAppBarTheme(
              color: ColorUtils.white2,
            ),
            fontFamily: 'Pretendard',
            scaffoldBackgroundColor: ColorUtils.white2,
            useMaterial3: true,
          ),
          navigatorKey: NavigatorUtils.navigatorKey,
          onGenerateRoute: (settings) => MyRouter.generateRoute(settings),
          navigatorObservers: [MyRouteObserver()],
          initialRoute: MyRouter.splash,
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          // locale: Localizations.localeOf(context),
        );
      }),
    );
  }
}
