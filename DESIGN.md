# Hunar Bazaar — UI Design Spec (Ajrak style)

Build target: **Flutter** (mobile, 390 × 844 reference frame). This file is the single source of truth for the UI. Match it exactly. Do not invent extra colours, fonts or screens.

Product: a bazaar where home-based Pakistani women sell handmade craft. Buyers browse and order on WhatsApp. Sellers list a product from one photo; AI (Gemini) writes the listing and helps set a fair price.

---

## 1. Design principles

1. It is a **public shop**, not a personal app. White surfaces, thin borders, product photos carry the colour.
2. Only two brand colours, both from Sindh's ajrak cloth: **madder red** = action, **indigo** = trust.
3. **One madder (filled) button per screen.** Everything else is outline or text.
4. Indigo only means trust: Verified maker, AI help, Live status, links.
5. Every product shows its **maker and city** ("by Rukhsana · Multan").
6. The **ajrak border strip** appears once per screen, at the top (under the header).
7. Urdu-ready: every screen must work in RTL with Noto Nastaliq Urdu.

---

## 2. Design tokens

### Colours (complete palette — nothing else in the UI chrome)

| Token | Hex | Use |
|---|---|---|
| `bg` | `#FAF7F2` | Page background ("cotton") |
| `surface` | `#FFFFFF` | Cards, app bars, bottom bars, sheets |
| `line` | `#E8E1D8` | Card borders, dividers |
| `lineSoft` | `#F0EAE2` | Dividers inside cards |
| `inputBorder` | `#CFC6BB` | Text field borders, dashed empty slots |
| `ink` | `#2B2422` | All primary text, outline-button borders |
| `muted` | `#6B615C` | Secondary text, inactive nav |
| `madder` | `#B94E36` | Primary button fill, active nav, progress, price on share card |
| `madderTint` | `#FBEDE7` | Selected chips, highlight cards, selected toggle |
| `madderSoft` | `#F2C9BC` | Price range band, past bars in chart |
| `indigo` | `#33568C` | Verified badge, links, AI label, Live badge text, info icons |
| `indigoTint` | `#EBF0F7` | Badge backgrounds (Live, Verified, AI note), voice buttons |

Product-art only (placeholders standing in for real photos, never UI chrome): madder `#B94E36`, indigo `#33568C`, gold `#E2B04A`, unbleached `#F5EFE6`, skin `#E9C9B8`.

Contrast (WCAG AA verified): white on madder 5.0:1 · ink on bg 14.3:1 · muted on bg 5.6:1 · indigo on indigoTint 6.4:1.

### Typography (google_fonts package)

| Role | Font | Size / weight |
|---|---|---|
| Display / screen titles | Fraunces | 22–27 sp, w600 |
| Big numbers (price, earnings) | Fraunces | 30–36 sp, w600 |
| Section headings | DM Sans | 15–16 sp, w700 |
| Body | DM Sans | 14–15 sp, w400, line height 1.5 |
| Labels / buttons | DM Sans | 13–17 sp, w700 |
| Captions | DM Sans | 12–13 sp, w400, `muted` |
| Stamp label "HANDMADE IN PAKISTAN" | DM Sans | 11–12 sp, w700, letter-spacing 0.6 |
| Urdu (all Urdu text) | Noto Nastaliq Urdu | ≥16 sp, line height 2.0 |

Logo wordmark: "Hunar Bazaar" in Fraunces 20–22 w600, colour `madder`.

### Shape & spacing

- Spacing grid 4/8. Screen horizontal padding **20**. Gap between sections 14–18.
- Radius: cards **12**, hero/highlight cards **14**, images inside cards 8–10, text fields **10**, buttons & chips **pill (999)**.
- Card style: `surface` fill + 1 px `line` border, no shadow. Only the share-card preview gets a soft shadow (0 8 24, ink at 8%).
- Touch targets ≥ 44 × 44. Primary button height 54, secondary 44–48.
- Icons: outline, 1.8–2 stroke, 20–22 size (use `lucide_icons` or Material Symbols Outlined).

### Motion (keep calm)

- 150 ms ease-out for taps/chips, 280 ms ease-out for page/sheet transitions.
- Progress bar segments fill with 280 ms ease-out.
- AI screen: the ajrak strip under the photo "prints" left→right as progress (animate its width).
- Respect `MediaQuery.disableAnimations`.

---

## 3. Shared components (build these first, in `lib/widgets/`)

