import 'package:flutter/material.dart';
import '../../core/cities.dart';
import '../../core/lang.dart';
import '../../core/models.dart';
import '../../core/seed_data.dart';
import '../../widgets/listing_card.dart';
import 'listing_detail_screen.dart';

/// Buyer feed: browse everything for sale. OWNER: UI partner.
/// TODO(partner): polish layout; category chips; search.
/// TODO(Basit): swap `seedListings` for the Firestore stream once Firebase is configured.
class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  String? _city; // null = all
  String? _category; // null = all

  @override
  Widget build(BuildContext context) {
    final items = seedListings
        .where((l) => _city == null || l.city == _city)
        .where((l) => _category == null || l.category == _category)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('Hunar Bazaar', 'ہنر بازار')),
        actions: [
          TextButton(
            onPressed: () => isUrdu.value = !isUrdu.value,
            child: Text(isUrdu.value ? 'English' : 'اردو'),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                for (final c in kCategories)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: ChoiceChip(
                      label: Text(c),
                      selected: _category == c,
                      onSelected: (s) => setState(() => _category = s ? c : null),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: DropdownButtonFormField<String?>(
              initialValue: _city,
              decoration: InputDecoration(
                labelText: tr('City', 'شہر'),
                isDense: true,
              ),
              items: [
                DropdownMenuItem<String?>(value: null, child: Text(tr('All cities', 'تمام شہر'))),
                for (final c in kCityNames) DropdownMenuItem<String?>(value: c, child: Text(c)),
              ],
              onChanged: (v) => setState(() => _city = v),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                mainAxisExtent: 340,
              ),
              itemCount: items.length,
              itemBuilder: (context, i) => ListingCard(
                listing: items[i],
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ListingDetailScreen(listing: items[i]),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
