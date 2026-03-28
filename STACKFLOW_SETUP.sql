-- ============================================================
-- STACKFLOW — Complete Database Setup
-- Run this in the Supabase SQL Editor
-- ============================================================

-- Step 1: Drop all existing tables
drop table if exists membership_cards     cascade;
drop table if exists video_analyses       cascade;
drop table if exists training_units       cascade;
drop table if exists scorer               cascade;
drop table if exists attendance           cascade;
drop table if exists social_posts         cascade;
drop table if exists finance              cascade;
drop table if exists sponsor_services     cascade;
drop table if exists sponsors             cascade;
drop table if exists inventory_loans      cascade;
drop table if exists inventory            cascade;
drop table if exists news                 cascade;
drop table if exists events               cascade;
drop table if exists games                cascade;
drop table if exists players              cascade;
drop table if exists memberships          cascade;
drop table if exists user_profiles        cascade;
drop table if exists teams                cascade;

-- Step 2: Create tables

-- Teams
create table teams (
  id               uuid primary key default gen_random_uuid(),
  name             text not null,
  league           text,
  season           text,
  training_times   text,
  training_location text,
  active           boolean default true,
  created_at       timestamptz default now()
);

-- User Profiles (id = own UUID, auth_user_id = Supabase Auth link)
create table user_profiles (
  id            uuid primary key default gen_random_uuid(),
  auth_user_id  uuid unique references auth.users(id) on delete set null,
  first_name    text not null default '',
  last_name     text not null default '',
  email         text,
  phone         text,
  address       text,
  birth_date    date,
  photo_url     text,
  role          text default 'player'
                  check (role in ('admin','trainer','player','parent')),
  team_ids      uuid[],
  active        boolean default true,
  login_status  text default 'pending'
                  check (login_status in ('pending','invited','active')),
  member_since  date default current_date,
  created_at    timestamptz default now()
);

-- Memberships (user ↔ team)
create table memberships (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid references user_profiles(id) on delete cascade,
  team_id      uuid references teams(id) on delete cascade,
  role         text default 'player',
  joined_at    date default current_date,
  active       boolean default true,
  created_at   timestamptz default now()
);

-- Players
create table players (
  id            uuid primary key default gen_random_uuid(),
  team_id       uuid references teams(id) on delete set null,
  user_id       uuid references auth.users(id) on delete set null,
  first_name    text not null,
  last_name     text not null,
  jersey_number integer,
  position      text,
  email         text,
  phone         text,
  birth_date    date,
  shirt_size    text,
  shorts_size   text,
  socks_size    text,
  active        boolean default true,
  created_at    timestamptz default now()
);

-- Games
create table games (
  id            uuid primary key default gen_random_uuid(),
  team_id       uuid references teams(id) on delete set null,
  opponent      text not null,
  date          date not null,
  kickoff       time default '17:00',
  home_game     boolean default true,
  game_category text default 'season'
                  check (game_category in ('season','cup','friendly')),
  location      text,
  score_home    integer,
  score_away    integer,
  camera        boolean default false,
  notes         text,
  created_at    timestamptz default now()
);

-- Events
create table events (
  id          uuid primary key default gen_random_uuid(),
  title       text not null,
  description text,
  date        date not null,
  time        time,
  end_date    date,
  location    text,
  type        text default 'event'
                check (type in ('event','cup','tournament','meeting','training')),
  team_ids    uuid[],
  todos       jsonb default '[]'::jsonb,
  created_at  timestamptz default now()
);

-- News
create table news (
  id          uuid primary key default gen_random_uuid(),
  title       text not null,
  content     text,
  type        text default 'info'
                check (type in ('info','important','training','game','event')),
  audience    text[] default array['all'],
  team_ids    uuid[],
  pinned      boolean default false,
  image_url   text,
  created_at  timestamptz default now()
);

-- Social Media Posts
create table social_posts (
  id             uuid primary key default gen_random_uuid(),
  type           text not null check (type in ('preview','result','event','info')),
  week_date      date not null,
  scheduled_for  timestamptz not null,
  status         text default 'planned'
                   check (status in ('planned','done','skipped')),
  canva_link     text,
  text_draft     text,
  platforms      text[] default array['instagram','facebook'],
  created_at     timestamptz default now()
);

-- Scorer / Statistics
create table scorer (
  id              uuid primary key default gen_random_uuid(),
  player_id       uuid references players(id) on delete cascade,
  game_id         uuid references games(id) on delete set null,
  goals           integer default 0,
  assists         integer default 0,
  penalty_minutes integer default 0,
  season          text,
  created_at      timestamptz default now(),
  unique nulls not distinct (player_id, game_id)
);

-- Attendance
create table attendance (
  id             uuid primary key default gen_random_uuid(),
  player_id      uuid references players(id) on delete cascade,
  team_id        uuid references teams(id) on delete set null,
  game_id        uuid references games(id) on delete set null,
  event_id       uuid references events(id) on delete set null,
  training_date  date,
  type           text default 'training'
                   check (type in ('training','game','event')),
  status         text default 'open'
                   check (status in ('present','absent','excused','open')),
  notes          text,
  created_at     timestamptz default now()
);