1. **`AjrakBorder`** — full-width strip, height 10. White background; repeating 20 px tile: a madder diamond centred (points at x±3.5, y±3.5 around centre (10,5)) and indigo dots r=1.6 at x=0 and x=20 on the centre line. 1 px indigo line along top and bottom edges. Draw with `CustomPainter`. Optional `progress` (0–1): paint pattern only up to that width, rest `#F3EEE7`.
2. **`ProductArt`** (placeholder for photos) — `CustomPainter` with 4 variants:
   - `phulkari`: madder ground, tile 22–30 px, gold diamond, small madder square in the centre.
   - `ajrak`: indigo ground, madder square rotated 45°, unbleached dot r≈3 in centre, unbleached dots at tile corners.
   - `ralli`: 2×2 grid of squares each split diagonally into triangles (madder, unbleached, indigo, gold).
   - `bluePottery`: unbleached ground, indigo ring + cross + centre dot.
   Replace with `Image.network` when real photos exist.
3. **`MakerAvatar`** — circle (`madderTint` bg) with a simple faceless woman silhouette: madder dupatta over head and shoulders, skin-tone face circle. Sizes 36/44/48/76. Optional initial letter variant (indigo on indigoTint).
4. **`PrimaryButton`** — pill, height 54, `madder` fill, white DM Sans 17 w700, optional leading icon.
5. **`SecondaryButton`** — pill, height 44–48, white fill, 1 px `ink` border, ink text w700.
6. **`AppCard`** — surface, 1 px line border, radius 12, padding 12.
7. **`StepProgress`** — 4 segments, height 4, radius 2, gap 4; done = madder, todo = line.
8. **`StepHeader`** — [44 circle back/close button: white, 1 px line border] · centered "Step N of 4 · Label" (14 w700) · trailing slot (44).
9. **`ProductCard`** — card (radius 12, border, clip); image 150 h; padding 10: title 14 w500 (2 lines), price 16 w700, "by Name · City" 12 muted.
10. **`Badge`** variants: `live` (indigoTint bg, indigo text, pill), `verified` ("✓ Verified maker", indigo text), `stamp` ("HANDMADE IN PAKISTAN", indigo text, 1 px indigo border, radius 4), `ai` ("AI", indigo 11 w700).
11. **`ChoiceChip`** — pill height 44; unselected white + 1 px line; selected madderTint fill + 1.5 px madder border + w700. Optional 30 px round leading swatch (ProductArt mini).
12. **`LanguageToggle`** — pill group, white with 1 px line, 3 px padding; options "اردو" (Nastaliq) and "English"/"EN"; selected = madderTint bg.
13. **`BuyerBottomNav`** — height 68, white, top 1 px line. Tabs: Explore (home), Makers (person), Saved (heart), Sell (store). Active = madder icon + w700 label; inactive muted.
14. **`SellerBottomNav`** — same style. Tabs: Home, Listings (grid), Orders (bag), My shop (store).
15. **`FieldCard`** — AppCard holding a label row (13 w700 + optional `ai` badge on the right) and an input with no border.

---

## 4. Screens (14 + style guide). Build in this order.

Sample data used everywhere: maker **Rukhsana Bibi**, shop **"Rukhsana's Phulkari"**, **Multan, Punjab**; product **"Phulkari dupatta, hand-embroidered on khaddar"**, **Rs 5,000**; second maker **Zainab · Hala** with **"Ajrak shawl, block-printed" Rs 3,200**.

### Buyer side

**B1 · Bazaar Home** (`/`) — bg.
1. White header (padding 16/20): left column = wordmark + "HANDMADE IN PAKISTAN" (12, muted, spaced); right = 44 round "Saved" heart button (1 px line).
2. Search field: height 48, pill, fill `#F3EEE7`, search icon, hint "Search phulkari, ajrak, ralli…".
3. `AjrakBorder`.
4. Hero card (madderTint, radius 14, padding 16): left = Fraunces 20 "Buy directly from the women who make it" + link "Meet the makers →" (madder, 14 w700); right = 96×96 ProductArt phulkari (radius 10).
5. "Shop by craft" (16 w700) + row of 4: 64 circle ProductArt (phulkari, ajrak, ralli, bluePottery) with label below (13 w500).
6. "New from makers" + "See all" link (indigo). 2-column grid of `ProductCard` (gap 12): Rukhsana's phulkari dupatta, Zainab's ajrak shawl.
7. `BuyerBottomNav` (Explore active).

