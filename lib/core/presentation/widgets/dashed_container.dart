import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/widgets/clickable.dart';
import 'package:flutter/material.dart';

class DashedBorderContainer extends StatelessWidget {
  const DashedBorderContainer({super.key, this.child, this.height, this.onTap});
  final Widget? child;
  final double? height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Clickable(
      onPressed: (){
        onTap!();
      },
      child: SizedBox(
        height: height ?? 150,
        width: double.infinity,
        child: CustomPaint(painter: DashedBorderPainter(), child: child),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 6.0;
    const dashSpace = 3.0;

    final paint = Paint()
      ..color = electricBlue
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(12),
    );

    final path = Path()..addRRect(rect);

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
