import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:flutter/material.dart';

/// Maps a persona behaviour string from the API to a status colour and a
/// human label. Only three tones are used so the result stays readable:
/// green = good, amber = hesitation, red = loss. Everything else is neutral.
class BehaviourTone {
  const BehaviourTone(this.color, this.label);
  final Color color;
  final String label;

  static BehaviourTone of(String raw) {
    switch (raw.trim().toLowerCase()) {
      case 'converted':
        return const BehaviourTone(statusReady, 'Converted');
      case 'continuing':
        return const BehaviourTone(textSecondary, 'Continuing');
      case 'delaying':
        return const BehaviourTone(statusWarning, 'Delaying');
      case 'confused':
        return const BehaviourTone(statusWarning, 'Confused');
      case 'frustrated':
        return const BehaviourTone(statusDanger, 'Frustrated');
      case 'dropped':
        return const BehaviourTone(statusDanger, 'Dropped off');
      default:
        final t = raw.trim();
        return BehaviourTone(
          textTertiary,
          t.isEmpty ? 'Unknown' : t[0].toUpperCase() + t.substring(1).toLowerCase(),
        );
    }
  }
}

/// Small flat status pill: dot + label.
class TonePill extends StatelessWidget {
  const TonePill(this.tone, {super.key});
  final BehaviourTone tone;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(shape: BoxShape.circle, color: tone.color),
        ),
        const SizedBox(width: 6),
        Text(
          tone.label,
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: tone.color,
          ),
        ),
      ],
    );
  }
}

/// Initial-letter avatar. Neutral surface with a hairline — no rainbow
/// palette — so the status colour stays the only colour in the row.
class InitialAvatar extends StatelessWidget {
  const InitialAvatar(this.name, {super.key, this.size = 36});
  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final t = name.trim();
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: wsCardHover,
        borderRadius: BorderRadius.circular(size * 0.28),
        border: Border.all(color: hairline),
      ),
      child: Text(
        t.isEmpty ? '?' : t[0].toUpperCase(),
        style: TextStyle(
          fontFamily: 'Syne',
          fontSize: size * 0.4,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
      ),
    );
  }
}
