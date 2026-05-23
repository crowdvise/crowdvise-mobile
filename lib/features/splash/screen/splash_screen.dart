import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/custom_state.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/utils/snack_bar_utils.dart';
import 'package:crowdvise/features/auth/presentation/screens/login.dart';
import 'package:crowdvise/features/session/presentation/screens/dashboard.dart';
import 'package:crowdvise/features/splash/manager/splash_provider.dart';
import 'package:crowdvise/features/splash/screen/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:sprung/sprung.dart';

class SplashScreen extends StatefulWidget {
  static const String id = "/";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends CustomState<SplashScreen>
    with SingleTickerProviderStateMixin {
  SplashProvider? _provider;
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void onStart() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Start at the bottom
      end: const Offset(0.0, 0.0), // End at the center
    ).animate(CurvedAnimation(parent: _controller, curve: Sprung.underDamped));

    _controller.forward();
    super.onStart();
  }

  @override
  void onStarted() {
    _provider?.listen((event) {
      logg("$event");
      if (event == -1) {
        context.push(OnboardingScreen());
      } else if (event == 0) {
        context.pushNamedAndClear(LoginScreen.id);
      } else {
        context.pushNamedAndClear(DashboardScreen.id);
      }
    });
    super.onStarted();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (_) => SplashProvider(),
      child: Consumer<SplashProvider>(
        builder: (_, provider, _) {
          _provider ??= provider;
          return Scaffold(
            backgroundColor: nearBlack,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SlideTransition(
                  position: _animation,
                  child:
                      Center(
                            child: Text.rich(
                              TextSpan(
                                text: "Crowd",
                                style: theme.textTheme.displayLarge?.copyWith(
                                  color: white,
                                  fontSize: 40,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Vise",
                                    style: theme.textTheme.displayLarge
                                        ?.copyWith(
                                          color: electricBlue,
                                          fontSize: 40,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .animate(
                            onPlay: (controller) {
                              controller.forward();
                            },
                          )
                          .then(delay: 500.ms)
                          .fadeIn(duration: 1000.ms, curve: Curves.easeInExpo)
                          .slideY(
                            delay: 800.ms,
                            begin: 0.5,
                            duration: 600.ms,
                            curve: Sprung.overDamped,
                          )
                          .then(delay: 500.ms)
                          .shimmer(
                            delay: 100.ms,
                            duration: 1800.ms,
                            color: Colors.white.withValues(alpha: .7),
                          ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
