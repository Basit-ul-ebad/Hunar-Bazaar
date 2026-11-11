import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Keeps the visual size of [child] but makes the tap area at least 44 x 44.
class Tappable extends StatelessWidget {
  const Tappable({
    super.key,
    required this.child,
    required this.onTap,
    this.semanticLabel,
    this.radius,
  });

  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    return _HitSlop(
      minSize: 44,
      child: Semantics(
        button: true,
        label: semanticLabel,
        child: InkWell(onTap: onTap, borderRadius: radius, child: child),
      ),
    );
  }
}

class _HitSlop extends SingleChildRenderObjectWidget {
  const _HitSlop({required this.minSize, super.child});
  final double minSize;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderHitSlop(minSize);

  @override
  void updateRenderObject(BuildContext context, _RenderHitSlop renderObject) {
    renderObject.minSize = minSize;
  }
}

class _RenderHitSlop extends RenderProxyBox {
  _RenderHitSlop(this.minSize);
  double minSize;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    final dx = ((minSize - size.width) / 2).clamp(0.0, double.infinity);
    final dy = ((minSize - size.height) / 2).clamp(0.0, double.infinity);
    final area = (Offset.zero & size).inflate(0).deflate(0);
    final grown = Rect.fromLTRB(
      area.left - dx,
      area.top - dy,
      area.right + dx,
      area.bottom + dy,
    );
    if (!grown.contains(position)) return false;
    final clamped = Offset(
      position.dx.clamp(0.0, size.width - 0.01),
      position.dy.clamp(0.0, size.height - 0.01),
    );
    return super.hitTest(result, position: clamped);
  }
}
