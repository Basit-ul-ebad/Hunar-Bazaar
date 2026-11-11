import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../l10n/l10n.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/dashed_border.dart';
import '../../widgets/product_art.dart';
import '../../widgets/step_header.dart';
import '../../widgets/step_progress.dart';
import 'listing_draft.dart';

/// L1 · Add photos (`/seller/new/photos`).
class AddPhotosScreen extends StatelessWidget {
  const AddPhotosScreen({super.key});

  Future<void> _add(BuildContext context, {required bool camera}) async {
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final room = ListingDraft.maxPhotos - listingDraft.photos.length;
    if (room <= 0) {
      messenger.showSnackBar(SnackBar(content: Text(l.maxPhotos)));
      return;
    }
    try {
      final picker = ImagePicker();
      final files = <XFile>[];
      if (camera) {
        final f = await picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 900,
          imageQuality: 70,
        );
        if (f != null) files.add(f);
      } else if (room == 1) {
        final f = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 900,
          imageQuality: 70,
        );
        if (f != null) files.add(f);
      } else {
        files.addAll(await picker.pickMultiImage(
          limit: room,
          maxWidth: 900,
          imageQuality: 70,
        ));
      }
      final bytes = <Uint8List>[for (final f in files) await f.readAsBytes()];
      listingDraft.addPhotos(bytes);
    } catch (_) {
      // Camera or gallery not available here (e.g. desktop): nothing to add.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: ListenableBuilder(
            listenable: listingDraft,
            builder: (context, _) => Column(
              children: [
                StepHeader(
                  title: l.stepPhotos,
                  leadingIcon: Icons.close,
                  leadingLabel: l.close,
                  onLeading: () => context.go('/seller'),
                ),
                const SizedBox(height: 14),
                const StepProgress(step: 1),
                const SizedBox(height: 14),
                const Expanded(child: _Viewfinder()),
                const SizedBox(height: 14),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    l.addUpTo,
                    style: AppText.dm(13, color: AppColors.muted),
                  ),
                ),
                const SizedBox(height: 8),
                const _Thumbs(),
                const SizedBox(height: 14),
                _Controls(
                  onGallery: () => _add(context, camera: false),
                  onShutter: () => _add(context, camera: true),
                  onNext: () => context.go('/seller/new/ai'),
                  galleryLabel: l.gallery,
                  shutterLabel: l.takePhoto,
                  nextLabel: l.next,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Viewfinder extends StatelessWidget {
  const _Viewfinder();

  @override
  Widget build(BuildContext context) {
    final photo = listingDraft.selected;
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox.expand(
        child: ColoredBox(
          color: const Color(0xFFEFE8DE),
          child: Stack(
            alignment: Alignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: SizedBox(
                  width: 300,
                  height: 340,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 250,
                        height: 290,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.ink.withValues(alpha: 0.12),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: photo != null
                            ? Image.memory(photo, fit: BoxFit.cover)
                            : const ProductArt(
                                variant: ArtVariant.phulkari,
                                tile: 26,
                                motifRatio: 0.385,
                                bandColor: AppColors.artGold,
                                bandHeight: 29,
                                semanticLabel:
                                    'Camera preview placeholder: a phulkari dupatta laid flat',
                              ),
                      ),
                      const IgnorePointer(
                        child: CustomPaint(
                          size: Size(300, 340),
                          painter: _BracketPainter(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    context.l10n.photoHint,
                    style: AppText.dm(13, weight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  const _BracketPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(4, 34)
      ..lineTo(4, 4)
      ..lineTo(34, 4)
      ..moveTo(266, 4)
      ..lineTo(296, 4)
      ..lineTo(296, 34)
      ..moveTo(296, 306)
      ..lineTo(296, 336)
      ..lineTo(266, 336)
      ..moveTo(34, 336)
      ..lineTo(4, 336)
      ..lineTo(4, 306);
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(_BracketPainter old) => false;
}

class _Thumbs extends StatelessWidget {
  const _Thumbs();

  @override
  Widget build(BuildContext context) {
    final photos = listingDraft.photos;
    return Row(
      children: [
        for (var i = 0; i < ListingDraft.maxPhotos; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          _slot(i, photos),
        ],
      ],
    );
  }

  Widget _slot(int i, List<Uint8List> photos) {
    final empty = photos.isEmpty;
    // Until a real photo is picked, the first slot shows the placeholder art.
    if (i < photos.length || (empty && i == 0)) {
      final selected = empty || i == listingDraft.selectedPhoto;
      return GestureDetector(
        onTap: empty ? null : () => listingDraft.selectPhoto(i),
        child: Semantics(
          image: true,
          label: 'Photo ${i + 1}',
          child: SizedBox(
            width: 56,
            height: 56,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: empty
                        ? const ProductArt(
                            variant: ArtVariant.phulkari,
                            tile: 14,
                            motifRatio: 0.357,
                            centerMark: CenterMark.none,
                          )
                        : Image.memory(photos[i], fit: BoxFit.cover),
                  ),
                ),
                if (selected)
                  Positioned(
                    left: -4,
                    top: -4,
                    right: -4,
                    bottom: -4,
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.madder, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }
    return const SizedBox(
      width: 56,
      height: 56,
      child: DashedBorder(radius: 8, child: SizedBox.expand()),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({
    required this.onGallery,
    required this.onShutter,
    required this.onNext,
    required this.galleryLabel,
    required this.shutterLabel,
    required this.nextLabel,
  });

  final VoidCallback onGallery, onShutter, onNext;
  final String galleryLabel, shutterLabel, nextLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _Side(
            label: galleryLabel,
            icon: Icons.image_outlined,
            onTap: onGallery,
            fill: Colors.white,
            border: AppColors.line,
            color: AppColors.ink,
            weight: FontWeight.w500,
          ),
          Semantics(
            button: true,
            label: shutterLabel,
            excludeSemantics: true,
            child: GestureDetector(
              onTap: onShutter,
              child: Container(
                width: 76,
                height: 76,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: AppColors.madder, spreadRadius: 4),
                  ],
                ),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: AppColors.madderTint,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          _Side(
            label: nextLabel,
            icon: Icons.arrow_forward_rounded,
            onTap: onNext,
            fill: AppColors.madderTint,
            border: Colors.transparent,
            color: AppColors.madder,
            weight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}

class _Side extends StatelessWidget {
  const _Side({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.fill,
    required this.border,
    required this.color,
    required this.weight,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color fill, border, color;
  final FontWeight weight;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: fill,
                shape: BoxShape.circle,
                border: Border.all(color: border),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.dm(12, weight: weight, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
