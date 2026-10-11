-- Migration: Create items table and enable realtime for Watch Later
-- This migration runs automatically when connected to Supabase Git integration

create table if not exists public.items (
  id text primary key,
  url text not null,
  title text not null,
  done boolean default false not null,
  added_at bigint not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable Row Level Security (RLS)
alter table public.items enable row level security;

-- Create policy for public / anonymous access
drop policy if exists "Allow all operations for anon" on public.items;
create policy "Allow all operations for anon" on public.items
  for all
  using (true)
  with check (true);

-- Enable Realtime publication for the items table
do $$
begin
  if not exists (
    select 1 from pg_publication_tables 
    where pubname = 'supabase_realtime' and tablename = 'items'
  ) then
    alter publication supabase_realtime add table public.items;
  end if;
end $$;
