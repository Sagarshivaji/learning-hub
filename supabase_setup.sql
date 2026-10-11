-- ====================================================================
-- Supabase Schema for "Watch Later" Learning Lib
-- Run this in your Supabase Dashboard -> SQL Editor -> Run
-- ====================================================================

-- 1. Create the items table with hierarchy and group colors
create table if not exists public.items (
  id text primary key,
  url text not null,
  title text not null,
  done boolean default false not null,
  added_at bigint not null,
  group_name text default 'General',
  subgroup_name text default '',
  group_color text default '#6c8cff',
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Ensure all columns exist
alter table public.items add column if not exists group_name text default 'General';
alter table public.items add column if not exists subgroup_name text default '';
alter table public.items add column if not exists group_color text default '#6c8cff';

-- 2. Enable Row Level Security (RLS)
alter table public.items enable row level security;

-- 3. Create access policy: Allow anonymous access for read & write
drop policy if exists "Allow all operations for anon" on public.items;
create policy "Allow all operations for anon" on public.items
  for all
  using (true)
  with check (true);

-- 4. Enable Realtime on the items table
do $$
begin
  if not exists (
    select 1 from pg_publication_tables 
    where pubname = 'supabase_realtime' and tablename = 'items'
  ) then
    alter publication supabase_realtime add table public.items;
  end if;
end $$;