-- Finance
create table finance (
  id          uuid primary key default gen_random_uuid(),
  type        text not null check (type in ('income','expense')),
  amount      numeric(10,2) not null,
  account     text default 'General',
  category    text,
  description text,
  receipt_url text,
  date        date not null,
  created_at  timestamptz default now()
);

-- Sponsors
create table sponsors (
  id              uuid primary key default gen_random_uuid(),
  company_name    text not null,
  contact_person  text,
  email           text,
  phone           text,
  website         text,
  logo_url        text,
  category        text,
  amount_per_year numeric(10,2),
  contract_start  date,
  contract_end    date,
  status          text default 'active'
                    check (status in ('active','inactive','negotiating')),
  notes           text,
  created_at      timestamptz default now()
);

create table sponsor_services (
  id          uuid primary key default gen_random_uuid(),
  sponsor_id  uuid references sponsors(id) on delete cascade,
  description text not null,
  done        boolean default false,
  created_at  timestamptz default now()
);

-- Inventory
create table inventory (
  id                uuid primary key default gen_random_uuid(),
  name              text not null,
  category          text default 'Other',
  quantity_total    integer default 1,
  quantity_available integer default 1,
  condition         text default 'good'
                      check (condition in ('new','good','used','broken')),
  storage_location  text,
  photo_url         text,
  purchase_price    numeric(10,2),
  created_at        timestamptz default now()
);

create table inventory_loans (
  id                uuid primary key default gen_random_uuid(),
  inventory_id      uuid references inventory(id) on delete cascade,
  player_id         uuid references players(id) on delete set null,
  loaned_at         date default current_date,
  return_by         date,
  returned_at       date,
  rental_price      numeric(10,2),
  paid              boolean default false,
  notes             text,
  created_at        timestamptz default now()
);

-- Training
create table training_units (
  id          uuid primary key default gen_random_uuid(),
  team_id     uuid references teams(id) on delete set null,
  title       text not null,
  description text,
  category    text,
  video_url   text,
  duration_min integer,
  trainer     text,
  created_at  timestamptz default now()
);

create table video_analyses (
  id          uuid primary key default gen_random_uuid(),
  game_id     uuid references games(id) on delete set null,
  title       text not null,
  category    text,
  video_url   text,
  notes       text,
  tags        text[],
  created_by  text,
  created_at  timestamptz default now()
);

-- Membership Cards
create table membership_cards (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid references auth.users(id) on delete cascade,
  issued_at   date default current_date,
  valid_until date,
  active      boolean default true,
  created_at  timestamptz default now()
);

-- Step 3: Indexes
create index on games(team_id, date);
create index on players(team_id);
create index on players(user_id);
create index on players(email);
create index on scorer(player_id);
create index on finance(date desc);
create index on news(created_at desc);
create index on user_profiles(auth_user_id);
create index on user_profiles(email);
create index on attendance(player_id);

-- Step 4: Row Level Security
alter table teams              enable row level security;
alter table user_profiles      enable row level security;
alter table memberships        enable row level security;
alter table players            enable row level security;
alter table games              enable row level security;
alter table events             enable row level security;
alter table news               enable row level security;
alter table social_posts       enable row level security;
alter table scorer             enable row level security;
alter table attendance         enable row level security;
alter table finance            enable row level security;
alter table sponsors           enable row level security;
alter table sponsor_services   enable row level security;
alter table inventory          enable row level security;
alter table inventory_loans    enable row level security;
alter table training_units     enable row level security;
alter table video_analyses     enable row level security;
alter table membership_cards   enable row level security;

-- Open policies (app uses anon key, security via app logic)
create policy "open_teams"           on teams            for all using (true) with check (true);
create policy "open_profiles"        on user_profiles    for all using (true) with check (true);
create policy "open_memberships"     on memberships      for all using (true) with check (true);
create policy "open_players"         on players          for all using (true) with check (true);
create policy "open_games"           on games            for all using (true) with check (true);
create policy "open_events"          on events           for all using (true) with check (true);
create policy "open_news"            on news             for all using (true) with check (true);
create policy "open_posts"           on social_posts     for all using (true) with check (true);
create policy "open_scorer"          on scorer           for all using (true) with check (true);
create policy "open_attendance"      on attendance       for all using (true) with check (true);
create policy "open_finance"         on finance          for all using (true) with check (true);
create policy "open_sponsors"        on sponsors         for all using (true) with check (true);
create policy "open_sponsor_svc"     on sponsor_services for all using (true) with check (true);
create policy "open_inventory"       on inventory        for all using (true) with check (true);
create policy "open_inv_loans"       on inventory_loans  for all using (true) with check (true);
create policy "open_training"        on training_units   for all using (true) with check (true);
create policy "open_video"           on video_analyses   for all using (true) with check (true);
create policy "open_cards"           on membership_cards for all using (true) with check (true);

-- Step 5: Storage bucket
insert into storage.buckets (id, name, public, file_size_limit)
values ('stackflow', 'stackflow', true, 524288000)
on conflict (id) do update set public = true;

select '✓ Stackflow database setup complete!' as status;
