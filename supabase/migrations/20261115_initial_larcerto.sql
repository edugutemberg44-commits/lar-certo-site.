-- Lar Certo: esquema inicial. Executar somente após revisar o banco existente.
create extension if not exists pgcrypto;
create table if not exists public.profiles (id uuid primary key references auth.users(id) on delete cascade,full_name text,email text,phone text,created_at timestamptz not null default now());
create table if not exists public.service_orders (id uuid primary key default gen_random_uuid(),customer_id uuid not null references auth.users(id),plan text not null check(plan in ('essencial','pro')),amount integer not null check(amount>0),currency text not null default 'brl' check(currency='brl'),payment_status text not null default 'pending' check(payment_status in ('pending','paid','failed','refunded','cancelled')),production_status text not null default 'awaiting_payment' check(production_status in ('awaiting_payment','awaiting_photos','photos_received','reviewing','in_production','in_revision','completed','cancelled')),stripe_checkout_session_id text unique,stripe_payment_intent_id text unique,estimated_delivery_at timestamptz,created_at timestamptz not null default now(),updated_at timestamptz not null default now());
create table if not exists public.quiz_responses(id uuid primary key default gen_random_uuid(),order_id uuid not null unique references public.service_orders(id) on delete cascade,customer_id uuid not null references auth.users(id),answers jsonb not null default '{}'::jsonb,created_at timestamptz not null default now());
create table if not exists public.order_files(id uuid primary key default gen_random_uuid(),order_id uuid not null references public.service_orders(id) on delete cascade,customer_id uuid not null references auth.users(id),storage_path text not null unique,file_type text not null,file_size bigint not null check(file_size>=0),file_role text not null check(file_role in ('original','delivery')),created_at timestamptz not null default now());
create table if not exists public.order_updates(id uuid primary key default gen_random_uuid(),order_id uuid not null references public.service_orders(id) on delete cascade,status text not null,message text,created_at timestamptz not null default now());
create table if not exists public.payment_events(id uuid primary key default gen_random_uuid(),stripe_event_id text not null unique,event_type text not null,order_id uuid references public.service_orders(id),processed_at timestamptz not null default now());
create table if not exists public.admin_users(user_id uuid primary key references auth.users(id) on delete cascade,role text not null check(role in ('admin','staff')),created_at timestamptz not null default now());
create index if not exists service_orders_customer_idx on public.service_orders(customer_id,created_at desc);
create index if not exists order_files_order_idx on public.order_files(order_id);
create index if not exists order_updates_order_idx on public.order_updates(order_id);
create index if not exists quiz_responses_customer_idx on public.quiz_responses(customer_id);
create or replace function public.is_larcerto_admin() returns boolean language sql stable security definer set search_path='' as $$ select exists(select 1 from public.admin_users where user_id=(select auth.uid()) and role='admin') $$;
revoke all on function public.is_larcerto_admin() from public;
grant execute on function public.is_larcerto_admin() to authenticated;
alter table public.profiles enable row level security;
alter table public.service_orders enable row level security;
alter table public.quiz_responses enable row level security;
alter table public.order_files enable row level security;
alter table public.order_updates enable row level security;
alter table public.payment_events enable row level security;
alter table public.admin_users enable row level security;
create policy "profile owner reads" on public.profiles for select to authenticated using(id=(select auth.uid()) or public.is_larcerto_admin());
create policy "profile owner inserts" on public.profiles for insert to authenticated with check(id=(select auth.uid()));
create policy "profile owner updates" on public.profiles for update to authenticated using(id=(select auth.uid())) with check(id=(select auth.uid()));
create policy "orders owner reads" on public.service_orders for select to authenticated using(customer_id=(select auth.uid()) or public.is_larcerto_admin());
create policy "quiz owner reads" on public.quiz_responses for select to authenticated using(customer_id=(select auth.uid()) or public.is_larcerto_admin());
create policy "files owner reads" on public.order_files for select to authenticated using(customer_id=(select auth.uid()) or public.is_larcerto_admin());
create policy "updates owner reads" on public.order_updates for select to authenticated using(exists(select 1 from public.service_orders o where o.id=order_id and (o.customer_id=(select auth.uid()) or public.is_larcerto_admin())));
create policy "admins read self" on public.admin_users for select to authenticated using(user_id=(select auth.uid()) or public.is_larcerto_admin());
-- Deliberadamente sem INSERT/UPDATE público em pedidos, pagamentos e arquivos.
-- Todas as mutações financeiras e permissões de upload devem passar por backend verificado.
-- Bucket privado e políticas Storage dependem de inspeção das políticas existentes.
