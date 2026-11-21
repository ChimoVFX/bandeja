-- Pega esto en Supabase → SQL Editor → New query → Run
create table if not exists public.items (
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  id text not null,
  data jsonb not null,
  updated_at timestamptz not null default now(),
  primary key (user_id, id)
);
alter table public.items enable row level security;
create policy "cada uno ve lo suyo" on public.items for select using (auth.uid() = user_id);
create policy "cada uno crea lo suyo" on public.items for insert with check (auth.uid() = user_id);
create policy "cada uno cambia lo suyo" on public.items for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "cada uno borra lo suyo" on public.items for delete using (auth.uid() = user_id);
alter publication supabase_realtime add table public.items;
