import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/widgets/button.dart';
import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/features/session/presentation/manager/home_provider.dart';
import 'package:crowdvise/features/session/presentation/screens/generate_journery.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatefulWidget {
  static const id = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      provider: HomeProvider(),
      children: (provider, theme) {
        return [
          const Gap(24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'Crowd',
                      children: [
                        TextSpan(
                          text: 'Vise',
                          style: TextStyle(color: electricBlue),
                        ),
                      ],
                    ),
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 3,
                    ),
                  ),

                  const Gap(40),
                  Text.rich(
                    TextSpan(
                      text: 'Test\nbefore\nyou ',
                      children: [
                        TextSpan(
                          text: 'build.',
                          style: TextStyle(color: electricBlue),
                        ),
                      ],
                    ),
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 54,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                      color: Colors.white,
                    ),
                  ),
                  const Gap(16),
                  Text(
                    'Synthetic customer panels that behave like real humans without the focus group bill.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      color: Colors.white60,
                      height: 1.5,
                    ),
                  ),
                  const Gap(32),
                  Button(
                    title: 'Start your Journey',
                    onPressed: () {
                      context.pushNamed(GenerateJourneyScreen.id);
                    },
                  ),
                  const Gap(40),
                  Text(
                    'RECENT SIMULATIONS',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.white54,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Gap(16),
                  _buildSessionCard(
                    theme: theme,
                    title: 'Premium subscription tier — SaaS product',
                    scoreText: '68/100 adoption likelihood',
                    scoreColor: const Color(0xFFF3B70F), // Warning yellow
                    timeAgo: '2 days ago',
                    avatars: [
                      _AvatarData('M', const Color(0xFF4285F4)),
                      _AvatarData('P', const Color(0xFFEA4335)),
                      _AvatarData('A', const Color(0xFF34A853)),
                      _AvatarData('D', const Color(0xFF8B5CF6)),
                      _AvatarData('T', const Color(0xFFF24968)),
                    ],
                    extraCount: '+20',
                  ),
                  const Gap(16),
                  _buildSessionCard(
                    theme: theme,
                    title: 'Dark mode redesign — mobile app',
                    scoreText: '81/100 adoption likelihood',
                    scoreColor: const Color(0xFF0FBC73), // Success green
                    timeAgo: '5 days ago',
                    avatars: [
                      _AvatarData('J', const Color(0xFF34A853)),
                      _AvatarData('K', const Color(0xFFEA4335)),
                      _AvatarData('L', const Color(0xFF4285F4)),
                    ],
                    extraCount: '+22',
                  ),
                  const Gap(40),
                ],
              ),
            ),
          ),
        ];
      },
    );
  }

  Widget _buildSessionCard({
    required ThemeData theme,
    required String title,
    required String scoreText,
    required Color scoreColor,
    required String timeAgo,
    required List<_AvatarData> avatars,
    required String extraCount,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF131314),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const Gap(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                scoreText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: scoreColor,
                ),
              ),
              Text(
                timeAgo,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
          const Gap(16),
          Row(
            children: [
              ...avatars.map(
                (data) => Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: data.color,
                    child: Text(
                      data.initial,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.white24,
                child: Text(
                  extraCount,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvatarData {
  final String initial;
  final Color color;

  _AvatarData(this.initial, this.color);
}
