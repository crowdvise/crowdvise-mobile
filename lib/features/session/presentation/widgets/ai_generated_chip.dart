import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class AiGeneratedChip extends StatefulWidget {
  const AiGeneratedChip({super.key});

  @override
  State<AiGeneratedChip> createState() => _AiGeneratedChipState();
}

class _AiGeneratedChipState extends State<AiGeneratedChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _circle;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _circle = Tween<double>(
      begin: 0.3,
      end: 0.75,
    ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: electricBlue.withValues(alpha: .09),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: electricBlue, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 8,
          children: [
            AnimatedBuilder(
              animation: _circle,
              builder: (_, _) => Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: electricBlue.withValues(alpha: _circle.value * 1),
                ),
              ),
            ),
            Text(
              'AI generated · tap to edit',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: electricBlue,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LiveGeneratedChip extends StatefulWidget {
  const LiveGeneratedChip({super.key});

  @override
  State<LiveGeneratedChip> createState() => _LiveGeneratedChipState();
}

class _LiveGeneratedChipState extends State<LiveGeneratedChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _circle;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _circle = Tween<double>(
      begin: 0.3,
      end: 0.75,
    ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF3B1515).withValues(alpha: .5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 8,
          children: [
            AnimatedBuilder(
              animation: _circle,
              builder: (_, _) => Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF24968).withValues(alpha: _circle.value * 1),
                ),
              ),
            ),
            Text(
              'LIVE',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Color(0xFFF24968),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
