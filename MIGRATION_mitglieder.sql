-- Migration: Trikot-Felder und weitere Mitglieder-Felder
-- Im Supabase SQL Editor ausführen

-- Trikot-Spalten zu players
alter table players add column if not exists trikot_shirt      text;
alter table players add column if not exists trikot_hose       text;
alter table players add column if not exists trikot_stuelpengr text;

-- Adresse und Geburtsdatum zu user_profiles (falls nicht bereits vorhanden)
alter table user_profiles add column if not exists adresse      text;
alter table user_profiles add column if not exists geburtsdatum date;
alter table user_profiles add column if not exists club_id      text references clubs(club_id) on delete set null;
alter table user_profiles add column if not exists team_ids     uuid[];
alter table user_profiles add column if not exists rolle        text default 'spieler' check (rolle in ('admin','trainer','spieler','eltern'));
alter table user_profiles add column if not exists mitglied_seit date;
alter table user_profiles add column if not exists aktiv        boolean default true;
