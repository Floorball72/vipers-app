-- ============================================================
-- UHC Jonschwil Vipers — Schema Update v2
-- Neue Module: Rollen/Auth, Mitglieder, Sponsoring, Anwesenheit, Inventar, News
-- Im Supabase SQL Editor ausführen
-- ============================================================

-- 1. User Profiles (verknüpft mit Supabase Auth)
create table if not exists user_profiles (
  id           uuid primary key references auth.users(id) on delete cascade,
  vorname      text,
  nachname     text,
  email        text,
  telefon      text,
  geburtsdatum date,
  adresse      text,
  foto_url     text,
  rolle        text default 'spieler' check (rolle in ('admin','trainer','spieler','eltern')),
  team_ids     uuid[],          -- Welche Teams dieser User betreut/spielt
  kind_ids     uuid[],          -- Für Eltern: Spieler-IDs der Kinder
  aktiv        boolean default true,
  mitglied_seit date default current_date,
  mitglied_bis date,
  mitglied_nr  serial,
  notizen      text,
  created_at   timestamptz default now()
);

-- 2. Mitgliedskarten (digitale Ausweise)
create table if not exists mitgliedsausweise (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid references user_profiles(id) on delete cascade,
  ausgestellt  date default current_date,
  gueltig_bis  date,
  qr_code      text,            -- QR-Code Inhalt
  aktiv        boolean default true,
  created_at   timestamptz default now()
);

-- 3. Anwesenheit
create table if not exists anwesenheit (
  id           uuid primary key default gen_random_uuid(),
  player_id    uuid references players(id) on delete cascade,
  game_id      uuid references games(id) on delete set null,
  event_id     uuid references events(id) on delete set null,
  training_datum date,
  typ          text check (typ in ('training','spiel','event')),
  status       text default 'anwesend' check (status in ('anwesend','abwesend','entschuldigt','offen')),
  notiz        text,
  created_at   timestamptz default now()
);

-- 4. Sponsoren
create table if not exists sponsoren (
  id           uuid primary key default gen_random_uuid(),
  firmenname   text not null,
  kontaktperson text,
  email        text,
  telefon      text,
  website      text,
  logo_url     text,
  kategorie    text,            -- Hauptsponsor, Partner, Gönner
  betrag_jahr  numeric(10,2),
  vertrag_start date,
  vertrag_ende  date,
  status       text default 'aktiv' check (status in ('aktiv','inaktiv','verhandlung')),
  notizen      text,
  created_at   timestamptz default now()
);

-- 5. Sponsoren-Leistungen (was bekommt der Sponsor?)
create table if not exists sponsor_leistungen (
  id           uuid primary key default gen_random_uuid(),
  sponsor_id   uuid references sponsoren(id) on delete cascade,
  beschreibung text not null,
  typ          text,            -- Logo, Trikot, Banner, Social-Post
  erledigt     boolean default false,
  faellig_am   date,
  created_at   timestamptz default now()
);

-- 6. Inventar
create table if not exists inventar (
  id           uuid primary key default gen_random_uuid(),
  name         text not null,
  kategorie    text,            -- Trikots, Bälle, Ausrüstung, Sonstiges
  anzahl_total integer default 1,
  anzahl_verfuegbar integer default 1,
  zustand      text default 'gut' check (zustand in ('neu','gut','gebraucht','defekt')),
  lagerort     text,
  anschaffungsdatum date,
  anschaffungspreis numeric(10,2),
  notizen      text,
  created_at   timestamptz default now()
);

-- 7. Inventar Ausleihen
create table if not exists inventar_ausleihen (
  id           uuid primary key default gen_random_uuid(),
  inventar_id  uuid references inventar(id) on delete cascade,
  player_id    uuid references players(id),
  ausgegeben_am date default current_date,
  zurueck_bis  date,
  zurueckgegeben_am date,
  zustand_rueckgabe text,
  notizen      text,
  created_at   timestamptz default now()
);

-- 8. Newsfeed / Ankündigungen
create table if not exists news (
  id           uuid primary key default gen_random_uuid(),
  titel        text not null,
  inhalt       text,
  typ          text default 'info' check (typ in ('info','wichtig','training','spiel','event')),
  zielgruppe   text[] default array['alle'],  -- alle, admin, trainer, spieler, eltern
  team_ids     uuid[],
  gepinnt      boolean default false,
  bild_url     text,
  erstellt_von uuid references user_profiles(id),
  erstellt_am  timestamptz default now(),
  created_at   timestamptz default now()
);

-- ── RLS Policies für neue Tabellen ──
alter table user_profiles enable row level security;
alter table mitgliedsausweise enable row level security;
alter table anwesenheit enable row level security;
alter table sponsoren enable row level security;
alter table sponsor_leistungen enable row level security;
alter table inventar enable row level security;
alter table inventar_ausleihen enable row level security;
alter table news enable row level security;

-- Temporär offene Policies (werden nach Login-Implementation spezifiziert)
create policy if not exists "Anon lesen" on user_profiles for all using (true);
create policy if not exists "Anon lesen" on mitgliedsausweise for all using (true);
create policy if not exists "Anon lesen" on anwesenheit for all using (true);
create policy if not exists "Anon lesen" on sponsoren for all using (true);
create policy if not exists "Anon lesen" on sponsor_leistungen for all using (true);
create policy if not exists "Anon lesen" on inventar for all using (true);
create policy if not exists "Anon lesen" on inventar_ausleihen for all using (true);
create policy if not exists "Anon lesen" on news for all using (true);

-- Todos Spalte zu events (falls noch nicht vorhanden)
alter table events add column if not exists todos jsonb default '[]'::jsonb;

-- Kamera Spalte zu games
alter table games add column if not exists kamera boolean default false;
