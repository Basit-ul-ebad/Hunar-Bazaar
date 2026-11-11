# Who edits what (avoids merge conflicts)

| Area | Files | Owner |
|---|---|---|
| App shell, Firebase, AI, pricing, data | `lib/main.dart`, `lib/app.dart`, `lib/core/*`, `firebase*`, `android/` | Basit |
| UI: look and feel | `lib/theme/*`, `lib/widgets/*` | UI partner |
| UI: screens | `lib/features/feed/*`, `lib/features/sell/*`, `lib/features/shop/*` | UI partner |

Rules
- Build screens against `lib/core/models.dart` and `lib/core/seed_data.dart` (fake data), not Firebase.
- Need a change in `lib/core/*`? Ask Basit instead of editing it.
- Always `git pull --rebase` before `git push`. Small commits, push often.
- Language: use `tr('English', 'اردو')` for every user-visible string.
