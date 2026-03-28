-- ============================================================
-- STACKFLOW — Vollständiges DB-Setup
-- ============================================================
-- ANLEITUNG:
--   1. Dieses Script im Supabase SQL Editor einfügen
--   2. Auf "Run" klicken
--   3. Am Ende steht: "Setup erfolgreich abgeschlossen"
--
-- ⚠️  ACHTUNG: Löscht alle bestehenden Tabellen und Daten!
-- ============================================================

-- ── SCHRITT 1: Alles löschen ─────────────────────────────────
drop table if exists inventar_ausleihen     cascade;
drop table if exists inventar               cascade;
drop table if exists sponsor_leistungen     cascade;
drop table if exists sponsoren              cascade;
drop table if exists anwesenheit            cascade;
drop table if exists news                   cascade;
drop table if exists mitgliedsausweise      cascade;
drop table if exists videoanalysen          cascade;
drop table if exists trainingseinheiten     cascade;
drop table if exists scorer                 cascade;
drop table if exists social_posts           cascade;
drop table if exists finanzen               cascade;
drop table if exists events                 cascade;
drop table if exists games                  cascade;
drop table if exists players                cascade;
drop table if exists user_club_memberships  cascade;
drop table if exists user_profiles          cascade;
drop table if exists teams                  cascade;
drop table if exists clubs                  cascade;

-- ── SCHRITT 2: Tabellen erstellen ────────────────────────────

-- Vereine
create table clubs (
  club_id       text primary key,
  name          text not null,
  short_name    text,
  swiss_uh_id   integer,
  primary_color text default '#d4f04a',
  gcal_id       text,
  aktiv         boolean default true,
  created_at    timestamptz default now()
);

-- User-Profile (id = eigene UUID, auth_user_id = Supabase Auth Link)
create table user_profiles (
  id            uuid primary key default gen_random_uuid(),
  auth_user_id  uuid unique references auth.users(id) on delete set null,
  club_id       text references clubs(club_id) on delete set null,
  vorname       text not null default '',
  nachname      text not null default '',
  email         text,
  telefon       text,
  adresse       text,
  geburtsdatum  date,
  foto_url      text,
  rolle         text default 'spieler'
                  check (rolle in ('admin','trainer','spieler','eltern')),
  team_ids      uuid[],
  aktiv         boolean default true,
  login_status  text default 'pending'
                  check (login_status in ('pending','invited','active')),
  mitglied_seit date default current_date,
  created_at    timestamptz default now()
);

-- Vereinsmitgliedschaft
create table user_club_memberships (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid references user_profiles(id) on delete cascade,
  club_id       text references clubs(club_id) on delete cascade,
  rolle         text default 'spieler'
                  check (rolle in ('admin','trainer','spieler','eltern')),
  mitglied_seit date default current_date,
  aktiv         boolean default true,
  created_at    timestamptz default now(),
  unique(user_id, club_id)
);

-- Teams
create table teams (
  id              uuid primary key default gen_random_uuid(),
  club_id         text references clubs(club_id) on delete cascade,
  name            text not null,
  liga            text,
  saison          text default '2024/25',
  trainingszeiten text,
  trainingsort    text,
  aktiv           boolean default true,
  created_at      timestamptz default now()
);

-- Spieler
create table players (
  id                uuid primary key default gen_random_uuid(),
  club_id           text references clubs(club_id) on delete cascade,
  team_id           uuid references teams(id) on delete set null,
  user_id           uuid references auth.users(id) on delete set null,
  vorname           text not null,
  nachname          text not null,
  nummer            integer,
  position          text,
  email             text,
  telefon           text,
  geburtsdatum      date,
  trikot_shirt      text,
  trikot_hose       text,
  trikot_stuelpengr text,
  aktiv             boolean default true,
  created_at        timestamptz default now()
);

