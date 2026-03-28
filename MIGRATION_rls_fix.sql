-- ============================================================
-- STACKFLOW — RLS Policy Fix (für bestehende Datenbanken)
-- Führe dieses Script aus wenn INSERT/UPDATE/DELETE blockiert werden
-- ============================================================

-- Alle bestehenden Policies löschen
do $$ declare
  r record;
begin
  for r in select schemaname, tablename, policyname
    from pg_policies
    where schemaname = 'public'
  loop
    execute format('drop policy if exists %I on %I.%I',
      r.policyname, r.schemaname, r.tablename);
  end loop;
end $$;

-- Neue offene Policies setzen
create policy "open_clubs"      on clubs                 for all using (true) with check (true);
create policy "open_profiles"   on user_profiles         for all using (true) with check (true);
create policy "open_members"    on user_club_memberships for all using (true) with check (true);
create policy "open_teams"      on teams                 for all using (true) with check (true);
create policy "open_players"    on players               for all using (true) with check (true);
create policy "open_games"      on games                 for all using (true) with check (true);
create policy "open_events"     on events                for all using (true) with check (true);
create policy "open_news"       on news                  for all using (true) with check (true);
create policy "open_posts"      on social_posts          for all using (true) with check (true);
create policy "open_scorer"     on scorer                for all using (true) with check (true);
create policy "open_anw"        on anwesenheit           for all using (true) with check (true);
create policy "open_finanzen"   on finanzen              for all using (true) with check (true);
create policy "open_sponsor"    on sponsoren             for all using (true) with check (true);
create policy "open_sponlei"    on sponsor_leistungen    for all using (true) with check (true);
create policy "open_inventar"   on inventar              for all using (true) with check (true);
create policy "open_invausl"    on inventar_ausleihen    for all using (true) with check (true);
create policy "open_training"   on trainingseinheiten    for all using (true) with check (true);
create policy "open_video"      on videoanalysen         for all using (true) with check (true);
create policy "open_ausweise"   on mitgliedsausweise     for all using (true) with check (true);

select 'RLS Policies aktualisiert' as status;
