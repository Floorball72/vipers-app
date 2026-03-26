// config.js — Stackflow Vereinsplattform
// ============================================================
// SUPABASE_ANON_KEY ist der öffentliche Schlüssel — OK im Frontend.
// Niemals service_role Keys hier eintragen!
// ============================================================

const APP_CONFIG = {
  SUPABASE_URL:      'https://kpskzbqrfvihxfynwvpv.supabase.co',
  SUPABASE_ANON_KEY: 'sb_publishable_eyDYEuo2aQKLLWX_0c8n-g_AttYd0La',
  APP_URL:           'https://vipers-app.vercel.app',
  SWISS_UH_API_KEY:  '',

  // Aktiver Verein (vorläufig nur Jonschwil)
  CLUBS: [
    {
      club_id:      'uhc-jonschwil',
      name:         'UHC Jonschwil Vipers',
      short:        'Vipers',
      swiss_uh_id:  692,
      primaryColor: '#d4f04a',
      gcal_id:      '5320809ae59397fe852db643253723db16d2292d8b38179e85d35af082623f8e@group.calendar.google.com',
    },
    // Weitere Vereine können hier hinzugefügt werden
  ],

  get ACTIVE_CLUB() {
    const stored = localStorage.getItem('vipers_active_club');
    return this.CLUBS.find(c => c.club_id === stored) || this.CLUBS[0];
  },
};