-- Spiele
create table games (
  id             uuid primary key default gen_random_uuid(),
  club_id        text references clubs(club_id) on delete cascade,
  team_id        uuid references teams(id) on delete set null,
  gegner         text not null,
  datum          date not null,
  anstoss        time default '17:00',
  heimspiel      boolean default true,
  spielkategorie text default 'saison'
                   check (spielkategorie in ('saison','cup','friendly')),
  ort            text,
  resultat_heim  integer,
  resultat_gast  integer,
  kamera         boolean default false,
  notizen        text,
  swiss_uh_id    text,
  created_at     timestamptz default now()
);

-- Events
create table events (
  id           uuid primary key default gen_random_uuid(),
  club_id      text references clubs(club_id) on delete cascade,
  titel        text not null,
  beschreibung text,
  datum        date not null,
  uhrzeit      time,
  end_datum    date,
  ort          text,
  typ          text default 'event'
                 check (typ in ('event','cup','turnier','gv','training')),
  team_ids     uuid[],
  todos        jsonb default '[]'::jsonb,
  created_at   timestamptz default now()
);

-- News
create table news (
  id           uuid primary key default gen_random_uuid(),
  club_id      text references clubs(club_id) on delete cascade,
  titel        text not null,
  inhalt       text,
  typ          text default 'info'
                 check (typ in ('info','wichtig','training','spiel','event')),
  team_ids     uuid[],
  gepinnt      boolean default false,
  bild_url     text,
  erstellt_von uuid references auth.users(id) on delete set null,
  created_at   timestamptz default now()
);

-- Social Media Posts
create table social_posts (
  id           uuid primary key default gen_random_uuid(),
  club_id      text references clubs(club_id) on delete cascade,
  typ          text not null check (typ in ('vorschau','resultat','event','info')),
  woche_datum  date not null,
  geplant_fuer timestamptz not null,
  status       text default 'geplant'
                 check (status in ('geplant','erledigt','uebersprungen')),
  canva_link   text,
  text_entwurf text,
  plattformen  text[] default array['instagram','facebook'],
  created_at   timestamptz default now()
);

-- Scorer / Statistiken
create table scorer (
  id           uuid primary key default gen_random_uuid(),
  club_id      text references clubs(club_id) on delete cascade,
  player_id    uuid references players(id) on delete cascade,
  game_id      uuid references games(id) on delete set null,
  tore         integer default 0,
  assists      integer default 0,
  strafminuten integer default 0,
  saison       text default '2024/25',
  created_at   timestamptz default now(),
  unique nulls not distinct (player_id, game_id)
);

-- Anwesenheit
create table anwesenheit (
  id             uuid primary key default gen_random_uuid(),
  club_id        text references clubs(club_id) on delete cascade,
  player_id      uuid references players(id) on delete cascade,
  team_id        uuid references teams(id) on delete set null,
  game_id        uuid references games(id) on delete set null,
  event_id       uuid references events(id) on delete set null,
  training_datum date,
  typ            text default 'training'
                   check (typ in ('training','spiel','event')),
  status         text default 'offen'
                   check (status in ('anwesend','abwesend','entschuldigt','offen')),
  notiz          text,
  created_at     timestamptz default now()
);

-- Finanzen
create table finanzen (
  id           uuid primary key default gen_random_uuid(),
  club_id      text references clubs(club_id) on delete cascade,
  typ          text not null check (typ in ('einnahme','ausgabe')),
  betrag       numeric(10,2) not null,
  konto        text default 'Allgemein',
  kategorie    text,
  beschreibung text,
  beleg_url    text,
  datum        date not null,
  created_at   timestamptz default now()
);

-- Sponsoren
create table sponsoren (
  id            uuid primary key default gen_random_uuid(),
  club_id       text references clubs(club_id) on delete cascade,
  firmenname    text not null,
  kontaktperson text,
  email         text,
  telefon       text,
  website       text,
  logo_url      text,
  kategorie     text,
  betrag_jahr   numeric(10,2),
  vertrag_start date,
  vertrag_ende  date,
  status        text default 'aktiv'
                  check (status in ('aktiv','inaktiv','verhandlung')),
  notizen       text,
  created_at    timestamptz default now()
);

