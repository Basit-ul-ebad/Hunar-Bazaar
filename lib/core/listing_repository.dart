import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../features/listing/listing_draft.dart';
import 'seller_profile.dart';

/// A published product as stored in Firestore `listings/{id}`. OWNER: Basit.
class LiveListing {
  const LiveListing({
    required this.id,
    required this.sellerId,
    required this.sellerName,
    required this.sellerWhatsapp,
    required this.city,
    required this.titleEn,
    required this.titleUr,
    required this.storyEn,
    required this.storyUr,
    required this.price,
    required this.priceLow,
    required this.priceHigh,
    required this.materials,
    required this.hours,
    required this.margin,
    required this.market,
    required this.marketNoteEn,
    required this.marketNoteUr,
    required this.imageB64,
    required this.createdAt,
  });

  final String id;
  final String sellerId;
  final String sellerName;
  final String sellerWhatsapp;
  final String city;
  final String titleEn;
  final String titleUr;
  final String storyEn;
  final String storyUr;
  final int price;
  final int priceLow;
  final int priceHigh;
  final int materials;
  final int hours;
  final double margin;
  final double market;
  final String marketNoteEn;
  final String marketNoteUr;
  final String? imageB64;
  final DateTime createdAt;

  factory LiveListing.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? <String, dynamic>{};
    int i(dynamic v) => (v as num?)?.round() ?? 0;
    double f(dynamic v) => (v as num?)?.toDouble() ?? 1.0;
    String s(dynamic v) => (v ?? '').toString();
    return LiveListing(
      id: d.id,
      sellerId: s(m['sellerId']),
      sellerName: s(m['sellerName']),
      sellerWhatsapp: s(m['sellerWhatsapp']),
      city: s(m['city']),
      titleEn: s(m['titleEn']),
      titleUr: s(m['titleUr']),
      storyEn: s(m['storyEn']),
      storyUr: s(m['storyUr']),
      price: i(m['price']),
      priceLow: i(m['priceLow']),
      priceHigh: i(m['priceHigh']),
      materials: i(m['materials']),
      hours: i(m['hours']),
      margin: f(m['margin']),
      market: f(m['market']),
      marketNoteEn: s(m['marketNoteEn']),
      marketNoteUr: s(m['marketNoteUr']),
      imageB64: m['imageB64'] as String?,
      createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

class ListingRepository {
  CollectionReference<Map<String, dynamic>> get _col =>
      FirebaseFirestore.instance.collection('listings');

  /// Saves the draft as a live listing. The photo is stored as base64 inside the
  /// document (no Cloud Storage), so photos must be small: add_photos resizes them.
  Future<String> publish(ListingDraft d) async {
    final s = d.suggestion;
    String? img;
    final photo = d.selected;
    if (photo != null) {
      final b64 = base64Encode(photo);
      if (b64.length < 900000) {
        img = b64;
      } else {
        debugPrint('Photo too large for Firestore (${b64.length} chars); publishing without it');
      }
    }
    final ref = await _col
        .add({
          'sellerId': FirebaseAuth.instance.currentUser?.uid ?? 'anonymous',
          'sellerName': sellerProfile.shopName,
          'sellerWhatsapp': sellerProfile.whatsapp,
          'city': cityKey(sellerProfile.city),
          'titleEn': d.titleEn,
          'titleUr': d.titleUr,
          'storyEn': d.storyEn,
          'storyUr': d.storyUr,
          'price': d.userPrice,
          'priceFair': s.fair,
          'priceLow': s.low,
          'priceHigh': s.high,
          'materials': d.materials,
          'hours': d.hours,
          'margin': s.margin,
          'market': d.market,
          'marketNoteEn': d.marketNoteEn,
          'marketNoteUr': d.marketNoteUr,
          'imageB64': img,
          'status': 'active',
          'createdAt': FieldValue.serverTimestamp(),
        })
        .timeout(const Duration(seconds: 20));
    return ref.id;
  }

  /// Live feed of active listings, newest first.
  Stream<List<LiveListing>> watchAll({int limit = 30}) => _col
      .orderBy('createdAt', descending: true)
      .limit(limit)
      .snapshots()
      .map((q) => [
            for (final d in q.docs)
              if ((d.data()['status'] ?? 'active') == 'active')
                LiveListing.fromDoc(d),
          ]);

  Future<LiveListing?> get(String id) async {
    final d = await _col.doc(id).get();
    return d.exists ? LiveListing.fromDoc(d) : null;
  }
}

final ListingRepository listingRepository = ListingRepository();
