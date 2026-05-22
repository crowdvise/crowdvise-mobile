
import 'package:flutter/material.dart';

class OldWayCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String subtitle;

  const OldWayCard({
    super.key,
    required this.icon,
    required this.color,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161618),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 14,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'OLD WAY',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}