create table sponsor_leistungen (
  id           uuid primary key default gen_random_uuid(),
  club_id      text references clubs(club_id) on delete cascade,
  sponsor_id   uuid references sponsoren(id) on delete cascade,
  beschreibung text not null,
  erledigt     boolean default false,
  created_at   timestamptz default now()
);

-- Inventar
create table inventar (
  id                uuid primary key default gen_random_uuid(),
  club_id           text references clubs(club_id) on delete cascade,
  name              text not null,
  kategorie         text default 'Sonstiges',
  anzahl_total      integer default 1,
  anzahl_verfuegbar integer default 1,
  zustand           text default 'gut'
                      check (zustand in ('neu','gut','gebraucht','defekt')),
  lagerort          text,
  foto_url          text,
  anschaffungspreis numeric(10,2),
  created_at        timestamptz default now()
);

create table inventar_ausleihen (
  id                uuid primary key default gen_random_uuid(),
  inventar_id       uuid references inventar(id) on delete cascade,
  player_id         uuid references players(id) on delete set null,
  ausgegeben_am     date default current_date,
  zurueck_bis       date,
  zurueckgegeben_am date,
  mietpreis         numeric(10,2),
  bezahlt           boolean default false,
  notizen           text,
  created_at        timestamptz default now()
);

-- Training
create table trainingseinheiten (
  id           uuid primary key default gen_random_uuid(),
  club_id      text references clubs(club_id) on delete cascade,
  team_id      uuid references teams(id) on delete set null,
  titel        text not null,
  beschreibung text,
  kategorie    text,
  video_url    text,
  dauer_min    integer,
  trainer      text,
  created_at   timestamptz default now()
);

create table videoanalysen (
  id           uuid primary key default gen_random_uuid(),
  club_id      text references clubs(club_id) on delete cascade,
  game_id      uuid references games(id) on delete set null,
  titel        text not null,
  kategorie    text,
  video_url    text,
  notizen      text,
  tags         text[],
  erstellt_von text,
  created_at   timestamptz default now()
);

-- Mitgliedsausweise
create table mitgliedsausweise (
  id          uuid primary key default gen_random_uuid(),
  club_id     text references clubs(club_id) on delete cascade,
  user_id     uuid references auth.users(id) on delete cascade,
  ausgestellt date default current_date,
  gueltig_bis date,
  aktiv       boolean default true,
  created_at  timestamptz default now()
);

-- ── SCHRITT 3: Indexes ───────────────────────────────────────
create index on games(club_id, datum);
create index on players(club_id, team_id);
create index on players(user_id);
create index on players(email);
create index on scorer(club_id, player_id);
create index on finanzen(club_id, datum desc);
create index on news(club_id);
create index on teams(club_id);
create index on user_profiles(club_id);
create index on user_profiles(auth_user_id);
create index on user_profiles(email);
create index on anwesenheit(club_id, training_datum);

-- ── SCHRITT 4: Row Level Security ────────────────────────────
alter table clubs                 enable row level security;
alter table user_profiles         enable row level security;
alter table user_club_memberships enable row level security;
alter table teams                 enable row level security;
alter table players               enable row level security;
alter table games                 enable row level security;
alter table events                enable row level security;
alter table news                  enable row level security;
alter table social_posts          enable row level security;
alter table scorer                enable row level security;
alter table anwesenheit           enable row level security;
alter table finanzen              enable row level security;
alter table sponsoren             enable row level security;
alter table sponsor_leistungen    enable row level security;
alter table inventar              enable row level security;
alter table inventar_ausleihen    enable row level security;
alter table trainingseinheiten    enable row level security;
alter table videoanalysen         enable row level security;
alter table mitgliedsausweise     enable row level security;

-- Öffentlich lesbar (auch ohne Login)
create policy "p_clubs_r"   on clubs   for select using (true);
create policy "p_teams_r"   on teams   for select using (true);
create policy "p_games_r"   on games   for select using (true);
create policy "p_players_r" on players for select using (true);
create policy "p_news_r"    on news    for select using (true);

