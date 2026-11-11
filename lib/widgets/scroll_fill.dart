import 'package:flutter/material.dart';

/// Scrolls when content is taller than the screen; otherwise lets a `Spacer`
/// push the last child (the primary button) to the bottom.
class ScrollFill extends StatelessWidget {
  const ScrollFill({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: box.maxHeight),
          child: IntrinsicHeight(child: child),
        ),
      ),
    );
  }
}
