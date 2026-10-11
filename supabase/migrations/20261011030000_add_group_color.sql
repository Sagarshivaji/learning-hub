-- Migration: Add group_color column to items table
alter table public.items add column if not exists group_color text default '';
