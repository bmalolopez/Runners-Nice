-- ═══════════════════════════════════════════════════════════
-- RunnersBR — Crear tablas en Supabase
-- Pega TODO esto en Supabase → SQL Editor → New query → RUN
-- ═══════════════════════════════════════════════════════════

create table if not exists runners (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default now(),
  first_name text, last_name text, nickname text, birth date,
  number text unique, color text, food text, phrase text,
  e_name text, e_phone text, joined date,
  gmm text default 'no', hospital text default ''
);

create table if not exists activities (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default now(),
  rid uuid, type text, detail text, pts int, date date, note text
);

create table if not exists chat (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default now(),
  rid uuid, name text, msg text, date date
);

create table if not exists photos (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default now(),
  rid uuid, rname text, img text, cap text, act text, date date
);

create table if not exists promos (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default now(),
  rid uuid, rname text, img text, biz text, description text,
  dis text, con text, date date, approved boolean default false
);

create table if not exists config (
  id text primary key,
  admin_password text
);
insert into config (id, admin_password)
  values ('main', 'runners2024')
  on conflict (id) do nothing;

-- ── Permisos (acceso abierto, controlado por la app) ──────────
alter table runners    enable row level security;
alter table activities enable row level security;
alter table chat       enable row level security;
alter table photos     enable row level security;
alter table promos     enable row level security;
alter table config     enable row level security;

create policy "rbr_all" on runners    for all using (true) with check (true);
create policy "rbr_all" on activities for all using (true) with check (true);
create policy "rbr_all" on chat       for all using (true) with check (true);
create policy "rbr_all" on photos     for all using (true) with check (true);
create policy "rbr_all" on promos     for all using (true) with check (true);
create policy "rbr_all" on config     for all using (true) with check (true);

-- ── Chat en tiempo real ──────────────────────────────────────
alter publication supabase_realtime add table chat;

create table if not exists nutrition (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  rid uuid unique,
  peso numeric, talla numeric, edad int,
  objetivo text default 'mantener',
  nivel_actividad text default 'leve',
  condicion text default 'ninguna',
  alergia text default 'ninguna',
  dieta text default 'omnivora',
  comidas text default '3'
);

alter table nutrition enable row level security;
create policy "rbr_all" on nutrition for all using (true) with check (true);

create table if not exists avisos (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default now(),
  title text default '',
  body text default '',
  date text default ''
);

alter table avisos enable row level security;
create policy "rbr_all" on avisos for all using (true) with check (true);

create table if not exists notificaciones (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default now(),
  rid uuid,
  runner_name text,
  tipo text,
  mensaje text,
  leida boolean default false
);

alter table notificaciones enable row level security;
create policy "rbr_all" on notificaciones for all using (true) with check (true);

-- ── Si ya tenías la base de datos, ejecuta estas líneas también ──
alter table runners add column if not exists gmm text default 'no';
alter table runners add column if not exists hospital text default '';
alter table promos  add column if not exists approved boolean default false;
alter table runners add column if not exists coach_active boolean default false;
alter table runners add column if not exists access_allowed boolean default false;

-- ── Datos demo de nutrición (ejecuta DESPUÉS del SQL demo de corredoras) ────
insert into nutrition (rid, peso, talla, edad, objetivo, nivel_actividad, condicion, alergia, dieta, comidas)
select id, 58, 162, 28, 'energia',   'leve',      'ninguna',     'ninguna', 'omnivora',    '4' from runners where nickname='Luli'       on conflict (rid) do nothing;
insert into nutrition (rid, peso, talla, edad, objetivo, nivel_actividad, condicion, alergia, dieta, comidas)
select id, 72, 168, 35, 'bajar',     'sedentario','diabetes',    'ninguna', 'omnivora',    '5' from runners where nickname='Sofi'       on conflict (rid) do nothing;
insert into nutrition (rid, peso, talla, edad, objetivo, nivel_actividad, condicion, alergia, dieta, comidas)
select id, 55, 158, 24, 'mantener',  'moderado',  'ninguna',     'lactosa', 'vegetariana', '3' from runners where nickname='Gaby'       on conflict (rid) do nothing;
insert into nutrition (rid, peso, talla, edad, objetivo, nivel_actividad, condicion, alergia, dieta, comidas)
select id, 65, 165, 31, 'ganar',     'leve',      'ninguna',     'ninguna', 'omnivora',    '4' from runners where nickname='Caro'       on conflict (rid) do nothing;
insert into nutrition (rid, peso, talla, edad, objetivo, nivel_actividad, condicion, alergia, dieta, comidas)
select id, 68, 160, 42, 'bajar',     'sedentario','hipertension','ninguna', 'omnivora',    '3' from runners where nickname='Paty'       on conflict (rid) do nothing;
insert into nutrition (rid, peso, talla, edad, objetivo, nivel_actividad, condicion, alergia, dieta, comidas)
select id, 60, 170, 27, 'energia',   'moderado',  'ninguna',     'ninguna', 'omnivora',    '5' from runners where nickname='Fer'        on conflict (rid) do nothing;
insert into nutrition (rid, peso, talla, edad, objetivo, nivel_actividad, condicion, alergia, dieta, comidas)
select id, 75, 163, 38, 'bajar',     'leve',      'colesterol',  'ninguna', 'omnivora',    '4' from runners where nickname='Vale'       on conflict (rid) do nothing;
insert into nutrition (rid, peso, talla, edad, objetivo, nivel_actividad, condicion, alergia, dieta, comidas)
select id, 52, 155, 22, 'mantener',  'moderado',  'ninguna',     'gluten',  'omnivora',    '3' from runners where nickname='Pau'        on conflict (rid) do nothing;
insert into nutrition (rid, peso, talla, edad, objetivo, nivel_actividad, condicion, alergia, dieta, comidas)
select id, 63, 164, 33, 'energia',   'leve',      'anemia',      'ninguna', 'omnivora',    '4' from runners where nickname='Mari'       on conflict (rid) do nothing;
insert into nutrition (rid, peso, talla, edad, objetivo, nivel_actividad, condicion, alergia, dieta, comidas)
select id, 58, 159, 29, 'mantener',  'leve',      'ninguna',     'ninguna', 'vegana',      '5' from runners where nickname='Ale'        on conflict (rid) do nothing;
