import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// Text tabs with a 2 px madder underline on the active one (storefront, orders).
class UnderlineTabs extends StatelessWidget {
  const UnderlineTabs({
    super.key,
    required this.tabs,
    required this.selected,
    required this.onSelected,
    this.height = 44,
  });

  final List<String> tabs;
  final int selected;
  final ValueChanged<int> onSelected;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++) ...[
            if (i > 0) const SizedBox(width: 22),
            Semantics(
              button: true,
              selected: i == selected,
              label: tabs[i],
              excludeSemantics: true,
              child: InkWell(
                onTap: () => onSelected(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  height: height,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: i == selected
                            ? AppColors.madder
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text.rich(
                    AppText.mixed(
                      tabs[i],
                      AppText.dm(
                        14,
                        weight: i == selected
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: i == selected ? AppColors.ink : AppColors.muted,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
