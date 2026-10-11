-- ====================================================================
-- Supabase Schema for "Watch Later" Learning Lib
-- Run this in your Supabase Dashboard:
-- 1. Go to https://supabase.com/dashboard
-- 2. Select your project -> Click "SQL Editor" in the left sidebar
-- 3. Click "New query", paste this entire script, and click "Run"
-- ====================================================================

-- 1. Create the items table
create table if not exists public.items (
  id text primary key,
  url text not null,
  title text not null,
  done boolean default false not null,
  added_at bigint not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 2. Enable Row Level Security (RLS)
alter table public.items enable row level security;

-- 3. Create access policy: Allow anonymous access for read & write
drop policy if exists "Allow all operations for anon" on public.items;
create policy "Allow all operations for anon" on public.items
  for all
  using (true)
  with check (true);

-- 4. Enable Realtime on the items table
-- This allows instant live updates across all connected browsers and devices
do $$
begin
  if not exists (
    select 1 from pg_publication_tables 
    where pubname = 'supabase_realtime' and tablename = 'items'
  ) then
    alter publication supabase_realtime add table public.items;
  end if;
end $$;
