# UHC Jonschwil Vipers — Vereinsplattform

Vereins-Management-Tool für den UHC Jonschwil Vipers.

## Setup

1. Supabase URL und Key in `index.html` unter `CONFIG` eintragen
2. Auf Vercel deployen (siehe unten)

## Vercel Deployment

1. Dieses Repo auf GitHub pushen
2. Auf [vercel.com](https://vercel.com) einloggen
3. "Add New Project" → GitHub Repo auswählen
4. Deploy klicken — fertig

## Konfiguration

In `index.html` die `CONFIG`-Variable anpassen:

```js
const CONFIG = {
  SUPABASE_URL: 'https://kpskzbqrfvihxfynwvpv.supabase.co',
  SUPABASE_KEY: 'dein-anon-key',
  SWISS_UH_API_KEY: '',        // nach API-Key-Anfrage eintragen
  SWISS_UH_CLUB_ID: 692,
  GCAL_VIPERS_ID: '...',
};
```

## Module

- Social Media Planer (Phase 1 ✅)
- Spielplan & Teams (Phase 2)
- Statistiken & Scorer (Phase 3)
- Finanzen (Phase 3)
- Video & Training (Phase 4)
- Swiss Unihockey API (Phase 5)
