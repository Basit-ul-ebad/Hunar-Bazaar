import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/mock_data.dart';
import '../../l10n/l10n.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/choice_chip.dart';
import '../../widgets/dashed_border.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/product_art.dart';
import '../../widgets/scroll_fill.dart';
import '../../widgets/step_header.dart';
import 'start_selling_screen.dart' show boxFieldDecoration;

/// S2 · Shop setup (`/sell/setup`).
class ShopSetupScreen extends StatefulWidget {
  const ShopSetupScreen({super.key});

  @override
  State<ShopSetupScreen> createState() => _ShopSetupScreenState();
}

class _ShopSetupScreenState extends State<ShopSetupScreen> {
  final _shop = TextEditingController();
  final _city = TextEditingController();
  final _selected = <String>{'phulkari'};
  bool _other = false;
  Uint8List? _photo;
  bool _filled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_filled) return;
    _filled = true;
    final l = context.l10n;
    _shop.text = l.shopRukhsana;
    _city.text = l.cityMultanPunjab;
  }

  @override
  void dispose() {
    _shop.dispose();
    _city.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    try {
      final file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file == null) return;
      final bytes = await file.readAsBytes();
      if (mounted) setState(() => _photo = bytes);
    } catch (_) {
      // Picker unavailable (e.g. permission denied): leave the empty state.
    }
  }

  void _toggle(String name) => setState(() {
    if (!_selected.remove(name)) _selected.add(name);
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = MockText(l);
    return Scaffold(
      body: SafeArea(
        child: ScrollFill(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      label: l.back,
                      onTap: () => context.canPop()
                          ? context.pop()
                          : context.go('/sell'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(l.setUpShop, style: AppText.fraunces(22)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _Labeled(
                  label: l.shopName,
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      controller: _shop,
                      style: AppText.dm(16),
                      decoration: boxFieldDecoration(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l.yourCraft,
                  style: AppText.dm(13, weight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final c in setupCrafts)
                      AppChoiceChip(
                        label: t.craft(c.id),
                        selected: _selected.contains(c.id),
                        onTap: () => _toggle(c.id),
                        leading: ProductArt.spec(
                          c.art,
                          tile: 30,
                          centerMark: CenterMark.none,
                          squareRatio: 0.467,
                          dotRatio: 0.1,
                          motifRatio: 0.333,
                          mini: true,
                        ),
                      ),
                    AppChoiceChip(
                      label: l.craftOther,
                      selected: _other,
                      dashed: true,
                      onTap: () => setState(() => _other = !_other),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _Labeled(
                  label: l.cityLabel,
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      controller: _city,
                      style: AppText.dm(16),
                      decoration: boxFieldDecoration(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _UploadCard(photo: _photo, onTap: _pickPhoto),
                const SizedBox(height: 16),
                const Spacer(),
                PrimaryButton(
                  label: l.openMyShop,
                  onPressed: () => context.go('/seller'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Labeled extends StatelessWidget {
  const _Labeled({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: AppText.dm(13, weight: FontWeight.w700)),
      const SizedBox(height: 6),
      child,
    ],
  );
}

class _UploadCard extends StatelessWidget {
  const _UploadCard({required this.photo, required this.onTap});
  final Uint8List? photo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Semantics(
      button: true,
      label: l.addPhotoTitle,
      excludeSemantics: true,
      child: DashedBorder(
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    color: AppColors.indigoTint,
                    shape: BoxShape.circle,
                  ),
                  child: photo != null
                      ? Image.memory(
                          photo!,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                        )
                      : const Icon(
                          Icons.photo_camera_outlined,
                          size: 22,
                          color: AppColors.indigo,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.addPhotoTitle,
                        style: AppText.dm(14, weight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l.addPhotoHint,
                        style: AppText.dm(12, color: AppColors.muted),
                      ),
                    ],
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
