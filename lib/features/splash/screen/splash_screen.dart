import 'package:crowdvise/core/presentation/res/drawables.dart';
import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/custom_state.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/utils/snack_bar_utils.dart';
import 'package:crowdvise/core/presentation/widgets/app_background.dart';
import 'package:crowdvise/core/presentation/widgets/svg_image.dart';
import 'package:crowdvise/features/landing/presentation/screens/landing_screen.dart';
import 'package:crowdvise/features/session/presentation/screens/dashboard.dart';
import 'package:crowdvise/features/splash/manager/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
class SplashScreen extends StatefulWidget {
  static const String id = "/";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends CustomState<SplashScreen> {
  SplashProvider? _provider;

  @override
  void onStarted() {
    _provider?.listen((event) {
      logg("$event");
      if (event == -1 || event == 0) {
        context.pushNamedAndClear(LandingScreen.id);
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
            body: AppBackground(
              showGrid: false,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SvgImage(
                          asset: crowdviseSymbol,
                          width: 64,
                          height: 64,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'CrowdVise',
                          style: theme.textTheme.displayLarge?.copyWith(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: textPrimary,
                            letterSpacing: -0.8,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Customer research, before you ship',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: textTertiary,
                            fontSize: 14,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    )
                        .animate()
                        .fadeIn(duration: 500.ms, curve: Curves.easeOut)
                        .slideY(
                          begin: 0.08,
                          end: 0,
                          duration: 500.ms,
                          curve: Curves.easeOutCubic,
                        ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 48,
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: signal,
                        ),
                      ).animate().fadeIn(delay: 600.ms, duration: 300.ms),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
