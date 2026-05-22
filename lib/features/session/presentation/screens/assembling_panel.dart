import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/widgets/button.dart';
import 'package:crowdvise/features/insights/presentation/screens/insights.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AssemblingPanelScreen extends StatefulWidget {
  static const id = '/assembling_panel';

  const AssemblingPanelScreen({super.key});

  @override
  State<AssemblingPanelScreen> createState() => _AssemblingPanelScreenState();
}

class _AssemblingPanelScreenState extends State<AssemblingPanelScreen> {
  final List<Color> _colors = [
    const Color(0xFF4285F4),
    const Color(0xFFEA4335),
    const Color(0xFF34A853),
    const Color(0xFF8B5CF6),
    const Color(0xFFF24968),
    const Color(0xFFF3B70F),
    const Color(0xFF0FBC73),
    const Color(0xFF7993F2),
    const Color(0xFF34D399),
  ];

  final List<String> _letters = [
    'M',
    'P',
    'A',
    'D',
    'J',
    'K',
    'L',
    'S',
    'T',
    'R',
    'N',
    'B',
    'C',
    'F',
    'H',
    'I',
    'W',
    'X',
    'Q',
    'Z',
    'E',
    'O',
    'U',
    'V',
    'Y',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: nearBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                'Assembling your\npanel',
                textAlign: TextAlign.center,
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                  color: Colors.white,
                ),
              ),
              const Gap(16),
              Text(
                'Generating 25 synthetic customers...',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  color: Colors.white60,
                ),
              ),
              const Gap(48),
              _buildAvatarGrid(theme),
              const Gap(48),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const LinearProgressIndicator(
                    value: 0.8,
                    minHeight: 4,
                    backgroundColor: Colors.white10,
                    valueColor: AlwaysStoppedAnimation<Color>(electricBlue),
                  ),
                ),
              ),
              const Gap(16),
              Text(
                'Finalising reactions...',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  color: Colors.white54,
                ),
              ),
              const Gap(48),
              Button(
                title: 'See reactions',
                onPressed: () {
                  context.pushNamed(InsightsScreen.id);
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarGrid(ThemeData theme) {
    return Column(
      children: List.generate(5, (rowIndex) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (colIndex) {
              final index = rowIndex * 5 + colIndex;
              final letter = _letters[index % _letters.length];
              final color = _colors[index % _colors.length];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: color,
                  child: Text(
                    letter,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}
