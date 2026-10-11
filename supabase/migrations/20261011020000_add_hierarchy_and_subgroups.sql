-- Migration: Add hierarchical group_name and subgroup_name columns to items table
alter table public.items add column if not exists group_name text default 'General';
alter table public.items add column if not exists subgroup_name text default '';
