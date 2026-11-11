import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Four segments, 4 px tall. Done = madder, todo = line.
class StepProgress extends StatelessWidget {
  const StepProgress({super.key, required this.step, this.total = 4});

  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Step $step of $total',
      child: Row(
        children: [
          for (var i = 0; i < total; i++) ...[
            if (i > 0) const SizedBox(width: 4),
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOut,
                height: 4,
                decoration: BoxDecoration(
                  color: i < step ? AppColors.madder : AppColors.line,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
