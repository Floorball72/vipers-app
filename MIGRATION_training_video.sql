-- Migration: Training & Video
alter table videoanalysen add column if not exists kategorie text default 'opponent'
  check (kategorie in ('opponent','highlights','taktik','allgemein'));
alter table trainingseinheiten add column if not exists kategorie text default 'technik';
