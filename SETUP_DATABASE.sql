-- ============================================================
-- Vereins-Plattform — VOLLSTÄNDIGES RESET & SETUP
-- Unterstützt mehrere Vereine via club_id
-- ⚠️  Löscht ALLES und erstellt von Grund auf neu
-- ============================================================

-- ── 1. Alles löschen ──────────────────────────────────────
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
drop table if exists teams                  cascade;
drop table if exists user_club_memberships  cascade;
drop table if exists user_profiles          cascade;
drop table if exists clubs                  cascade;

-- ── 2. Vereine (Stammdaten) ────────────────────────────────
create table clubs (
  club_id     text primary key,           -- z.B. 'uhc-jonschwil'
  name        text not null,
  short_name  text,
  swiss_uh_id integer,
  primary_color text default '#d4f04a',
  gcal_id     text,
  aktiv       boolean default true,
  created_at  timestamptz default now()
);

-- Demo-Daten Vereine
insert into clubs (club_id, name, short_name, swiss_uh_id, primary_color) values
  ('uhc-jonschwil',    'UHC Jonschwil Vipers', 'Vipers',     692, '#d4f04a'),
  ('united-toggenburg','United Toggenburg',    'United TG',  771, '#5bbfff');

-- ── 3. User-Profile ────────────────────────────────────────
create table user_profiles (
  id            uuid primary key references auth.users(id) on delete cascade,
  vorname       text not null,
  nachname      text not null,
  email         text,
  telefon       text,
  geburtsdatum  date,
  foto_url      text,
  aktiv         boolean default true,
  created_at    timestamptz default now()
);

-- ── 4. User ↔ Verein Zuordnung (pro Verein eigene Rolle) ──
create table user_club_memberships (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid references user_profiles(id) on delete cascade,
  club_id       text references clubs(club_id) on delete cascade,
  rolle         text default 'spieler'
                  check (rolle in ('admin','trainer','spieler','eltern')),
  team_ids      uuid[],
  kind_ids      uuid[],
  mitglied_seit date default current_date,
  mitglied_bis  date,
  aktiv         boolean default true,
  created_at    timestamptz default now(),
  unique(user_id, club_id)
);

-- ── 5. Teams ───────────────────────────────────────────────
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

-- ── 6. Spieler ─────────────────────────────────────────────
create table players (
  id            uuid primary key default gen_random_uuid(),
  club_id       text references clubs(club_id) on delete cascade,
  team_id       uuid references teams(id) on delete cascade,
  user_id       uuid references auth.users(id) on delete set null,
  vorname       text not null,
  nachname      text not null,
  nummer        integer,
  position      text,
  email         text,
  telefon       text,
  geburtsdatum  date,
  aktiv         boolean default true,
  created_at    timestamptz default now()
);

-- ── 7. Spiele ──────────────────────────────────────────────
create table games (
  id            uuid primary key default gen_random_uuid(),
  club_id       text references clubs(club_id) on delete cascade,
  team_id       uuid references teams(id) on delete cascade,
  gegner        text not null,
  datum         date not null,
  anstoss       time not null default '17:00',
  heimspiel     boolean default true,
  liga          text,
  ort           text,
  resultat_heim integer,
  resultat_gast integer,
  kamera        boolean default false,
  notizen       text,
  swiss_uh_id   text,
  google_cal_id text,
  created_at    timestamptz default now()
);

-- ── 8. Events ──────────────────────────────────────────────
create table events (
  id            uuid primary key default gen_random_uuid(),
  club_id       text references clubs(club_id) on delete cascade,
  titel         text not null,
  beschreibung  text,
  datum         date not null,
  uhrzeit       time,
  end_datum     date,
  end_uhrzeit   time,
  ort           text,
  typ           text default 'event'
                  check (typ in ('event','cup','turnier','gv','training')),
  team_ids      uuid[],
  todos         jsonb default '[]'::jsonb,
  google_cal_id text,
  created_at    timestamptz default now()
);

-- ── 9. News ────────────────────────────────────────────────
create table news (
  id            uuid primary key default gen_random_uuid(),
  club_id       text references clubs(club_id) on delete cascade,
  titel         text not null,
  inhalt        text,
  typ           text default 'info'
                  check (typ in ('info','wichtig','training','spiel','event')),
  zielgruppe    text[] default array['alle'],
  team_ids      uuid[],
  gepinnt       boolean default false,
  bild_url      text,
  erstellt_von  uuid references auth.users(id) on delete set null,
  erstellt_am   timestamptz default now(),
  created_at    timestamptz default now()
);

