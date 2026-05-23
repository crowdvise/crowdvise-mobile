import 'package:crowdvise/core/presentation/utils/custom_state.dart';
import 'package:crowdvise/core/presentation/utils/router_utils.dart';
import 'package:crowdvise/core/presentation/manager/theme_provider.dart';
import 'package:crowdvise/core/presentation/theme/app_theme.dart';
import 'package:crowdvise/core/presentation/utils/snack_bar_utils.dart';
import 'package:crowdvise/features/history/presentation/manager/history_provider.dart';
import 'package:crowdvise/features/session/presentation/manager/session_provider.dart';
import 'package:crowdvise/features/splash/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class CrowdViseApp extends StatelessWidget with AppTheme {
  const CrowdViseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SessionProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: ChangeNotifierProvider(
        create: (_) => ThemeProvider(context),
        child: Consumer<ThemeProvider>(
          builder: (_, provider, _) {
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: provider.isDark
                    ? Brightness.light
                    : Brightness.dark,
              ),
            );
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: provider.isDark
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark,
              child: ToastificationWrapper(
                child: MaterialApp(
                  scaffoldMessengerKey: snackbarKey,
                  debugShowCheckedModeBanner: false,
                  title: 'CrowdVise',
                  theme: provider.theme,
                  darkTheme: provider.darkThemeData,
                  navigatorKey: navigator,
                  initialRoute: SplashScreen.id,
                  navigatorObservers: [routeObserver],
                  onGenerateRoute: generateRoute,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
