-- Fix: news Tabelle — fehlende Spalten hinzufügen
alter table news add column if not exists zielgruppe text[] default array['alle'];
alter table news drop column if exists erstellt_am;
alter table news drop column if exists erstellt_von;

select 'news Tabelle gefixt' as status;
