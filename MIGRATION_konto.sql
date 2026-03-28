-- Migration: konto Spalte zu bestehender finanzen-Tabelle hinzufügen
-- Nur ausführen wenn SETUP_DATABASE.sql bereits gelaufen ist

alter table finanzen add column if not exists konto text default 'Allgemein';
