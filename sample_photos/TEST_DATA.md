# Test data for Hunar Bazaar

The 6 pictures in this folder are **generated craft-pattern illustrations** (not real photos), made for testing.
For the demo, real photos of real products give the best AI results.

## First run (new database)
The app adds 6 demo products to Firestore automatically when `listings` is empty
(you will see "Fresh from makers" filled on the home screen). Demo products have no WhatsApp button.

## Test 1: create a new seller account
1. Home -> **Sell** (Start selling) -> shop setup. Fields start **blank** (a new anonymous account is a new seller).
2. Enter:
   - Shop name: `Ayesha's Embroidery`
   - City: `Lahore`
   - WhatsApp: `03XX XXXXXXX`  (use YOUR OWN number so you can test the chat button)
3. Open my shop -> dashboard shows 0 products, 0 orders.

## Test 2: list a product (pick a picture from this folder)

| Picture | Shop idea | City | Materials (Rs) | Days (6 h/day) | What to expect |
|---|---|---|---|---|---|
| `1_phulkari_dupatta.jpg` | Rukhsana's Phulkari | Multan | 1200 | 3 | AI: embroidered dupatta; fair price about Rs 4,000-5,000 |
| `2_ajrak_shawl.jpg` | Zainab's Ajrak | Hyderabad | 1500 | 2 | AI: indigo/red printed shawl |
| `3_crochet_table_runner.jpg` | Farah's Crochet | Peshawar | 300 | 1 | AI: cream crochet runner; low price |
| `4_beaded_jewellery_set.jpg` | Hina's Beadwork | Islamabad | 450 | 1 | AI: beaded necklace + earrings; city multiplier higher |
| `5_ralli_quilt.jpg` | Sakina's Ralli | Karachi | 1800 | 5 | AI: patchwork quilt; high price (many hours) |
| `6_embroidered_cushion.jpg` | Nasreen's Embroidery | Lahore | 600 | 2 | AI: embroidered cushion cover |

Flow: Sell -> Add photo -> AI writes title + story (English and Urdu) -> change **materials** and **days** on the
price screen -> note the **"Market in <city>"** line -> publish.

## What to check
- The AI title/story describe the picture you chose (not always the phulkari dupatta).
- Price changes when you change materials or days; a "Market in <city>" line appears after a few seconds.
- After publishing, the product appears on the home screen and under "My products" on the dashboard.
- Open it: price range, "Why this price", and the WhatsApp button (only if you entered a number).
- Switch language (Urdu): the app flips to right-to-left.
- Run it a second time in a new browser profile / incognito: it is a new, empty seller account.

## Pricing formula
`fair = (materials + hours x Rs 150) x (1 + craft margin) x local-market multiplier`
Example: materials 1,000, 10 hours, margin 30% -> (1,000 + 1,500) x 1.30 = Rs 3,250, rounded to Rs 3,300.
