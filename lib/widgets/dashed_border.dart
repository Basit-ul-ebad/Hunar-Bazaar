import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Dashed rounded border (empty photo slots, upload card, "+ Other" chip).
class DashedBorder extends StatelessWidget {
  const DashedBorder({
    super.key,
    required this.child,
    this.radius = 12,
    this.color = AppColors.inputBorder,
    this.fill = Colors.white,
  });

  final Widget child;
  final double radius;
  final Color color;
  final Color fill;

  @override
  Widget build(BuildContext context) => CustomPaint(
    foregroundPainter: _DashPainter(radius, color),
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    ),
  );
}

class _DashPainter extends CustomPainter {
  _DashPainter(this.radius, this.color);
  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0.5, 0.5, size.width - 1, size.height - 1),
      Radius.circular(radius),
    );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (final m in (Path()..addRRect(rrect)).computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        canvas.drawPath(m.extractPath(d, d + 4), paint);
        d += 7;
      }
    }
  }

  @override
  bool shouldRepaint(_DashPainter old) =>
      old.radius != radius || old.color != color;
}
