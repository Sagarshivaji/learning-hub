-- Migration: Add group_name column to items table for custom user-defined groups
alter table public.items add column if not exists group_name text default 'General';
