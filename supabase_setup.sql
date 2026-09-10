-- ═══ 멜버니의 걸음마 — Supabase 테이블 ═══
-- 사진은 base64 데이터(text)로 저장 — 가족 규모(수백 장)에 충분
-- 실행: Supabase Dashboard → SQL Editor → 붙여넣기 → Run

create table if not exists mel_photos (
  id bigint generated always as identity primary key,
  created_at timestamptz default now(),
  photo_date date not null,
  memo text,
  image_data text not null
);

create table if not exists mel_diary (
  id bigint generated always as identity primary key,
  created_at timestamptz default now(),
  text text not null
);

-- RLS: 읽기/쓰기 공개(익명) — 사이트 자체가 비밀번호 게이트로 보호됨
alter table mel_photos enable row level security;
alter table mel_diary enable row level security;

drop policy if exists "mel_photos_all" on mel_photos;
create policy "mel_photos_all" on mel_photos
  for all using (true) with check (true);

drop policy if exists "mel_diary_all" on mel_diary;
create policy "mel_diary_all" on mel_diary
  for all using (true) with check (true);