**B2 · Product page** (`/product/:id`) — white.
1. Full-width image 330 h (ProductArt phulkari) with overlays: 44 white circle back (top-left 16), 44 white circle save (top-right), "1 / 4" pill (bottom-right, white, 12 w700).
2. Padding 16/20: Fraunces 22 title; row: "Rs 5,000" (24 w700) + "★ 4.9 · 32 reviews" (13 muted).
3. Outline chips (1 px line, pill, 13 w500): "Hand-embroidered", "18 hours of work", "Cash on delivery".
4. Maker card (bg `#FAF7F2`, radius 12, padding 12): MakerAvatar 48 · column ["Made by" 12 muted, "Rukhsana Bibi · Multan" 15 w700, verified line 12 w700 indigo with seal icon: "Verified maker · 22 years of phulkari"] · chevron. Taps → storefront.
5. "The story" (15 w700) + paragraph (14, 1.55).
6. Sticky bottom bar (white, top line, padding 12/20/20): left column ["Rs 5,000" 18 w700, "Delivery in 3–5 days" 12 muted]; right = PrimaryButton "Order on WhatsApp" (chat icon, height 52, expanded).

**B3 · Maker storefront** (`/maker/:id`) — bg.
1. Cover 96 h: madderTint with faint diamond lattice (madder 35% stroke + indigo 35% dot, 32 px tile). Back button overlay.
2. White section: MakerAvatar 76 overlapping the cover by 38 with 4 px white ring; Fraunces 24 "Rukhsana's Phulkari"; "Hand embroidery · Multan, Punjab" (14 muted); row 13: "✓ Verified maker" (indigo w700) · "★ 4.9 (32)" · "58 sold".
3. Two buttons in a row: PrimaryButton "Message on WhatsApp" (height 44) + SecondaryButton "Follow shop".
4. Voice-note card (bg, radius 12): 40 indigo circle play button + quote 13 sp: "My mother taught me phulkari when I was ten. Every piece carries her stitches." + "· 0:15" muted.
5. Tabs (white, bottom line): "Products · 12" (active, 2 px madder underline), "Reviews", "About".
6. 2-column grid of compact product cards (image 120 h, title 13 w500, price 15 w700): Phulkari dupatta Rs 5,000 · Bagh cushion cover Rs 1,800 · Phulkari shawl Rs 7,500 · Embroidered potli Rs 900.

### Seller side — start

**S1 · Start selling** (`/sell`) — bg, padding 16/20/24.
1. Row: wordmark (20) left, `LanguageToggle` right (English selected).
2. Collage 220 h, grid 2fr/1fr, gap 8, radius 12: big phulkari tile (spans 2 rows), ajrak tile, ralli tile.
3. Fraunces 27 "Sell your craft to all of Pakistan" + Urdu line (Nastaliq 17, RTL, muted): "اپنا ہنر پورے پاکستان تک پہنچائیں".
4. Three numbered rows (28 circle indigoTint with indigo number): "One photo makes your listing" · "We help you set a fair price" · "Buyers order on WhatsApp".
5. Phone field: label "Phone number"; "+92" box (white, line border, radius 10, 52 h) + input "300 1234567".
6. PrimaryButton "Start selling" (bottom).

**S2 · Shop setup** (`/sell/setup`) — bg.
1. Back button + Fraunces 22 "Set up your shop".
2. Field "Shop name" (50 h, radius 10, inputBorder): "Rukhsana's Phulkari".
3. "Your craft" — wrap of `ChoiceChip`s with mini swatches: Phulkari (selected), Ajrak, Ralli, Sindhi embroidery, Blue pottery, "+ Other" (dashed border).
4. Field "City": "Multan, Punjab".
5. Dashed upload card: 44 indigoTint circle camera icon + "Add a photo of you or your hands at work" (14 w700) + "Optional. Buyers trust shops with a maker photo." (12 muted).
6. PrimaryButton "Open my shop".

**S3 · Seller dashboard** (`/seller`) — bg.
1. White header: MakerAvatar 44 · ["Assalam-o-alaikum, Rukhsana" 13 muted, "Rukhsana's Phulkari" Fraunces 18] · "View shop" link.
2. `AjrakBorder`.
3. 3 stat cards in a row (AppCard): This month **Rs 12,400** · Orders **5** · Shop views **340** (label 12 muted, value 18 w700).
4. Add-product card (madderTint, radius 14): 48 madder circle with white "+" · ["Add a new product" 16 w700, "One photo, about 2 minutes" 13 muted]. Taps → L1.
5. "Buyers waiting for you" + "2 new" (madder 12 w700). Card with 2 rows (divider lineSoft): 36 indigoTint initial avatar · [name+city 14 w700, message 13 muted] · outline pill "Reply" (36 h). Rows: Ayesha · Lahore — "Is the phulkari dupatta available?"; Sana · Karachi — "Can you make it in green?".
6. "Your listings" + "See all 12". Row card: 52 thumbnail · ["Phulkari dupatta" 14 w700, "Rs 5,000 · 86 views" 13 muted] · Live badge.
7. `SellerBottomNav` (Home active).

