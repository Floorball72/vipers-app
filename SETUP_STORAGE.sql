-- ============================================================
-- STORAGE SETUP für Stackflow
-- Im Supabase Dashboard ausführen: Storage → SQL Editor
-- ODER direkt im SQL Editor wenn storage Extension aktiv ist
-- ============================================================

-- Bucket erstellen (falls nicht existiert)
insert into storage.buckets (id, name, public, file_size_limit)
values ('stackflow', 'stackflow', true, 524288000)
on conflict (id) do update set public = true, file_size_limit = 524288000;

-- Policy: Alle dürfen lesen (public bucket)
create policy "storage_public_read"
on storage.objects for select
using (bucket_id = 'stackflow');

-- Policy: Alle dürfen hochladen  
create policy "storage_public_insert"
on storage.objects for insert
with check (bucket_id = 'stackflow');

-- Policy: Alle dürfen löschen
create policy "storage_public_delete"
on storage.objects for delete
using (bucket_id = 'stackflow');

select 'Storage Bucket "stackflow" konfiguriert' as status;
