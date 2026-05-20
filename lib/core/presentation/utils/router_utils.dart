import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    // case SplashScreen.id:
    //   return _getPageRoute(
    //     routeName: settings.name,
    //     viewToShow: const SplashScreen(),
    //   );

    // case SelectRoleScreen.id:
    //   return _getPageRoute(
    //     routeName: settings.name,
    //     viewToShow: const SelectRoleScreen(),
    //   );

    // case RegisterScreen.id:
    //   return _getPageRoute(
    //     routeName: settings.name,
    //     viewToShow: const RegisterScreen(),
    //   );

    // case LoginScreen.id:
    //   return _getPageRoute(
    //     routeName: settings.name,
    //     viewToShow: const LoginScreen(),
    //   );

    // case VerifyScreen.id:
    //   return _getPageRoute(
    //     routeName: settings.name,
    //     viewToShow: VerifyScreen(email: settings.arguments as String),
    //   );

    // case SetupProfileScreen.id:
    //   return _getPageRoute(
    //     routeName: settings.name,
    //     viewToShow: const SetupProfileScreen(),
    //   );

    // case ForgotPasswordScreen.id:
    //   return _getPageRoute(
    //     routeName: settings.name,
    //     viewToShow: const ForgotPasswordScreen(),
    //   );

    // case ResetPasswordScreen.id:
    //   return _getPageRoute(
    //     routeName: settings.name,
    //     viewToShow: const ResetPasswordScreen(),
    //   );

    // case DashboardScreen.id:
    //   return _getPageRoute(
    //     routeName: settings.name,
    //     viewToShow: const DashboardScreen(),
    //   );
    // case ClothingTypeScreen.id:
    //   return _getPageRoute(
    //     routeName: settings.name,
    //     viewToShow: const ClothingTypeScreen(),
    //   );

    // case AddServiceScreen.id:
    //   return _getPageRoute(
    //     routeName: settings.name,
    //     viewToShow: const AddServiceScreen(),
    //   );

    // case AddWorkScreen.id:
    //   return _getPageRoute(
    //     routeName: settings.name,
    //     viewToShow: const AddWorkScreen(),
    //   );      

    default:
      return MaterialPageRoute(
        builder:
            (_) => Scaffold(
              body: Center(
                child: Text('No route defined for ${settings.name}'),
              ),
            ),
      );
  }
}

PageRoute _getPageRoute({String? routeName, Widget? viewToShow}) {
  return MaterialPageRoute(
    settings: RouteSettings(name: routeName),
    builder: (_) => viewToShow!,
  );
}
