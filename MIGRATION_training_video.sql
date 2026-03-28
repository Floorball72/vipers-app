-- Migration: Training & Video
alter table videoanalysen add column if not exists kategorie text default 'gegner'
  check (kategorie in ('gegner','highlights','taktik','allgemein'));
alter table trainingseinheiten add column if not exists kategorie text default 'technik';