### Seller side — list a product (4 steps)

**L1 · Add photos** (`/seller/new/photos`) — bg. StepHeader (close icon, "Step 1 of 4 · Photos") + StepProgress(1).
1. Viewfinder (expanded, `#EFE8DE`, radius 14): product preview 250×290 (ProductArt phulkari, soft shadow) with white corner brackets (4 px stroke); bottom pill hint (white, 13 w700): "Daylight · lay it flat · show the whole piece".
2. Caption (13 muted): "Add up to 5 photos: whole piece, close-up of stitches, worn or in use". Row of 56 thumbnails: first filled (2 px madder outline, offset 2), three dashed empty slots.
3. Controls row: Gallery (48 white circle) · Shutter (76 white circle, 4 px madder ring, inner 60 madderTint) · Next (48 madderTint circle, madder arrow, label "Next" madder w700).

**L2 · AI writing the listing** (`/seller/new/ai`) — bg. StepProgress(1).
1. Centered card 260 wide (white, border, radius 14, clip): photo 220 h + `AjrakBorder(progress: animated)`.
2. Fraunces 24 "Writing your listing…" + Urdu "آپ کی لسٹنگ تیار ہو رہی ہے" (16, muted).
3. Checklist card (3 rows, 48 h, dividers): done = indigo filled circle with white check — "Found: phulkari dupatta, khaddar cotton"; active = dashed madder circle, w700 — "Writing the title and story in Urdu & English"; pending = grey ring, muted — "Getting your price ready".
4. Footer caption: "Written by Gemini AI · you can change everything next" + link "Skip and write it myself".
5. On success → L3 automatically.

**L3 · Review listing** (`/seller/new/details`) — bg. StepHeader (back, "Step 2 of 4 · Details", trailing compact LanguageToggle "اردو | EN") + StepProgress(2).
1. Info note (indigoTint, radius 10, indigo 13): [white "AI" chip] "Fields marked AI were written for you. Tap to change."
2. FieldCard "Title" (AI): "Phulkari dupatta, hand-embroidered on khaddar" (16 w500).
3. Row card "Category" → "Phulkari › Dupattas" + chevron.
4. FieldCard "The story" (AI), 4-line textarea + text buttons (indigo 13 w700): "↻ Write again", "▶ Listen".
5. Details card (rows 40 h, label muted left, value w500 right): Material — Khaddar cotton, silk thread · Technique — Hand embroidery (bagh) · Size — 2.5 m × 1 m.
6. PrimaryButton "Next: set the price".

**L4 · Fair price** (`/seller/new/price`) — bg. StepHeader (back, "Step 3 of 4 · Price", trailing 44 indigoTint mic button) + StepProgress(3).
1. Two input cards side by side: "Materials cost" input "Rs 1,200" (+ caption "Cloth + thread"); "Time spent" stepper [− "3 days" +] (+ caption "18 hours of work").
2. Price card (white, border, radius 14, padding 16): header "What your work is worth" + "AI-ASSISTED" (indigo 11 w700); Fraunces 36 "Rs 5,100"; range track (8 h, `#F3EEE7`) with madderSoft band 10%–90% and a 20 px madder thumb (3 px white border) at 50%; labels "Low · Rs 4,500" / "Fair" / "High · Rs 5,500"; divider; breakdown rows (14): Materials Rs 1,200 · "Your time · 18 h × Rs 150" Rs 2,700 · Hand-embroidery value + 30%; text button "▶ Listen to why".
3. Your-price card: ["Your price" 14 w700, "You always decide" 12 muted] + input 130 wide, 1.5 px madder border, "Rs 5,000" 18 w700.
4. PrimaryButton "Next: preview".
- Price logic (code, not AI): `fair = (materials + hours × hourlyRate) × (1 + craftMargin)`; low = 0.88 × fair, high = 1.08 × fair, rounded to nearest Rs 100. hourlyRate default Rs 150 (editable in settings). craftMargin from Gemini, clamped 15–40%.

