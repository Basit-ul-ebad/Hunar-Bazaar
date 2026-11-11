import 'dart:convert';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

IconData categoryIcon(String category) {
  switch (category) {
    case 'Embroidery':
      return Icons.brush;
    case 'Stitching':
      return Icons.checkroom;
    case 'Food':
      return Icons.restaurant;
    case 'Jewellery':
      return Icons.diamond;
    case 'Home Decor':
      return Icons.chair;
    default:
      return Icons.handyman;
  }
}

/// Shows the product photo (base64) or a category placeholder when there is none.
/// OWNER: UI partner.
class ListingImage extends StatelessWidget {
  final String? imageB64;
  final String category;
  const ListingImage({super.key, required this.imageB64, required this.category});

  @override
  Widget build(BuildContext context) {
    final data = imageB64;
    if (data != null && data.isNotEmpty) {
      return Image.memory(
        base64Decode(data),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.sand, AppColors.saffronSoft],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(categoryIcon(category), size: 48, color: AppColors.saffron),
    );
  }
}
