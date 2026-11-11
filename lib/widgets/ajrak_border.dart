import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Full-width ajrak strip, 10 px tall. With [progress] it "prints" left to right.
class AjrakBorder extends StatelessWidget {
  const AjrakBorder({super.key, this.progress});

  /// 0..1. Null paints the whole strip.
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        height: 10,
        width: double.infinity,
        child: CustomPaint(painter: _AjrakPainter(progress)),
      ),
    );
  }
}

class _AjrakPainter extends CustomPainter {
  _AjrakPainter(this.progress);
  final double? progress;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final limit = progress == null ? w : w * progress!.clamp(0.0, 1.0);
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.white);
    if (progress != null) {
      canvas.drawRect(
        Rect.fromLTWH(limit, 0, w - limit, size.height),
        Paint()..color = AppColors.field,
      );
    }
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, limit, size.height));
    final madder = Paint()..color = AppColors.madder;
    final indigo = Paint()..color = AppColors.indigo;
    for (double x = 0; x <= w; x += 20) {
      final diamond = Path()
        ..moveTo(x + 10, 1.5)
        ..lineTo(x + 13.5, 5)
        ..lineTo(x + 10, 8.5)
        ..lineTo(x + 6.5, 5)
        ..close();
      canvas.drawPath(diamond, madder);
      canvas.drawCircle(Offset(x, 5), 1.6, indigo);
    }
    canvas.restore();
    canvas.drawRect(Rect.fromLTWH(0, 0, w, 1), indigo);
    canvas.drawRect(Rect.fromLTWH(0, size.height - 1, w, 1), indigo);
  }

  @override
  bool shouldRepaint(_AjrakPainter old) => old.progress != progress;
}
