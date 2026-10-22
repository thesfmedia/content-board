-- Content Board: run this once in Supabase → SQL Editor → New query → Run.
-- Everyone can VIEW. Only the email below can add, edit or delete.
-- Change the email if you sign in with a different one.

create or replace function public.is_board_owner() returns boolean
language sql stable security invoker set search_path = '' as $$
  select coalesce((select auth.jwt()) ->> 'email', '') = 'hasanat.ahmed.5656@gmail.com'
$$;

create table if not exists public.boards (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  name text not null,
  slug text not null unique
);

create table if not exists public.tags (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  name text not null,
  color text not null default '#8a8f98'
);

create table if not exists public.items (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  board_id uuid not null references public.boards(id) on delete cascade,
  kind text not null check (kind in ('video','image','link')),
  title text not null default '',
  url text,
  storage_path text,
  format text not null check (format in ('short','long')),
  status text check (status in ('todo','done')),
  tags uuid[] not null default '{}',
  duration real, width int, height int, size bigint, hue int
);
create index if not exists items_board_idx on public.items(board_id, created_at desc);

alter table public.boards enable row level security;
alter table public.tags   enable row level security;
alter table public.items  enable row level security;

grant select on public.boards, public.tags, public.items to anon, authenticated;
grant insert, update, delete on public.boards, public.tags, public.items to authenticated;

do $$
declare t text;
begin
  foreach t in array array['boards','tags','items'] loop
    execute format('drop policy if exists "public read" on public.%I', t);
    execute format('drop policy if exists "owner write" on public.%I', t);
    execute format('create policy "public read" on public.%I for select using (true)', t);
    execute format('create policy "owner write" on public.%I for all to authenticated using (public.is_board_owner()) with check (public.is_board_owner())', t);
  end loop;
end $$;

-- Storage for uploaded videos (public to view, owner-only to change)
insert into storage.buckets (id, name, public, file_size_limit) values ('media', 'media', true, 52428800)
on conflict (id) do update set public = true, file_size_limit = 52428800;

drop policy if exists "media owner select" on storage.objects;
drop policy if exists "media owner insert" on storage.objects;
drop policy if exists "media owner update" on storage.objects;
drop policy if exists "media owner delete" on storage.objects;
create policy "media owner select" on storage.objects for select to authenticated using (bucket_id = 'media' and public.is_board_owner());
create policy "media owner insert" on storage.objects for insert to authenticated with check (bucket_id = 'media' and public.is_board_owner());
create policy "media owner update" on storage.objects for update to authenticated using (bucket_id = 'media' and public.is_board_owner());
create policy "media owner delete" on storage.objects for delete to authenticated using (bucket_id = 'media' and public.is_board_owner());

-- A first board and some starter tags
insert into public.boards (name, slug) values ('My Board', 'my-board') on conflict (slug) do nothing;
insert into public.tags (name, color)
select * from (values ('aura/cinematic','#d64a3f'),('quotes','#3d8fe0'),('funny','#e2b13a'),('mini film/story','#df8441'),('bts','#7a52d9'))
  as v(name, color)
where not exists (select 1 from public.tags);
