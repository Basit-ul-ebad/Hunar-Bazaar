import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum ArtVariant { phulkari, ajrak, ralli, bluePottery, sindhi }

enum CenterMark { square, circle, none }

/// Colours for one piece of placeholder art. Product-art colours only.
class ArtSpec {
  const ArtSpec(this.variant, {this.ground, this.motif, this.center});

  final ArtVariant variant;
  final Color? ground;
  final Color? motif;
  final Color? center;
}

/// Placeholder that stands in for a product photo. Replace with Image.network later.
class ProductArt extends StatelessWidget {
  const ProductArt({
    super.key,
    required this.variant,
    this.tile,
    this.ground,
    this.motif,
    this.center,
    this.centerMark = CenterMark.square,
    this.ring = false,
    this.cornerDots = false,
    this.squareRatio = 0.58,
    this.dotRatio = 0.12,
    this.motifRatio = 0.365,
    this.mini = false,
    this.ralliColors,
    this.bandColor,
    this.bandHeight = 0,
    this.radius = BorderRadius.zero,
    this.semanticLabel,
  });

  /// Builds art from an [ArtSpec].
  ProductArt.spec(
    ArtSpec spec, {
    Key? key,
    double? tile,
    CenterMark centerMark = CenterMark.square,
    bool ring = false,
    bool cornerDots = false,
    double squareRatio = 0.58,
    double dotRatio = 0.12,
    double motifRatio = 0.365,
    bool mini = false,
    BorderRadius radius = BorderRadius.zero,
    String? semanticLabel,
  }) : this(
         key: key,
         variant: spec.variant,
         ground: spec.ground,
         motif: spec.motif,
         center: spec.center,
         tile: tile,
         centerMark: centerMark,
         ring: ring,
         cornerDots: cornerDots,
         squareRatio: squareRatio,
         dotRatio: dotRatio,
         motifRatio: motifRatio,
         mini: mini,
         radius: radius,
         semanticLabel: semanticLabel,
       );

  final ArtVariant variant;
  final double? tile;
  final Color? ground;
  final Color? motif;
  final Color? center;
  final CenterMark centerMark;
  final bool ring;
  final bool cornerDots;
  final double squareRatio;
  final double dotRatio;
  final double motifRatio;

  /// Small swatch version (chips): fewer details, like the design's 30 px swatches.
  final bool mini;

  /// Eight colours for ralli: TL a/b, TR a/b, BL a/b, BR a/b.
  final List<Color>? ralliColors;
  final Color? bandColor;
  final double bandHeight;
  final BorderRadius radius;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    Widget art = CustomPaint(painter: _ArtPainter(this), size: Size.infinite);
    if (radius != BorderRadius.zero) {
      art = ClipRRect(borderRadius: radius, child: art);
    }
    return Semantics(
      image: true,
      label: semanticLabel,
      excludeSemantics: semanticLabel == null,
      child: art,
    );
  }
}

class _ArtPainter extends CustomPainter {
  _ArtPainter(this.a);
  final ProductArt a;

