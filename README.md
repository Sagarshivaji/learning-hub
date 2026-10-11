# Watch Later (Learning Hub)

A sleek, real-time bookmarking and learning library with **hierarchical groups & subgroups**, **drag-and-drop organization**, and permanent cloud sync via **Supabase**.

## 🌟 Key Features

- **Hierarchical Groups & Subgroups**: Organize your saved links into custom categories (e.g. *Frontend > React*, *Backend > Node*, *Design > Framer*).
- **Drag & Drop Organization**: Grab any link by its handle (`⋮⋮`) and drop it into another group or subgroup to move it instantly.
- **Custom Groups (Not Domain-Locked)**: Group completely different links together (YouTube, GitHub, Medium, Documentation) under the same topic.
- **Quick Actions & Move Modal**:
  - Add links directly to any group or subgroup with `+ Add link here`.
  - Move links seamlessly on mobile or desktop using the `🏷️ Move` button.
- **Permanent Cloud Persistence**: Stored in your Supabase PostgreSQL database so your links never disappear when the site sleeps.
- **Multi-Device Realtime Sync**: Instantly syncs across all open browsers and devices when links are added, moved, or checked off.
- **Live Preview & Favicons**: Automatic domain parsing and favicon fetching as you type links.
- **Offline / Local Fallback**: Saves locally in browser storage so the app is always fast and responsive.

---

## ⚡ Supabase Setup

### 1. Database Schema
If you are setting up the database, run this in your [Supabase SQL Editor](https://supabase.com/dashboard):

```sql
create table if not exists public.items (
  id text primary key,
  url text not null,
  title text not null,
  done boolean default false not null,
  added_at bigint not null,
  group_name text default 'General',
  subgroup_name text default '',
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.items add column if not exists group_name text default 'General';
alter table public.items add column if not exists subgroup_name text default '';

alter table public.items enable row level security;

drop policy if exists "Allow all operations for anon" on public.items;
create policy "Allow all operations for anon" on public.items
  for all using (true) with check (true);

do $$ begin
  if not exists (
    select 1 from pg_publication_tables 
    where pubname = 'supabase_realtime' and tablename = 'items'
  ) then
    alter publication supabase_realtime add table public.items;
  end if;
end $$;
```

### 2. Connect Your App
- In the app header, click **☁️ Supabase Cloud**.
- Paste your **Project URL** and **Anon Key** (found under **Project Settings → API**).
- Click **Connect & Save**.

---

## Running Locally

```bash
npm install
npm start
```

Open [http://localhost:3000](http://localhost:3000) in your browser.
