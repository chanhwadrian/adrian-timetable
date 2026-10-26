-- =========================================================
-- Adrian 排课表 · Supabase setup
-- Run this ONCE in Supabase → SQL Editor → New query → Run
-- =========================================================

-- ---------- tables ----------
create table if not exists lessons (
  id uuid primary key default gen_random_uuid(),
  student    text not null default '',
  manager    text not null default '',
  programme  text not null default '',
  subject    text not null default '',
  day        int,                    -- 0=Mon … 5=Sat (for recurring; also stored for one-offs)
  date       date,                   -- one-off lessons only
  start_min  int  not null,          -- minutes from 00:00, e.g. 780 = 13:00
  end_min    int  not null,
  recurring  boolean not null default false,  -- 固排
  blocked    boolean not null default false,  -- Adrian 屏蔽时段
  start_date date,                   -- recurring: effective from this date
  created_at timestamptz not null default now()
);

create table if not exists managers (
  id       uuid primary key default gen_random_uuid(),
  name     text not null unique,
  added_at timestamptz not null default now()
);

-- ---------- open access (anyone with the site link) ----------
alter table lessons  enable row level security;
alter table managers enable row level security;

drop policy if exists "open read"   on lessons;
drop policy if exists "open insert" on lessons;
drop policy if exists "open update" on lessons;
drop policy if exists "open delete" on lessons;
create policy "open read"   on lessons for select using (true);
create policy "open insert" on lessons for insert with check (true);
create policy "open update" on lessons for update using (true) with check (true);
create policy "open delete" on lessons for delete using (true);

drop policy if exists "open read"   on managers;
drop policy if exists "open insert" on managers;
create policy "open read"   on managers for select using (true);
create policy "open insert" on managers for insert with check (true);

-- instant sync between open browsers (safe to re-run)
do $$ begin
  alter publication supabase_realtime add table lessons;
exception when others then null; end $$;

-- ---------- seed: 学管 ----------
insert into managers (name) values
  ('曹洪恺'),('Daisy'),('Sylvia'),('尚子祺'),('林天琪'),('叶佳语'),('楚璇')
on conflict (name) do nothing;

-- ---------- seed: 固定排课 (as of 2026-10-26) ----------
-- programme: 紫荆=purple · 跃升/灯塔=dark blue · 扬帆=orange · blocked=black
insert into lessons (student, manager, programme, subject, day, start_min, end_min, recurring, blocked) values
-- Monday
  ('',        'Adrian', '',        '',             0,  540,  780, true, true),   -- 屏蔽 09:00–13:00
  ('谭璐洋',  'Adrian', '跃升/灯塔','管理',          0,  780,  870, true, false),  -- 13:00–14:30
  ('李思颖',  'Adrian', '紫荆',    'IGCSE 英语',    0,  990, 1110, true, false),  -- 16:30–18:30
  ('Jay',     'Adrian', '紫荆',    'IGCSE 英语',    0, 1110, 1230, true, false),  -- 18:30–20:30
-- Tuesday
  ('',        'Adrian', '',        '',             1,  600,  660, true, true),   -- 屏蔽 10:00–11:00
  ('',        'Adrian', '',        '',             1,  720,  780, true, true),   -- 屏蔽 12:00–13:00
  ('张正恺',  'Adrian', '跃升/灯塔','IELTS',         1,  780,  900, true, false),  -- 13:00–15:00
  ('黄炎斌',  'Adrian', '紫荆',    'IGCSE 英语',    1,  990, 1050, true, false),  -- 16:30–17:30
  ('扬帆（班课）','Adrian','扬帆',  'HKDSE 英语',    1, 1050, 1170, true, false),  -- 17:30–19:30
  ('扬帆（班课）','Adrian','扬帆',  '自习',          1, 1170, 1260, true, false),  -- 19:30–21:00
-- Wednesday
  ('张正恺',  'Adrian', '跃升/灯塔','IELTS',         2,  870,  990, true, false),  -- 14:30–16:30
  ('姚宜佳',  'Adrian', '紫荆',    'HKDSE 经济',    2, 1020, 1140, true, false),  -- 17:00–19:00
  ('陈子洋',  'Adrian', '紫荆',    'HKDSE 英语',    2, 1140, 1200, true, false),  -- 19:00–20:00
-- Thursday
  ('张正恺',  'Adrian', '跃升/灯塔','IELTS',         3,  570,  675, true, false),  -- 09:30–11:15
  ('徐妙津',  'Adrian', '紫荆',    'IELTS 英语',    3,  675,  735, true, false),  -- 11:15–12:15
  ('朱昱',    'Adrian', '紫荆',    'IB 英语',       3, 1080, 1200, true, false),  -- 18:00–20:00
  ('陈子洋',  'Adrian', '紫荆',    'HKDSE 英语',    3, 1200, 1260, true, false),  -- 20:00–21:00
-- Friday
  ('徐妙津',  'Adrian', '紫荆',    'IELTS 英语',    4,  675,  735, true, false),  -- 11:15–12:15
  ('李雪锋',  'Adrian', '跃升/灯塔','学术英语/管理',  4,  795,  900, true, false),  -- 13:15–15:00
  ('周俊浩',  'Adrian', '跃升/灯塔','学术英语',      4,  990, 1110, true, false),  -- 16:30–18:30
  ('杨天睿',  'Adrian', '跃升/灯塔','学术英语',      4, 1110, 1230, true, false),  -- 18:30–20:30
-- Saturday
  ('吴振轩',  'Adrian', '紫荆',    'HKDSE 英语',    5,  540,  660, true, false),  -- 09:00–11:00
  ('谭璐洋',  'Adrian', '跃升/灯塔','管理',          5,  660,  780, true, false),  -- 11:00–13:00
  ('张锐堃',  'Adrian', '跃升/灯塔','管理',          5,  810,  930, true, false),  -- 13:30–15:30
  ('顾宸溪',  'Adrian', '紫荆',    'IGCSE 经济',    5,  930, 1050, true, false),  -- 15:30–17:30
  ('',        'Adrian', '',        '',             5, 1170, 1260, true, true);   -- 屏蔽 19:30–21:00
