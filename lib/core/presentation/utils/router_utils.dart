import 'package:crowdvise/features/auth/presentation/screens/login.dart';
import 'package:crowdvise/features/auth/presentation/screens/register.dart';
import 'package:crowdvise/features/insights/presentation/screens/full_insights.dart';
import 'package:crowdvise/features/insights/presentation/screens/insights.dart';
import 'package:crowdvise/features/insights/presentation/screens/live_reactions.dart';
import 'package:crowdvise/features/session/domain/models/simulation_model.dart';
import 'package:crowdvise/features/session/presentation/screens/assembling_panel.dart';
import 'package:crowdvise/features/session/presentation/screens/dashboard.dart';
import 'package:crowdvise/features/session/presentation/screens/home.dart';
import 'package:crowdvise/features/session/presentation/screens/generate_journery.dart';
import 'package:crowdvise/features/session/presentation/screens/review_journey.dart';
import 'package:crowdvise/features/splash/screen/splash_screen.dart';
import 'package:crowdvise/features/splash/screen/onboarding.dart';
import 'package:crowdvise/features/splash/screen/welcome_screen.dart';
import 'package:crowdvise/features/insights/presentation/screens/reaction_detail.dart';
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
        viewToShow: ReviewJourneyScreen(),
      );
    case AssemblingPanelScreen.id:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: const AssemblingPanelScreen(productDescription: ''),
      );

    case InsightsScreen.id:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: InsightsScreen(simulationId: settings.arguments as String),
      );

    case LiveReactionsScreen.id:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LiveReactionsScreen(
          journeys: settings.arguments as List<AgentJourney>,
        ),
      );

    case ReactionDetailScreen.id:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ReactionDetailScreen(
          journey: settings.arguments as AgentJourney,
        ),
      );

    case FullInsightsScreen.id:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: FullInsightsScreen(
          insights: settings.arguments as List<String>,
        ),
      );

    case DashboardScreen.id:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: const DashboardScreen(),
      );

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
