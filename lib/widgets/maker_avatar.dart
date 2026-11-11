import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// Faceless woman silhouette (madder dupatta), or an initial-letter circle.
class MakerAvatar extends StatelessWidget {
  const MakerAvatar({super.key, this.size = 44, this.ring = false})
    : initial = null;

  /// Indigo letter on indigoTint, e.g. for buyers.
  const MakerAvatar.initial(this.initial, {super.key, this.size = 36})
    : ring = false;

  final double size;
  final String? initial;

  /// 4 px white ring drawn outside [size] (storefront header: 76 + 8 = 84).
  final bool ring;

  @override
  Widget build(BuildContext context) {
    final Widget core = initial != null
        ? Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.indigoTint,
              shape: BoxShape.circle,
            ),
            child: Text(
              initial!,
              style: AppText.dm(
                size * 0.4,
                weight: FontWeight.w700,
                color: AppColors.indigo,
              ),
            ),
          )
        : SizedBox(
            width: size,
            height: size,
            child: CustomPaint(painter: _AvatarPainter()),
          );
    final avatar = ring
        ? Container(
            width: size + 8,
            height: size + 8,
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: core,
          )
        : core;
    return Semantics(label: 'Maker avatar', image: true, child: avatar);
  }
}

class _AvatarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final k = size.width / 48;
    canvas.scale(k);
    canvas.drawCircle(
      const Offset(24, 24),
      24,
      Paint()..color = AppColors.madderTint,
    );
    canvas.save();
    canvas.clipPath(
      Path()
        ..addOval(Rect.fromCircle(center: const Offset(24, 24), radius: 24)),
    );
    final body = Path()
      ..moveTo(10, 44)
      ..cubicTo(12, 34, 18, 30, 24, 30)
      ..cubicTo(30, 30, 36, 34, 38, 44);
    canvas.drawPath(body, Paint()..color = AppColors.madder);
    canvas.drawCircle(
      const Offset(24, 20),
      8,
      Paint()..color = AppColors.artSkin,
    );
    final dupatta = Path()
      ..moveTo(14, 22)
      ..cubicTo(14, 14, 18, 9, 24, 9)
      ..cubicTo(30, 9, 34, 14, 34, 22)
      ..cubicTo(32, 17, 28, 15, 24, 15)
      ..cubicTo(20, 15, 16, 17, 14, 22)
      ..close();
    canvas.drawPath(dupatta, Paint()..color = AppColors.madder);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_AvatarPainter old) => false;
}
