-- Chạy một lần trong Supabase Dashboard > SQL Editor.
-- Mỗi tài khoản chỉ được đọc và sửa dữ liệu học tập của chính mình.

create table if not exists public.medstudy_state (
  user_id uuid primary key references auth.users(id) on delete cascade,
  payload jsonb not null default '{"lessons":{},"last":null}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.medstudy_state enable row level security;
revoke all on public.medstudy_state from anon;
grant select, insert, update on public.medstudy_state to authenticated;

drop policy if exists "medstudy select own state" on public.medstudy_state;
create policy "medstudy select own state"
on public.medstudy_state for select to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "medstudy insert own state" on public.medstudy_state;
create policy "medstudy insert own state"
on public.medstudy_state for insert to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists "medstudy update own state" on public.medstudy_state;
create policy "medstudy update own state"
on public.medstudy_state for update to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

insert into storage.buckets (id, name, public, file_size_limit)
values ('medstudy-files', 'medstudy-files', false, 26214400)
on conflict (id) do update set public = false, file_size_limit = 26214400;

drop policy if exists "medstudy read own files" on storage.objects;
create policy "medstudy read own files"
on storage.objects for select to authenticated
using (bucket_id = 'medstudy-files' and (storage.foldername(name))[1] = (select auth.uid()::text));

drop policy if exists "medstudy upload own files" on storage.objects;
create policy "medstudy upload own files"
on storage.objects for insert to authenticated
with check (bucket_id = 'medstudy-files' and (storage.foldername(name))[1] = (select auth.uid()::text));

drop policy if exists "medstudy replace own files" on storage.objects;
create policy "medstudy replace own files"
on storage.objects for update to authenticated
using (bucket_id = 'medstudy-files' and (storage.foldername(name))[1] = (select auth.uid()::text))
with check (bucket_id = 'medstudy-files' and (storage.foldername(name))[1] = (select auth.uid()::text));

drop policy if exists "medstudy delete own files" on storage.objects;
create policy "medstudy delete own files"
on storage.objects for delete to authenticated
using (bucket_id = 'medstudy-files' and (storage.foldername(name))[1] = (select auth.uid()::text));
