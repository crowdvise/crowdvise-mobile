import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/utils/responsive.dart';
import 'package:crowdvise/core/presentation/widgets/button.dart';
import 'package:crowdvise/features/auth/presentation/screens/register.dart';
import 'package:crowdvise/features/splash/manager/onboarding_provider.dart';
import 'package:crowdvise/features/splash/screen/tabs/outcome.dart';
import 'package:crowdvise/features/splash/screen/tabs/problem.dart';
import 'package:crowdvise/features/splash/screen/tabs/solution.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import 'package:crowdvise/features/splash/widget/old_way.dart';
import 'package:crowdvise/features/splash/widget/avatar_grid.dart';
import 'package:crowdvise/features/splash/widget/adoption_score.dart';

class OnboardingStepData {
  final String title;
  final String description;
  final Widget visual;

  OnboardingStepData({
    required this.title,
    required this.description,
    required this.visual,
  });
}

class OnboardingScreen extends StatefulWidget {
  static const String id = "/onboarding";
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  OnboardingProvider? _provider;

  final List<OnboardingStepData> steps = [
    OnboardingStepData(
      title: "The Problem",
      description: "Traditional research is broken. Focus groups are slow, expensive, and rarely surface what customers actually want.",
      visual: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            OldWayCard(
              icon: Icons.attach_money,
              color: Color(0xFFF24968),
              value: '\$15,000',
              subtitle: 'avg. focus group cost',
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                '— VS —',
                style: TextStyle(
                  color: Colors.white30,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
            ),
            OldWayCard(
              icon: Icons.access_time_outlined,
              color: Color(0xFFF3B70F),
              value: '6 weeks',
              subtitle: 'time to get results',
            ),
          ],
        ),
      ),
    ),
    OnboardingStepData(
      title: "The Solution",
      description: "Meet your synthetic panel. AI customers that behave like real humans—some drop off, some subscribe, some complain loudly.",
      visual: const SingleChildScrollView(child: AvatarGrid2()),
    ),
    OnboardingStepData(
      title: "The Outcome",
      description: "Know what to fix before launch. Adoption score, top objections, and AI-powered recommendations in 30 seconds.",
      visual: const SingleChildScrollView(child: AdoptionScoreWidget()),
    ),
  ];

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
            final isDesktop = Responsive.isDesktop(context);

            return Scaffold(
              backgroundColor: nearBlack,
              body: SafeArea(
                child: isDesktop
                    ? _buildDesktopLayout(context, provider)
                    : _buildMobileLayout(context, provider),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDesktopLayout(BuildContext context, OnboardingProvider provider) {
    final state = provider.state;
    final currentStep = state.currentPage;

    return Center(
      child: Container(
        width: 1000,
        height: 600,
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left Sidebar
            Container(
              width: 320,
              padding: const EdgeInsets.all(32),
              decoration: const BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: electricBlue.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: electricBlue.withValues(alpha: 0.3)),
                    ),
                    child: const Icon(Icons.rocket_launch, color: electricBlue),
                  ),
                  const Gap(24),
                  const Text(
                    'Welcome to Crowdvise',
                    style: TextStyle(
                      fontFamily: 'Syne',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const Gap(8),
                  const Text(
                    'Explore our platform step-by-step to get the best out of your experience.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white54,
                      height: 1.5,
                    ),
                  ),
                  const Gap(40),
                  ...List.generate(steps.length, (index) {
                    final isActive = index == currentStep;
                    final isPast = index < currentStep;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Row(
                        children: [
                          if (isPast)
                            const Icon(Icons.check_circle, color: Color(0xFF0FBC73), size: 20)
                          else if (isActive)
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: electricBlue, width: 2),
                              ),
                              child: Center(
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: electricBlue,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            )
                          else
                            Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: Colors.white24,
                                shape: BoxShape.circle,
                              ),
                            ),
                          const Gap(16),
                          Expanded(
                            child: Text(
                              steps[index].title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                                color: isActive ? Colors.white : Colors.white54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Column(
                        key: ValueKey(currentStep),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            steps[currentStep].title,
                            style: const TextStyle(
                              fontFamily: 'Syne',
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const Gap(12),
                          Text(
                            steps[currentStep].description,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(40),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF131314),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white10),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            key: ValueKey(currentStep),
                            padding: const EdgeInsets.all(24),
                            child: Center(
                              child: steps[currentStep].visual,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            provider.setOnboarding();
                            context.pushNamedAndClear(RegisterScreen.id);
                          },
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              color: Colors.white54,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Button(
                          title: currentStep == steps.length - 1 ? 'Finish' : 'Continue',
                          width: 160,
                          onPressed: () {
                            if (currentStep < steps.length - 1) {
                              provider.setIndex(currentStep + 1);
                            } else {
                              provider.setOnboarding();
                              context.pushNamedAndClear(RegisterScreen.id);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, OnboardingProvider provider) {
    final state = provider.state;
    return Padding(
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
    );
  }
}
