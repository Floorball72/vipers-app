-- Migration: spielkategorie zu games, manuelle Scorer-Einträge
alter table games add column if not exists spielkategorie text default 'saison'
  check (spielkategorie in ('saison','cup','friendly'));

-- Inventar Ausleihen: Mietpreis und Bezahlt-Status
alter table inventar_ausleihen add column if not exists mietpreis numeric(10,2);
alter table inventar_ausleihen add column if not exists bezahlt boolean default false;
-- Finanzen: konto Spalte (falls noch nicht vorhanden)
alter table finanzen add column if not exists konto text default 'Allgemein';