-- Voller Zugriff für alle (App nutzt anon-key, Sicherheit via App-Logik)
-- Für Produktion: Policies auf auth.uid() einschränken
create policy "p_profiles"    on user_profiles         for all using (true) with check (true);
create policy "p_memberships" on user_club_memberships for all using (true) with check (true);
create policy "p_events"      on events                for all using (true) with check (true);
create policy "p_posts"       on social_posts          for all using (true) with check (true);
create policy "p_scorer"      on scorer                for all using (true) with check (true);
create policy "p_anw"         on anwesenheit           for all using (true) with check (true);
create policy "p_finanzen"    on finanzen              for all using (true) with check (true);
create policy "p_sponsor"     on sponsoren             for all using (true) with check (true);
create policy "p_sponlei"     on sponsor_leistungen    for all using (true) with check (true);
create policy "p_inventar"    on inventar              for all using (true) with check (true);
create policy "p_invausl"     on inventar_ausleihen    for all using (true) with check (true);
create policy "p_training"    on trainingseinheiten    for all using (true) with check (true);
create policy "p_video"       on videoanalysen         for all using (true) with check (true);
create policy "p_ausweise"    on mitgliedsausweise     for all using (true) with check (true);
create policy "p_teams_w"     on teams                 for all using (true) with check (true);
create policy "p_games_w"     on games                 for all using (true) with check (true);
create policy "p_players_w"   on players               for all using (true) with check (true);
create policy "p_clubs_w"     on clubs                 for all using (true) with check (true);
create policy "p_news_w"      on news                  for all using (true) with check (true);

-- ── SCHRITT 5: Demo-Daten ─────────────────────────────────────
insert into clubs (club_id, name, short_name, swiss_uh_id, primary_color) values
  ('uhc-jonschwil', 'UHC Jonschwil Vipers', 'Vipers', 692, '#d4f04a');

insert into teams (club_id, name, liga, trainingszeiten, trainingsort) values
  ('uhc-jonschwil', 'UHC Jonschwil Vipers 1. Liga',  '1. Liga Gr.3', 'Di+Do 20:00', 'Sporthalle Jonschwil'),
  ('uhc-jonschwil', 'UHC Jonschwil Vipers 2. Liga',  '2. Liga',      'Mo+Mi 19:30', 'Sporthalle Jonschwil'),
  ('uhc-jonschwil', 'UHC Jonschwil Junioren U18',    'Junioren A',   'Sa 10:00',    'Sporthalle Jonschwil'),
  ('uhc-jonschwil', 'UHC Jonschwil Junioren U15',    'Junioren B',   'Sa 08:30',    'Sporthalle Jonschwil');

insert into news (club_id, titel, inhalt, typ, gepinnt) values
  ('uhc-jonschwil', 'Willkommen bei Stackflow!', 'Alle Vereinsdaten zentral verwalten.', 'info', true);

-- ── Fertig! ───────────────────────────────────────────────────

-- ── SCHRITT 6: Storage Bucket ────────────────────────────────
-- Bucket "stackflow" für alle Uploads (Belege, Videos, Logos, Fotos)
-- WICHTIG: Supabase führt Storage-Policies nicht via SQL aus.
-- Bitte manuell im Supabase Dashboard:
--   Storage → New bucket → Name: "stackflow" → Public: ON
--   (Public ON damit Dateien ohne Auth gelesen werden können)
--
-- Alternativ via SQL (falls Storage-Extension aktiv):
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'stackflow', 
  'stackflow', 
  true,
  524288000,  -- 500 MB
  array['image/jpeg','image/png','image/webp','image/svg+xml',
        'application/pdf',
        'video/mp4','video/quicktime','video/webm']
)
on conflict (id) do update set
  public = true,
  file_size_limit = 524288000;

-- Storage Policy: alle dürfen hochladen und lesen
insert into storage.policies (name, bucket_id, definition)
values (
  'stackflow_open',
  'stackflow',
  '{"statement":"allow all","version":"1"}'
)
on conflict do nothing;


select
  (select count(*) from clubs)      as vereine,
  (select count(*) from teams)      as teams,
  (select count(*) from news)       as news_eintraege,
  '✓ Setup erfolgreich abgeschlossen!' as status;