-- ── 10. Social Media Posts ─────────────────────────────────
create table social_posts (
  id            uuid primary key default gen_random_uuid(),
  club_id       text references clubs(club_id) on delete cascade,
  typ           text not null check (typ in ('vorschau','resultat','event','info')),
  woche_datum   date not null,
  geplant_fuer  timestamptz not null,
  status        text default 'geplant'
                  check (status in ('geplant','erledigt','uebersprungen')),
  canva_link    text,
  text_entwurf  text,
  plattformen   text[] default array['instagram','facebook'],
  google_cal_id text,
  created_at    timestamptz default now()
);

-- ── 11. Scorer ─────────────────────────────────────────────
create table scorer (
  id            uuid primary key default gen_random_uuid(),
  club_id       text references clubs(club_id) on delete cascade,
  player_id     uuid references players(id) on delete cascade,
  game_id       uuid references games(id) on delete cascade,
  tore          integer default 0,
  assists       integer default 0,
  strafminuten  integer default 0,
  saison        text default '2024/25',
  created_at    timestamptz default now(),
  unique(player_id, game_id)
);

-- ── 12. Anwesenheit ────────────────────────────────────────
create table anwesenheit (
  id             uuid primary key default gen_random_uuid(),
  club_id        text references clubs(club_id) on delete cascade,
  player_id      uuid references players(id) on delete cascade,
  team_id        uuid references teams(id) on delete cascade,
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

-- ── 13. Finanzen ───────────────────────────────────────────
create table finanzen (
  id            uuid primary key default gen_random_uuid(),
  club_id       text references clubs(club_id) on delete cascade,
  game_id       uuid references games(id) on delete set null,
  event_id      uuid references events(id) on delete set null,
  typ           text not null check (typ in ('einnahme','ausgabe')),
  betrag        numeric(10,2) not null,
  kategorie     text,
  beschreibung  text,
  beleg_url     text,
  datum         date not null,
  konto         text default 'Allgemein',  -- Kontobezeichnung (Cup, Saison etc.)
  erstellt_von  uuid references auth.users(id) on delete set null,
  created_at    timestamptz default now()
);

-- ── 14. Sponsoren ──────────────────────────────────────────
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
  id            uuid primary key default gen_random_uuid(),
  sponsor_id    uuid references sponsoren(id) on delete cascade,
  beschreibung  text not null,
  typ           text,
  erledigt      boolean default false,
  faellig_am    date,
  created_at    timestamptz default now()
);

-- ── 15. Inventar ───────────────────────────────────────────
create table inventar (
  id                uuid primary key default gen_random_uuid(),
  club_id           text references clubs(club_id) on delete cascade,
  name              text not null,
  kategorie         text,
  anzahl_total      integer default 1,
  anzahl_verfuegbar integer default 1,
  zustand           text default 'gut'
                      check (zustand in ('neu','gut','gebraucht','defekt')),
  lagerort          text,
  foto_url          text,
  anschaffungsdatum date,
  anschaffungspreis numeric(10,2),
  notizen           text,
  created_at        timestamptz default now()
);

create table inventar_ausleihen (
  id                   uuid primary key default gen_random_uuid(),
  inventar_id          uuid references inventar(id) on delete cascade,
  player_id            uuid references players(id) on delete set null,
  ausgegeben_am        date default current_date,
  zurueck_bis          date,
  zurueckgegeben_am    date,
  notizen              text,
  created_at           timestamptz default now()
);

-- ── 16. Training & Video ───────────────────────────────────
create table trainingseinheiten (
  id            uuid primary key default gen_random_uuid(),
  club_id       text references clubs(club_id) on delete cascade,
  team_id       uuid references teams(id) on delete cascade,
  titel         text not null,
  beschreibung  text,
  kategorie     text,
  video_url     text,
  datum         date,
  dauer_min     integer,
  trainer       text,
  created_at    timestamptz default now()
);

create table videoanalysen (
  id            uuid primary key default gen_random_uuid(),
  club_id       text references clubs(club_id) on delete cascade,
  game_id       uuid references games(id) on delete set null,
  titel         text not null,
  video_url     text,
  notizen       text,
  tags          text[],
  sichtbar_fuer text[] default array['trainer','admin'],
  erstellt_von  uuid references auth.users(id) on delete set null,
  created_at    timestamptz default now()
);

-- ── 17. Mitgliedsausweise ──────────────────────────────────
create table mitgliedsausweise (
  id            uuid primary key default gen_random_uuid(),
  club_id       text references clubs(club_id) on delete cascade,
  user_id       uuid references auth.users(id) on delete cascade,
  ausgestellt   date default current_date,
  gueltig_bis   date,
  aktiv         boolean default true,
  created_at    timestamptz default now()
);

