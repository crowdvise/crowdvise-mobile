import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/features/splash/widget/avatar_grid.dart';
import 'package:flutter/material.dart';

class SolutionScreen extends StatelessWidget {
  const SolutionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AvatarGrid2(),
          const Spacer(),
          const Text(
            'THE SOLUTION',
            style: TextStyle(
              color: Colors.white54,
              fontFamily: 'PlusJakartaSans',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Meet your\n'),
                TextSpan(
                  text: 'synthetic\npanel.',
                  style: TextStyle(color: electricBlue),
                ),
              ],
            ),
            style: TextStyle(
              fontFamily: 'Syne',
              fontSize: 40,
              fontWeight: FontWeight.w800,
              height: 1.1,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'AI customers that behave like real humans some\ndrop off, some subscribe, some complain loudly.',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 15,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