  static const _madder = AppColors.madder;
  static const _indigo = AppColors.indigo;
  static const _gold = AppColors.artGold;
  static const _unb = AppColors.artUnbleached;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    switch (a.variant) {
      case ArtVariant.phulkari:
        _phulkari(canvas, size);
      case ArtVariant.ajrak:
        _ajrak(canvas, size);
      case ArtVariant.ralli:
        _ralli(canvas, size);
      case ArtVariant.bluePottery:
        _pottery(canvas, size);
      case ArtVariant.sindhi:
        _sindhi(canvas, size);
    }
    if (a.bandColor != null && a.bandHeight > 0) {
      canvas.drawRect(
        Rect.fromLTWH(0, size.height - a.bandHeight, size.width, a.bandHeight),
        Paint()..color = a.bandColor!,
      );
    }
  }

  Path _diamond(Offset c, double h) => Path()
    ..moveTo(c.dx, c.dy - h)
    ..lineTo(c.dx + h, c.dy)
    ..lineTo(c.dx, c.dy + h)
    ..lineTo(c.dx - h, c.dy)
    ..close();

  void _phulkari(Canvas canvas, Size size) {
    final ground = a.ground ?? _madder;
    final motif = a.motif ?? _gold;
    final center = a.center ?? ground;
    final t = a.tile ?? 22;
    canvas.drawRect(Offset.zero & size, Paint()..color = ground);
    final motifPaint = Paint()..color = motif;
    final centerPaint = Paint()..color = center;
    final ringPaint = Paint()
      ..color = _unb
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (double y = 0; y < size.height; y += t) {
      for (double x = 0; x < size.width; x += t) {
        final c = Offset(x + t / 2, y + t / 2);
        canvas.drawPath(_diamond(c, t * a.motifRatio), motifPaint);
        switch (a.centerMark) {
          case CenterMark.square:
            final s = t * 0.19;
            canvas.drawRect(
              Rect.fromCenter(center: c, width: s, height: s),
              centerPaint,
            );
          case CenterMark.circle:
            canvas.drawCircle(c, t * 0.114, centerPaint);
          case CenterMark.none:
            break;
        }
        if (a.ring) canvas.drawPath(_diamond(c, t * 0.2), ringPaint);
      }
    }
  }

  void _ajrak(Canvas canvas, Size size) {
    final ground = a.ground ?? _indigo;
    final motif = a.motif ?? _madder;
    final dot = a.center ?? _unb;
    final t = a.tile ?? 24;
    canvas.drawRect(Offset.zero & size, Paint()..color = ground);
    final motifPaint = Paint()..color = motif;
    final dotPaint = Paint()..color = dot;
    final half = t * a.squareRatio / math.sqrt2;
    for (double y = 0; y <= size.height + t; y += t) {
      for (double x = 0; x <= size.width + t; x += t) {
        final c = Offset(x + t / 2, y + t / 2);
        canvas.drawPath(_diamond(c, half), motifPaint);
        canvas.drawCircle(c, t * a.dotRatio, dotPaint);
        if (a.cornerDots) canvas.drawCircle(Offset(x, y), 2, dotPaint);
      }
    }
  }

  void _ralli(Canvas canvas, Size size) {
    final w = size.width / 2, h = size.height / 2;
    if (a.mini) {
      canvas.drawRect(Offset.zero & size, Paint()..color = _gold);
      final p = Path()
        ..moveTo(size.width, 0)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      canvas.drawPath(p, Paint()..color = _indigo);
      return;
    }
    final c =
        a.ralliColors ??
        const [
          _madder, _unb, // TL
          _indigo, _gold, // TR
          _gold, _indigo, // BL
          _unb, _madder, // BR
        ];
    for (var q = 0; q < 4; q++) {
      final x0 = (q % 2) * w, y0 = (q ~/ 2) * h;
      final upper = Path()
        ..moveTo(x0, y0)
        ..lineTo(x0 + w, y0)
        ..lineTo(x0, y0 + h)
        ..close();
      final lower = Path()
        ..moveTo(x0 + w, y0)
        ..lineTo(x0 + w, y0 + h)
        ..lineTo(x0, y0 + h)
        ..close();
      canvas.drawPath(upper, Paint()..color = c[q * 2]);
      canvas.drawPath(lower, Paint()..color = c[q * 2 + 1]);
    }
  }

  void _pottery(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = a.ground ?? _unb);
    final m = math.min(size.width, size.height);
    final c = Offset(size.width / 2, size.height / 2);
    final ink = a.motif ?? _indigo;
    final stroke = Paint()
      ..color = ink
      ..style = PaintingStyle.stroke;
    if (a.mini) {
      stroke.strokeWidth = m * 0.1;
      canvas.drawCircle(c, m * 0.267, stroke);
      return;
    }
    stroke.strokeWidth = m * 0.0625;
    canvas.drawCircle(c, m * 0.28125, stroke);
    stroke.strokeWidth = m * 0.047;
    final r = m * 0.21875;
    canvas.drawLine(Offset(c.dx, c.dy - r), Offset(c.dx, c.dy + r), stroke);
    canvas.drawLine(Offset(c.dx - r, c.dy), Offset(c.dx + r, c.dy), stroke);
    canvas.drawCircle(c, m * 0.078, Paint()..color = ink);
  }

  void _sindhi(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = a.ground ?? _unb);
    final k = size.width / 30;
    final path = Path()
      ..moveTo(4 * k, 15 * k)
      ..cubicTo(8 * k, 9 * k, 12 * k, 9 * k, 15 * k, 15 * k)
      ..cubicTo(18 * k, 21 * k, 22 * k, 21 * k, 26 * k, 15 * k);
    canvas.drawPath(
      path,
      Paint()
        ..color = a.motif ?? _madder
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * k,
    );
  }

  @override
  bool shouldRepaint(_ArtPainter old) => true;
}
