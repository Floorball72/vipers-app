// config.js — Stackflow Vereinsplattform
const APP_CONFIG = {
  SUPABASE_URL:      'https://codalrrehqlwygzewxiy.supabase.co',
  SUPABASE_ANON_KEY: 'sb_publishable_dF2IJ0Ai2xBmUABkaP5_YQ_W1KkzF-5',
  APP_URL:           'https://vipers-app.vercel.app',
  SWISS_UH_API_KEY:  '',

  CLUB_ID:      'uhc-jonschwil',
  CLUB_NAME:    'UHC Jonschwil Vipers',
  CLUB_SHORT:   'Vipers',
  CLUB_COLOR:   '#d4f04a',
  SWISS_UH_ID:  692,
  GCAL_ID:      '5320809ae59397fe852db643253723db16d2292d8b38179e85d35af082623f8e@group.calendar.google.com',

  get ACTIVE_CLUB() {
    return {
      name:         this.CLUB_NAME,
      short:        this.CLUB_SHORT,
      primaryColor: this.CLUB_COLOR,
      swiss_uh_id:  this.SWISS_UH_ID,
      gcal_id:      this.GCAL_ID};
  },
  get CLUBS() { return [this.ACTIVE_CLUB]; }};
