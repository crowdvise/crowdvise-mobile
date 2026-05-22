import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class AvatarGrid1 extends StatelessWidget {
  const AvatarGrid1({super.key});

  @override
  Widget build(BuildContext context) {
    const avatars = [
      AvatarWidget(letter: 'M', color: Color(0xFF4A84F6)),
      AvatarWidget(letter: 'P', color: Color(0xFFF27B49)),
      AvatarWidget(letter: 'A', color: Color(0xFF0FBC73)),
      AvatarWidget(letter: 'D', color: Color(0xFF9863F6)),
      AvatarWidget(letter: 'J', color: Color(0xFFF24968)),
      AvatarWidget(letter: 'K', color: Color(0xFFF3B70F)),
      AvatarWidget(letter: 'L', color: Color(0xFFE8541A)),
      AvatarWidget(letter: 'S', color: Color(0xFF227B8F)),
      AvatarWidget(letter: 'T', color: Color(0xFF0F9B66)),
      AvatarWidget(letter: 'R', color: Color(0xFF943447)),
      AvatarWidget(letter: 'N', color: Color(0xFF225884)),
      AvatarWidget(letter: 'B', color: Color(0xFFB4974F)),
    ];
    return const Wrap(
      spacing: 12,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: avatars,
    );
  }
}

class AvatarGrid2 extends StatelessWidget {
  const AvatarGrid2({super.key});

  @override
  Widget build(BuildContext context) {
    const check = BadgeWidget(icon: Icons.check, color: Color(0xFF0FBC73));
    const question = BadgeWidget(
      icon: Icons.question_mark,
      color: Color(0xFFF3B70F),
    );
    const cross = BadgeWidget(icon: Icons.close, color: Color(0xFFF24968));
    const minus = BadgeWidget(icon: Icons.remove, color: Color(0xFF4A84F6));

    const avatars = [
      AvatarWidget(letter: 'M', color: Color(0xFF4A84F6), badge: check),
      AvatarWidget(letter: 'P', color: Color(0xFFF27B49), badge: question),
      AvatarWidget(letter: 'A', color: Color(0xFF0FBC73), badge: cross),
      AvatarWidget(letter: 'D', color: Color(0xFF9863F6), badge: check),
      AvatarWidget(letter: 'J', color: Color(0xFFF24968), badge: minus),
      AvatarWidget(letter: 'K', color: Color(0xFFF3B70F), badge: check),
      AvatarWidget(letter: 'L', color: Color(0xFFE8541A), badge: question),
      AvatarWidget(letter: 'S', color: Color(0xFF00C4D0), badge: check),
      AvatarWidget(letter: 'T', color: Color(0xFF0F9B66), badge: cross),
      AvatarWidget(letter: 'R', color: Color(0xFFE24C73), badge: check),
      AvatarWidget(letter: 'N', color: Color(0xFF199AB5), badge: minus),
      AvatarWidget(letter: 'B', color: Color(0xFFDEBB5E), badge: question),
      AvatarWidget(letter: 'C', color: Color(0xFF2E845A), badge: check),
      AvatarWidget(letter: 'F', color: Color(0xFF9863F6), badge: check),
      AvatarWidget(letter: 'M', color: Color(0xFF4A84F6), badge: cross),
    ];
    return const Center(
      child: Wrap(
        spacing: 12,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        children: avatars,
      ),
    );
  }
}

class AvatarWidget extends StatelessWidget {
  final String letter;
  final Color color;
  final Widget? badge;

  const AvatarWidget({
    super.key,
    required this.letter,
    required this.color,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text(
            letter,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontFamily: 'PlusJakartaSans',
              fontSize: 18,
            ),
          ),
        ),
        if (badge != null) Positioned(bottom: -2, right: -2, child: badge!),
      ],
    );
  }
}

class BadgeWidget extends StatelessWidget {
  final IconData icon;
  final Color color;

  const BadgeWidget({super.key, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: nearBlack, width: 2),
      ),
      child: Icon(icon, size: 10, color: Colors.white),
    );
  }
}
