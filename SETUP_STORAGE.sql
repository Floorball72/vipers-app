-- ============================================================
-- UHC Jonschwil Vipers — Supabase Storage Setup
-- Im Supabase SQL Editor ausführen NACHDEM SETUP_DATABASE.sql
-- bereits ausgeführt wurde.
-- ============================================================

-- foto_url Spalte zu inventar hinzufügen (falls noch nicht vorhanden)
alter table inventar add column if not exists foto_url text;

-- logo_url ist bereits in sponsoren vorhanden (aus SETUP_DATABASE.sql)
-- beleg_url ist bereits in finanzen vorhanden (aus SETUP_DATABASE.sql)

-- ============================================================
-- Storage Bucket via Supabase Dashboard erstellen:
-- (SQL kann keinen Bucket erstellen — das geht nur im Dashboard)
--
-- 1. Supabase Dashboard → Storage → "New bucket"
-- 2. Name: belege
-- 3. Public: AUS (privat)
-- 4. File size limit: 10 MB
-- 5. Allowed MIME types: image/jpeg, image/png, image/webp, application/pdf
--
-- Dann diese Policies setzen:
-- ============================================================

-- Policy: Eingeloggte User können hochladen
insert into storage.policies (name, bucket_id, operation, definition)
values (
  'Authenticated upload',
  'belege',
  'INSERT',
  '(auth.role() = ''authenticated'')'
) on conflict do nothing;

-- Policy: Eingeloggte User können lesen
insert into storage.policies (name, bucket_id, operation, definition)
values (
  'Authenticated read',
  'belege',
  'SELECT',
  '(auth.role() = ''authenticated'')'
) on conflict do nothing;

-- Policy: Eigene Dateien löschen
insert into storage.policies (name, bucket_id, operation, definition)
values (
  'Authenticated delete own',
  'belege',
  'DELETE',
  '(auth.role() = ''authenticated'')'
) on conflict do nothing;

-- ============================================================
-- HINWEIS: Falls die Policy-INSERTs einen Fehler geben,
-- die Policies manuell im Dashboard setzen:
-- Storage → belege → Policies → Add policy → "Full access for authenticated users"
-- ============================================================
