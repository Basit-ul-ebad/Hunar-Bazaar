import 'package:flutter/material.dart';
import '../l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

class NavItem {
  const NavItem(this.icon, this.label);
  final IconData icon;
  final String label;
}

/// Shared bottom bar: 68 high, white, 1 px top line.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.items,
    required this.current,
    required this.onSelected,
    this.urdu = false,
    this.minItemWidth = 64,
  });

  final List<NavItem> items;
  final int current;
  final ValueChanged<int> onSelected;
  final bool urdu;
  final double minItemWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var i = 0; i < items.length; i++)
                  Flexible(
                    child: _Item(
                      item: items[i],
                      active: i == current,
                      urdu: urdu,
                      minWidth: minItemWidth,
                      onTap: () => onSelected(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.item,
    required this.active,
    required this.urdu,
    required this.minWidth,
    required this.onTap,
  });

  final NavItem item;
  final bool active;
  final bool urdu;
  final double minWidth;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.madder : AppColors.muted;
    final weight = active ? FontWeight.w700 : FontWeight.w400;
    return Semantics(
      button: true,
      selected: active,
      label: item.label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 0, minHeight: 44),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.icon, size: 22, color: color),
              const SizedBox(height: 3),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: urdu
                    ? AppText.urdu(
                        12,
                        weight: weight,
                        color: color,
                        height: 1.4,
                      )
                    : AppText.dm(12, weight: weight, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Explore · Makers · Saved · Sell.
class BuyerBottomNav extends StatelessWidget {
  const BuyerBottomNav({
    super.key,
    required this.current,
    required this.onSelected,
  });

  final int current;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BottomNavBar(
      items: [
        NavItem(Icons.home_outlined, l.navExplore),
        NavItem(Icons.person_outline, l.navMakers),
        NavItem(Icons.favorite_border, l.navSaved),
        NavItem(Icons.storefront_outlined, l.navSell),
      ],
      current: current,
      onSelected: onSelected,
    );
  }
}