**L5 · Preview & share** (`/seller/new/preview`) — bg. StepHeader ("Step 4 of 4 · Preview") + StepProgress(4).
1. "Your WhatsApp catalog card" (15 w700).
2. Share card, 310 wide, centered (white, border, radius 12, soft shadow): AjrakBorder · image 230 h · padding 12/14: Fraunces 17 title; row [price 20 w700 **madder**, stamp badge "HANDMADE IN PAKISTAN"]; "By Rukhsana · Multan · Order on WhatsApp" (13 muted). Render this widget to PNG (RepaintBoundary) for sharing.
3. Message card: label "Message" + "New in my shop: hand-embroidered phulkari dupatta, Rs 5,000. Cash on delivery across Pakistan. Reply to order."
4. PrimaryButton "Publish & share on WhatsApp" (chat icon) → share_plus with image + text; SecondaryButton "Publish to the Bazaar only".

**L6 · Live in the Bazaar** (`/seller/new/done`) — bg. AjrakBorder at very top.
1. 72 indigoTint circle with 48 indigo circle + white check.
2. Fraunces 26 "Your dupatta is live" + Urdu "آپ کا دوپٹہ بازار میں آ گیا ہے" + "Buyers can now find it in the Bazaar and on WhatsApp." (14 muted).
3. Listing row card (64 thumb, name, price, Live badge).
4. Shop link card: ["Your shop link" 12 muted, "Rukhsana's Phulkari" 14 w700] + outline "Copy link".
5. "Get your first order faster" + 3 numbered tips (number in madder w700): Share the card in 3 WhatsApp groups · Add a close-up photo of the stitches · Record a 15-second "meet the maker" note.
6. PrimaryButton "Add another product" + text link "Back to dashboard".

### Seller side — operations

**O1 · Orders & earnings** (`/seller/orders`) — bg.
1. White header: Fraunces 24 "Orders"; tabs "New · 2" (active), "To send · 1", "Delivered · 12".
2. Earnings card: ["Earned in November" 12 muted, Fraunces 30 "Rs 12,400"] + "All time · Rs 58,300" (13 muted); 6-bar mini chart (bars madderSoft, last bar madder, radius 3); caption "Cash on delivery · you receive the money from the courier".
3. Order cards: 52 thumb · [item 14 w700, "Buyer · City · when" 13 muted] · price 15 w700; below, 2 buttons: SecondaryButton "Chat on WhatsApp" + tonal (madderTint) "Accept order". Data: Phulkari dupatta — Ayesha · Lahore · today — Rs 5,000; Bagh cushion cover — Mehreen · Islamabad · yesterday — Rs 1,800.
4. `SellerBottomNav` (Orders active).

**U1 · Dashboard in Urdu** — same as S3 with `Directionality(rtl)`, Nastaliq everywhere (line height 2.0), numbers/prices stay in DM Sans. Strings: السلام علیکم، رخسانہ · رخسانہ کی پھلکاری · دکان دیکھیں · اس مہینے · آرڈر · دکان کے وزٹ · نیا سامان شامل کریں · ایک تصویر، تقریباً 2 منٹ · خریدار آپ کا انتظار کر رہے ہیں · 2 نئے · عائشہ · لاہور · کیا پھلکاری دوپٹہ دستیاب ہے؟ · جواب دیں · ثنا · کراچی · کیا یہ سبز رنگ میں بن سکتا ہے؟ · Nav: ہوم · لسٹنگز · آرڈر · میری دکان.

---

## 5. Navigation map

```
B1 Bazaar ──► B2 Product ──► B3 Storefront
   └─ "Sell" tab ─► S1 Start ─► S2 Setup ─► S3 Dashboard
S3 "Add a new product" ─► L1 Photos ─► L2 AI ─► L3 Details ─► L4 Price ─► L5 Preview ─► L6 Live ─► S3
S3 nav: Home(S3) · Listings(B3 own) · Orders(O1) · My shop(B3 own)
```

## 6. Flutter implementation notes

- Packages: `google_fonts`, `go_router`, `flutter_localizations` + `intl` (en, ur), `share_plus`, `image_picker`, `camera` (optional; image_picker is enough for MVP), `flutter_svg` not needed (CustomPainter).
- State: start with mock data in `lib/data/mock_data.dart`; Cubit (flutter_bloc) per feature later. Firebase (Auth, Firestore, Storage, Firebase AI Logic for Gemini) is a later phase — keep repositories behind interfaces.
- Theme: one `AppColors`, `AppText`, `AppTheme` (Material 3, `useMaterial3: true`, seeded off but colours set explicitly; scaffold bg = bg).
- Folders: `lib/theme/`, `lib/widgets/`, `lib/features/{buyer,seller_onboarding,listing,orders}/`, `lib/router.dart`, `lib/data/`.
- No status-bar mockups; use SafeArea.
- Accessibility: Semantics labels on icon buttons; text scale up to 1.3 must not overflow (use Flexible/Wrap).
