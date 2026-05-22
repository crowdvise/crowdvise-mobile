import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/widgets/button.dart';
import 'package:crowdvise/features/auth/presentation/screens/register.dart';
import 'package:crowdvise/features/splash/manager/onboarding_provider.dart';
import 'package:crowdvise/features/splash/screen/tabs/outcome.dart';
import 'package:crowdvise/features/splash/screen/tabs/problem.dart';
import 'package:crowdvise/features/splash/screen/tabs/solution.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  static const String id = "/onboarding";
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  OnboardingProvider? _provider;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OnboardingProvider(),
      builder: (context, child) {
        return Consumer<OnboardingProvider>(
          builder: (_, provider, _) {
            _provider ??= provider;
            final state = provider.state;
            return Scaffold(
              backgroundColor: nearBlack,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            provider.setOnboarding();
                            context.pushNamedAndClear(RegisterScreen.id);
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                color: Colors.white54,
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Gap(24),
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          physics: const BouncingScrollPhysics(),
                          onPageChanged: provider.setIndex,
                          children: const [
                            ProblemScreen(),
                            SolutionScreen(),
                            OutcomeScreen(),
                          ],
                        ),
                      ),
                      const Gap(28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          final isActive = index == state.currentPage;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: isActive ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: isActive ? electricBlue : Colors.white24,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),

                      const Gap(32),
                      Button(
                        title: state.currentPage == 2 ? 'Let\'s start' : 'Next',
                        onPressed: () {
                          if (state.currentPage < 2) {
                            _pageController.animateToPage(
                              state.currentPage + 1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            provider.setOnboarding();
                            context.pushNamedAndClear(RegisterScreen.id);
                          }
                        },
                      ),
                      const Gap(20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
