# Hunar Bazaar

**Turning home-based women's skills into fair income, one photo at a time.**

Build with Google Hackathon (GDGoC CUI, CUI Tech Fest FA'26) · Domain: **Women's Empowerment**

## Problem

Millions of women in Pakistan earn from home through embroidery, stitching, handicrafts and home-cooked food.
Official labour-force data shows this work is growing: women in home-based work rose from 2.67 million (2013/14)
to 3.59 million (2017/18), and from 22% to 28% of women's employment. Yet:

1. **They don't know how to price their work.** Hours and material costs are not counted, and they accept what a middleman offers.
2. **They can't present it professionally.** Good photos, English/Urdu descriptions and a catalogue are barriers for women with limited literacy or digital skills.
3. **They depend on middlemen**, who keep most of the profit.

**Who is affected:** home-based women entrepreneurs and artisans across urban and rural Pakistan, especially those with limited literacy, little digital experience or restricted mobility.

## Solution

An AI-powered Flutter app (Android + Web) where **anyone can list a handmade product from a single photo** and **any buyer can browse and contact the maker directly**.

1. **Snap** a photo of the product.
2. **Gemini writes the listing** in English *and* Urdu (title and story) from the photo.
3. **A fair price is calculated** from her material cost and hours of work, plus a craft margin from the AI, adjusted for **her city's market** (Gemini + Google Search grounding, with a built-in city table as fallback). The app shows *why* the price is fair, so she can negotiate with confidence.
4. **Share** a catalogue card on WhatsApp and **publish** to the live marketplace (Cloud Firestore).
5. **Buyers browse** live listings and **message the maker on WhatsApp**: no middleman.

### Fair-price formula (code, not AI)

```
fair = (materials + hours x hourly rate) x (1 + craft margin) x local-market multiplier
```

The arithmetic is plain deterministic code. The AI only suggests the craft margin (clamped to 15-40%)
and the market multiplier (clamped to 0.85-1.25), so prices can never be wildly invented by a model.

## SDG alignment

- **SDG 5 Gender Equality** (primary): economic independence and equal opportunity for women, directly reachable buyers, digital inclusion in Urdu.
- **SDG 8 Decent Work and Economic Growth:** fair pay for informal home-based work; supports local small businesses.
- **SDG 1 No Poverty:** keeps the middleman's cut in the maker's pocket.

## Technology stack

| Layer | Technology |
|---|---|
| App | Flutter (one codebase for Android and Web), go_router, flutter_bloc, intl (English + Urdu, RTL) |
| AI | **Gemini** through **Firebase AI Logic** (`firebase_ai`): vision to read the product photo, JSON-structured bilingual listing text, **Google Search grounding** for local market prices |
| Models | `gemini-2.5-flash` (the app falls back to other Flash models if one is unavailable) |
| Backend | **Firebase**: Cloud Firestore (listings), Firebase Authentication (anonymous sign-in) |
| Contact | WhatsApp deep links (`url_launcher`), share cards (`share_plus`) |
| Dev tools | Claude (AI pair-programming), Google Cloud credits |

## Responsible AI

- **Disclosure:** the AI models and external services used are listed above. Every AI-generated price carries an "AI estimate, not a guarantee" note.
- **Not presented as fact:** AI output is an editable suggestion; the maker reviews the text and chooses her own final price within the suggested range.
- **Grounded, bounded pricing:** deterministic code does the cost math; AI adjustments are clamped.
- **Privacy:** no phone-number login or real-name requirement; only the shop name, city, optional WhatsApp number and product photos she chooses to publish are stored. No private datasets are used.
- **Limitations (prototype):** the hourly rate (Rs 150) is an assumption; market multipliers are estimates and Search results may be incomplete; Urdu text is machine-generated and should be reviewed by the maker; photos are stored inside Firestore documents (no Cloud Storage); Firestore runs in test mode; there is no in-app payment or order management yet.

## Run it

```
flutter pub get
flutter run -d chrome      # or an Android device
```

Firebase is already configured (`lib/firebase_options.dart`). In the Firebase console enable
Firestore, Authentication (Anonymous) and AI Logic (Gemini Developer API).

## Project layout

- `lib/features/` screens: buyer (home, product, storefront), listing flow (photos -> AI -> price -> preview), seller dashboard
- `lib/core/` Gemini listing service, market lookup, Firestore repository
- `lib/features/listing/pricing_calc.dart` the fair-price formula
- `design/`, `DESIGN.md` the design spec
