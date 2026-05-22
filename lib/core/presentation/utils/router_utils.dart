import 'package:crowdvise/features/auth/presentation/screens/login.dart';
import 'package:crowdvise/features/auth/presentation/screens/register.dart';
import 'package:crowdvise/features/insights/presentation/screens/insights.dart';
import 'package:crowdvise/features/insights/presentation/screens/live_reactions.dart';
import 'package:crowdvise/features/session/presentation/screens/assembling_panel.dart';
import 'package:crowdvise/features/session/presentation/screens/home.dart';
import 'package:crowdvise/features/session/presentation/screens/generate_journery.dart';
import 'package:crowdvise/features/session/presentation/screens/review_journey.dart';
import 'package:crowdvise/features/splash/screen/splash_screen.dart';
import 'package:crowdvise/features/splash/screen/onboarding.dart';
import 'package:crowdvise/features/splash/screen/welcome_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashScreen.id:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: const SplashScreen(),
      );

    case OnboardingScreen.id:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: const OnboardingScreen(),
      );

    case WelcomeScreen.id:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: const WelcomeScreen(),
      );

    case RegisterScreen.id:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: const RegisterScreen(),
      );

    case LoginScreen.id:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: const LoginScreen(),
      );

    case HomeScreen.id:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: const HomeScreen(),
      );

    case GenerateJourneyScreen.id:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: const GenerateJourneyScreen(),
      );

    case ReviewJourneyScreen.id:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: const ReviewJourneyScreen(),
      );
    case AssemblingPanelScreen.id:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: const AssemblingPanelScreen(),
      );

    case InsightsScreen.id:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: const InsightsScreen(),
      );

    case LiveReactionsScreen.id:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: const LiveReactionsScreen(),
      );

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
        builder: (_) => Scaffold(
          body: Center(child: Text('No route defined for ${settings.name}')),
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
