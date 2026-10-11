# Watch Later (Learning Hub)

A sleek, real-time bookmarking and learning library with **hierarchical groups & subgroups**, **group-into-group drag-and-drop nesting**, **custom group colors**, and permanent cloud sync via **Supabase**.

## 🌟 Key Features

- **Drag Group into Another Group**: Drag any Group header onto another Group to automatically nest it as a Subgroup!
- **Promote Subgroups to Top-Level**: Drag a Subgroup into the promotion zone or click `⇪ Make Group` to convert it into an independent top-level group.
- **Custom Group Colors**: Customize each group with vibrant preset colors (Blue, Purple, Emerald, Rose, Amber, Cyan, Pink) or any custom hex color.
- **Edit Groups Anytime**: Click `✏️ Edit` on any group to rename it, change its color, or delete it with link reassignment.
- **Drag & Drop Links**: Drag any link card by its handle (`⋮⋮`) and drop it into any group or subgroup.
- **Custom Groups (Not Domain-Locked)**: Group completely different links together (YouTube, GitHub, Medium, Twitter, Docs) under the same topic.
- **Permanent Cloud Persistence**: Stored in your Supabase PostgreSQL database so your links never disappear when the site sleeps.
- **Multi-Device Realtime Sync**: Instantly syncs across all open browsers and devices when links are added, moved, or checked off.
- **Quick Move Modal**: On mobile or click, move any link between groups and subgroups with one tap using `🏷️`.

---

## ⚡ Supabase Setup

### 1. Database Schema
Run this in your [Supabase SQL Editor](https://supabase.com/dashboard) to enable custom groups, subgroups, and colors:

```sql
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

alter table public.items add column if not exists group_name text default 'General';
alter table public.items add column if not exists subgroup_name text default '';
alter table public.items add column if not exists group_color text default '#6c8cff';

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