-- ── Indexes ────────────────────────────────────────────────
create index on games(club_id, datum);
create index on players(club_id, team_id);
create index on players(user_id);
create index on scorer(club_id, player_id);
create index on anwesenheit(club_id, training_datum);
create index on news(club_id, erstellt_am desc);
create index on finanzen(club_id, datum desc);
create index on user_club_memberships(user_id, club_id);
create index on teams(club_id);

-- ── RLS aktivieren ─────────────────────────────────────────
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

-- ── RLS Policies ───────────────────────────────────────────
-- Vereine: öffentlich lesbar
create policy "clubs_public_read"   on clubs   for select using (true);
create policy "clubs_auth_write"    on clubs   for all    using (auth.role() = 'authenticated');

-- Spielplan, Teams, Spieler: öffentlich lesbar
create policy "teams_public_read"   on teams   for select using (true);
create policy "games_public_read"   on games   for select using (true);
create policy "players_public_read" on players for select using (true);

-- Alle anderen: nur eingeloggte User
create policy "auth_all_events"       on events              for all using (auth.role() = 'authenticated');
create policy "auth_all_news"         on news                for all using (auth.role() = 'authenticated');
create policy "auth_all_posts"        on social_posts        for all using (auth.role() = 'authenticated');
create policy "auth_all_scorer"       on scorer              for all using (auth.role() = 'authenticated');
create policy "auth_all_anw"          on anwesenheit         for all using (auth.role() = 'authenticated');
create policy "auth_all_finanzen"     on finanzen            for all using (auth.role() = 'authenticated');
create policy "auth_all_sponsoren"    on sponsoren           for all using (auth.role() = 'authenticated');
create policy "auth_all_sponlei"      on sponsor_leistungen  for all using (auth.role() = 'authenticated');
create policy "auth_all_inventar"     on inventar            for all using (auth.role() = 'authenticated');
create policy "auth_all_invausl"      on inventar_ausleihen  for all using (auth.role() = 'authenticated');
create policy "auth_all_training"     on trainingseinheiten  for all using (auth.role() = 'authenticated');
create policy "auth_all_video"        on videoanalysen       for all using (auth.role() = 'authenticated');
create policy "auth_all_ausweise"     on mitgliedsausweise   for all using (auth.role() = 'authenticated');
create policy "auth_all_teams_write"  on teams               for all using (auth.role() = 'authenticated');
create policy "auth_all_games_write"  on games               for all using (auth.role() = 'authenticated');
create policy "auth_all_players_write"on players             for all using (auth.role() = 'authenticated');

-- User-Profile: nur eigenes
create policy "own_profile"     on user_profiles           for all using (auth.uid() = id);
create policy "own_memberships" on user_club_memberships   for all using (auth.uid() = user_id);

-- ── Demo-Daten ─────────────────────────────────────────────
-- UHC Jonschwil Teams
insert into teams (club_id, name, liga, trainingszeiten, trainingsort) values
  ('uhc-jonschwil','UHC Jonschwil Vipers 1. Liga', '1. Liga Gr.3','Di+Do 20:00','Sporthalle Jonschwil'),
  ('uhc-jonschwil','UHC Jonschwil Vipers 2. Liga', '2. Liga',     'Mo+Mi 19:30','Sporthalle Jonschwil'),
  ('uhc-jonschwil','UHC Jonschwil Junioren U18',   'Junioren A',  'Sa 10:00',  'Sporthalle Jonschwil'),
  ('uhc-jonschwil','UHC Jonschwil Junioren U15',   'Junioren B',  'Sa 08:30',  'Sporthalle Jonschwil');

-- United Toggenburg Teams
insert into teams (club_id, name, liga, trainingszeiten, trainingsort) values
  ('united-toggenburg','United Toggenburg 1. Liga', '1. Liga','Di+Fr 20:00','Toggenburg'),
  ('united-toggenburg','United Toggenburg Damen',   'Damen NLA','Mo+Mi 19:00','Toggenburg'),
  ('united-toggenburg','United Toggenburg U18',     'Junioren A','Sa 10:00', 'Toggenburg');

-- Demo-News pro Verein
insert into news (club_id, titel, inhalt, typ, gepinnt) values
  ('uhc-jonschwil',    'Willkommen bei UHC Jonschwil Vipers!','Alle Infos hier.','info',true),
  ('united-toggenburg','Willkommen bei United Toggenburg!',  'Alle Infos hier.','info',true);
-- ============================================================
