-- ============================================================
-- Fix: user_profiles — FK zu auth.users entfernen
-- Damit Mitglieder manuell ohne Login-Account erfasst werden können
-- ============================================================

-- 1. Bestehende Tabelle umbenennen
alter table user_profiles rename to user_profiles_old;

-- 2. Neue Tabelle OHNE FK-Constraint auf auth.users
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

-- 3. Daten übertragen
insert into user_profiles (id, auth_user_id, club_id, vorname, nachname, email,
  telefon, adresse, geburtsdatum, rolle, team_ids, aktiv, login_status, mitglied_seit, created_at)
select id, id as auth_user_id, club_id, vorname, nachname, email,
  telefon, adresse, geburtsdatum, rolle, team_ids, aktiv, login_status, mitglied_seit, created_at
from user_profiles_old;

-- 4. Alte Tabelle löschen
drop table user_profiles_old cascade;

-- 5. RLS
alter table user_profiles enable row level security;
create policy "profiles_all" on user_profiles for all using (true);

-- 6. Index
create index on user_profiles(club_id);
create index on user_profiles(auth_user_id);
create index on user_profiles(email);

select 'Migration erfolgreich — user_profiles FK entfernt' as status;
