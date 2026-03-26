-- Migration: login_status Spalte + players.email
alter table user_profiles add column if not exists login_status text default 'pending'
  check (login_status in ('pending','invited','active'));
alter table players add column if not exists email text;
