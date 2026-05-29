-- KF-001 Auth, organization, centre, roles, and RLS foundation.
-- Synthetic/dev foundation only. Do not insert real child, family, staff, billing, medical, photo, or incident data.

create extension if not exists pgcrypto;
create extension if not exists citext;

do $$
begin
  if not exists (select 1 from pg_type where typname = 'app_role') then
    create type public.app_role as enum ('owner', 'director', 'admin', 'staff', 'guardian', 'support');
  end if;

  if not exists (select 1 from pg_type where typname = 'record_status') then
    create type public.record_status as enum ('active', 'inactive', 'archived', 'deleted');
  end if;

  if not exists (select 1 from pg_type where typname = 'membership_status') then
    create type public.membership_status as enum ('invited', 'active', 'suspended', 'removed');
  end if;

  if not exists (select 1 from pg_type where typname = 'centre_status') then
    create type public.centre_status as enum ('active', 'inactive', 'archived');
  end if;

  if not exists (select 1 from pg_type where typname = 'staff_status') then
    create type public.staff_status as enum ('active', 'inactive', 'terminated', 'archived');
  end if;

  if not exists (select 1 from pg_type where typname = 'child_status') then
    create type public.child_status as enum ('active', 'graduated', 'deactivated', 'deleted');
  end if;

  if not exists (select 1 from pg_type where typname = 'classroom_status') then
    create type public.classroom_status as enum ('active', 'inactive', 'archived');
  end if;

  if not exists (select 1 from pg_type where typname = 'classroom_session_status') then
    create type public.classroom_session_status as enum ('active', 'closed', 'expired');
  end if;

  if not exists (select 1 from pg_type where typname = 'guardian_relationship') then
    create type public.guardian_relationship as enum (
      'mother',
      'father',
      'parent',
      'guardian',
      'foster_parent',
      'grandparent',
      'relative',
      'other'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'audit_actor_type') then
    create type public.audit_actor_type as enum (
      'auth_user',
      'staff_profile',
      'classroom_device_session',
      'system'
    );
  end if;
end $$;

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create table public.organizations (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  legal_name text,
  slug text not null unique,
  status public.record_status not null default 'active',
  default_country text not null default 'CA',
  default_timezone text not null default 'America/Edmonton',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint organizations_default_country_check check (default_country = 'CA')
);

create table public.centres (
  id uuid primary key default gen_random_uuid(),
  org_id uuid not null references public.organizations(id) on delete restrict,
  name text not null,
  slug text not null,
  status public.centre_status not null default 'active',
  address_line1 text,
  address_line2 text,
  city text,
  province text,
  postal_code text,
  country text not null default 'CA',
  phone text,
  email citext,
  timezone text not null default 'America/Edmonton',
  capacity integer,
  license_number text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint centres_country_check check (country = 'CA'),
  constraint centres_capacity_check check (capacity is null or capacity >= 0),
  constraint centres_org_slug_key unique (org_id, slug)
);

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email citext not null unique,
  first_name text,
  last_name text,
  display_name text,
  phone text,
  avatar_path text,
  status public.record_status not null default 'active',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.organization_memberships (
  id uuid primary key default gen_random_uuid(),
  org_id uuid not null references public.organizations(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  role public.app_role not null,
  status public.membership_status not null default 'active',
  created_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint organization_memberships_unique_role unique (org_id, user_id, role)
);

create table public.centre_memberships (
  id uuid primary key default gen_random_uuid(),
  org_id uuid not null references public.organizations(id) on delete cascade,
  centre_id uuid not null references public.centres(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  role public.app_role not null,
  status public.membership_status not null default 'active',
  created_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint centre_memberships_unique_role unique (centre_id, user_id, role)
);

create table public.classrooms (
  id uuid primary key default gen_random_uuid(),
  org_id uuid not null references public.organizations(id) on delete cascade,
  centre_id uuid not null references public.centres(id) on delete cascade,
  name text not null,
  slug text not null,
  age_group text,
  capacity integer,
  ratio_label text,
  status public.classroom_status not null default 'active',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint classrooms_capacity_check check (capacity is null or capacity >= 0),
  constraint classrooms_centre_slug_key unique (centre_id, slug)
);

create table public.staff_profiles (
  id uuid primary key default gen_random_uuid(),
  org_id uuid not null references public.organizations(id) on delete cascade,
  centre_id uuid not null references public.centres(id) on delete cascade,
  auth_user_id uuid references public.profiles(id) on delete set null,
  first_name text not null,
  last_name text not null,
  preferred_name text,
  email citext,
  phone text,
  title text,
  status public.staff_status not null default 'active',
  default_classroom_id uuid references public.classrooms(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.guardian_profiles (
  id uuid primary key default gen_random_uuid(),
  org_id uuid not null references public.organizations(id) on delete cascade,
  centre_id uuid not null references public.centres(id) on delete cascade,
  auth_user_id uuid references public.profiles(id) on delete set null,
  first_name text not null,
  last_name text not null,
  email citext,
  phone text,
  status public.record_status not null default 'active',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.children (
  id uuid primary key default gen_random_uuid(),
  org_id uuid not null references public.organizations(id) on delete restrict,
  centre_id uuid not null references public.centres(id) on delete restrict,
  current_classroom_id uuid references public.classrooms(id) on delete set null,
  first_name text not null,
  last_name text not null,
  preferred_name text,
  date_of_birth date,
  status public.child_status not null default 'active',
  graduated_at timestamptz,
  deactivated_at timestamptz,
  deleted_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint children_deleted_timestamp_check check (status <> 'deleted' or deleted_at is not null)
);

create table public.child_guardians (
  id uuid primary key default gen_random_uuid(),
  org_id uuid not null references public.organizations(id) on delete cascade,
  centre_id uuid not null references public.centres(id) on delete cascade,
  child_id uuid not null references public.children(id) on delete restrict,
  guardian_profile_id uuid not null references public.guardian_profiles(id) on delete restrict,
  relationship public.guardian_relationship not null default 'guardian',
  is_primary boolean not null default false,
  is_emergency_contact boolean not null default false,
  is_authorized_pickup boolean not null default false,
  can_view_profile boolean not null default true,
  can_view_billing boolean not null default true,
  can_view_photos boolean not null default true,
  can_view_reports boolean not null default true,
  can_view_messages boolean not null default true,
  can_message_staff boolean not null default true,
  status public.record_status not null default 'active',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint child_guardians_child_guardian_key unique (child_id, guardian_profile_id)
);

create table public.classroom_staff_assignments (
  id uuid primary key default gen_random_uuid(),
  org_id uuid not null references public.organizations(id) on delete cascade,
  centre_id uuid not null references public.centres(id) on delete cascade,
  staff_profile_id uuid not null references public.staff_profiles(id) on delete cascade,
  classroom_id uuid not null references public.classrooms(id) on delete cascade,
  is_default boolean not null default false,
  starts_on date,
  ends_on date,
  status public.record_status not null default 'active',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.classroom_device_sessions (
  id uuid primary key default gen_random_uuid(),
  org_id uuid not null references public.organizations(id) on delete cascade,
  centre_id uuid not null references public.centres(id) on delete cascade,
  classroom_id uuid not null references public.classrooms(id) on delete cascade,
  session_label text,
  device_name text,
  status public.classroom_session_status not null default 'active',
  opened_at timestamptz not null default now(),
  closed_at timestamptz,
  expires_at timestamptz,
  opened_by_user_id uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.classroom_staff_movements (
  id uuid primary key default gen_random_uuid(),
  org_id uuid not null references public.organizations(id) on delete cascade,
  centre_id uuid not null references public.centres(id) on delete cascade,
  staff_profile_id uuid not null references public.staff_profiles(id) on delete cascade,
  from_classroom_id uuid references public.classrooms(id) on delete set null,
  to_classroom_id uuid not null references public.classrooms(id) on delete restrict,
  moved_at timestamptz not null default now(),
  moved_by_user_id uuid references public.profiles(id) on delete set null,
  moved_by_staff_profile_id uuid references public.staff_profiles(id) on delete set null,
  moved_by_session_id uuid references public.classroom_device_sessions(id) on delete set null,
  reason text,
  created_at timestamptz not null default now()
);

create table public.classroom_child_enrollments (
  id uuid primary key default gen_random_uuid(),
  org_id uuid not null references public.organizations(id) on delete cascade,
  centre_id uuid not null references public.centres(id) on delete cascade,
  child_id uuid not null references public.children(id) on delete restrict,
  classroom_id uuid not null references public.classrooms(id) on delete restrict,
  starts_on date not null,
  ends_on date,
  status public.record_status not null default 'active',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.classroom_child_movements (
  id uuid primary key default gen_random_uuid(),
  org_id uuid not null references public.organizations(id) on delete cascade,
  centre_id uuid not null references public.centres(id) on delete cascade,
  child_id uuid not null references public.children(id) on delete restrict,
  from_classroom_id uuid references public.classrooms(id) on delete set null,
  to_classroom_id uuid not null references public.classrooms(id) on delete restrict,
  moved_at timestamptz not null default now(),
  moved_by_user_id uuid references public.profiles(id) on delete set null,
  moved_by_staff_profile_id uuid references public.staff_profiles(id) on delete set null,
  moved_by_session_id uuid references public.classroom_device_sessions(id) on delete set null,
  reason text,
  created_at timestamptz not null default now()
);

create table public.permission_definitions (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  domain text not null,
  surface text not null,
  action text not null,
  description text,
  risk_level text not null default 'normal',
  created_at timestamptz not null default now(),
  constraint permission_definitions_risk_level_check check (risk_level in ('normal', 'sensitive', 'high'))
);

create table public.role_permissions (
  id uuid primary key default gen_random_uuid(),
  role public.app_role not null,
  permission_definition_id uuid not null references public.permission_definitions(id) on delete cascade,
  allowed boolean not null default true,
  created_at timestamptz not null default now(),
  constraint role_permissions_role_permission_key unique (role, permission_definition_id)
);

create table public.member_permission_overrides (
  id uuid primary key default gen_random_uuid(),
  org_id uuid not null references public.organizations(id) on delete cascade,
  centre_id uuid references public.centres(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  permission_definition_id uuid not null references public.permission_definitions(id) on delete cascade,
  allowed boolean not null,
  reason text,
  created_by uuid references public.profiles(id) on delete set null,
  expires_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint member_permission_overrides_unique_key unique (org_id, centre_id, user_id, permission_definition_id)
);

create table public.audit_events (
  id uuid primary key default gen_random_uuid(),
  org_id uuid references public.organizations(id) on delete set null,
  centre_id uuid references public.centres(id) on delete set null,
  actor_type public.audit_actor_type not null,
  actor_user_id uuid references public.profiles(id) on delete set null,
  actor_staff_profile_id uuid references public.staff_profiles(id) on delete set null,
  actor_classroom_device_session_id uuid references public.classroom_device_sessions(id) on delete set null,
  action text not null,
  resource_type text not null,
  resource_id uuid,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

alter table public.centres
  add constraint centres_id_org_id_key unique (id, org_id);

alter table public.centre_memberships
  add constraint centre_memberships_centre_org_fk
    foreign key (centre_id, org_id) references public.centres(id, org_id) on delete cascade;

alter table public.classrooms
  add constraint classrooms_id_org_centre_key unique (id, org_id, centre_id),
  add constraint classrooms_centre_org_fk
    foreign key (centre_id, org_id) references public.centres(id, org_id) on delete cascade;

alter table public.staff_profiles
  add constraint staff_profiles_id_org_centre_key unique (id, org_id, centre_id),
  add constraint staff_profiles_centre_org_fk
    foreign key (centre_id, org_id) references public.centres(id, org_id) on delete cascade,
  add constraint staff_profiles_default_classroom_scope_fk
    foreign key (default_classroom_id, org_id, centre_id) references public.classrooms(id, org_id, centre_id) on delete restrict;

alter table public.guardian_profiles
  add constraint guardian_profiles_id_org_centre_key unique (id, org_id, centre_id),
  add constraint guardian_profiles_centre_org_fk
    foreign key (centre_id, org_id) references public.centres(id, org_id) on delete cascade;

alter table public.children
  add constraint children_id_org_centre_key unique (id, org_id, centre_id),
  add constraint children_centre_org_fk
    foreign key (centre_id, org_id) references public.centres(id, org_id) on delete restrict,
  add constraint children_current_classroom_scope_fk
    foreign key (current_classroom_id, org_id, centre_id) references public.classrooms(id, org_id, centre_id) on delete restrict;

alter table public.child_guardians
  add constraint child_guardians_child_scope_fk
    foreign key (child_id, org_id, centre_id) references public.children(id, org_id, centre_id) on delete restrict,
  add constraint child_guardians_guardian_scope_fk
    foreign key (guardian_profile_id, org_id, centre_id) references public.guardian_profiles(id, org_id, centre_id) on delete restrict;

alter table public.classroom_staff_assignments
  add constraint classroom_staff_assignments_staff_scope_fk
    foreign key (staff_profile_id, org_id, centre_id) references public.staff_profiles(id, org_id, centre_id) on delete cascade,
  add constraint classroom_staff_assignments_classroom_scope_fk
    foreign key (classroom_id, org_id, centre_id) references public.classrooms(id, org_id, centre_id) on delete cascade;

alter table public.classroom_device_sessions
  add constraint classroom_device_sessions_id_org_centre_key unique (id, org_id, centre_id),
  add constraint classroom_device_sessions_classroom_scope_fk
    foreign key (classroom_id, org_id, centre_id) references public.classrooms(id, org_id, centre_id) on delete cascade;

alter table public.classroom_staff_movements
  add constraint classroom_staff_movements_staff_scope_fk
    foreign key (staff_profile_id, org_id, centre_id) references public.staff_profiles(id, org_id, centre_id) on delete cascade,
  add constraint classroom_staff_movements_from_classroom_scope_fk
    foreign key (from_classroom_id, org_id, centre_id) references public.classrooms(id, org_id, centre_id) on delete restrict,
  add constraint classroom_staff_movements_to_classroom_scope_fk
    foreign key (to_classroom_id, org_id, centre_id) references public.classrooms(id, org_id, centre_id) on delete restrict,
  add constraint classroom_staff_movements_session_scope_fk
    foreign key (moved_by_session_id, org_id, centre_id) references public.classroom_device_sessions(id, org_id, centre_id) on delete restrict;

alter table public.classroom_child_enrollments
  add constraint classroom_child_enrollments_child_scope_fk
    foreign key (child_id, org_id, centre_id) references public.children(id, org_id, centre_id) on delete restrict,
  add constraint classroom_child_enrollments_classroom_scope_fk
    foreign key (classroom_id, org_id, centre_id) references public.classrooms(id, org_id, centre_id) on delete restrict;

alter table public.classroom_child_movements
  add constraint classroom_child_movements_child_scope_fk
    foreign key (child_id, org_id, centre_id) references public.children(id, org_id, centre_id) on delete restrict,
  add constraint classroom_child_movements_from_classroom_scope_fk
    foreign key (from_classroom_id, org_id, centre_id) references public.classrooms(id, org_id, centre_id) on delete restrict,
  add constraint classroom_child_movements_to_classroom_scope_fk
    foreign key (to_classroom_id, org_id, centre_id) references public.classrooms(id, org_id, centre_id) on delete restrict,
  add constraint classroom_child_movements_session_scope_fk
    foreign key (moved_by_session_id, org_id, centre_id) references public.classroom_device_sessions(id, org_id, centre_id) on delete restrict;

alter table public.member_permission_overrides
  add constraint member_permission_overrides_centre_org_fk
    foreign key (centre_id, org_id) references public.centres(id, org_id) on delete cascade;

alter table public.audit_events
  add constraint audit_events_centre_org_fk
    foreign key (centre_id, org_id) references public.centres(id, org_id) on delete restrict;

create index centres_org_id_idx on public.centres(org_id);
create index organization_memberships_user_id_idx on public.organization_memberships(user_id);
create index organization_memberships_org_role_idx on public.organization_memberships(org_id, role, status);
create index centre_memberships_user_id_idx on public.centre_memberships(user_id);
create index centre_memberships_centre_role_idx on public.centre_memberships(centre_id, role, status);
create index classrooms_centre_id_idx on public.classrooms(centre_id);
create index staff_profiles_centre_id_idx on public.staff_profiles(centre_id);
create index staff_profiles_auth_user_id_idx on public.staff_profiles(auth_user_id);
create index guardian_profiles_centre_id_idx on public.guardian_profiles(centre_id);
create index guardian_profiles_auth_user_id_idx on public.guardian_profiles(auth_user_id);
create index children_centre_id_idx on public.children(centre_id);
create index children_current_classroom_id_idx on public.children(current_classroom_id);
create index child_guardians_child_id_idx on public.child_guardians(child_id);
create index child_guardians_guardian_profile_id_idx on public.child_guardians(guardian_profile_id);
create index classroom_staff_assignments_staff_idx on public.classroom_staff_assignments(staff_profile_id);
create index classroom_staff_assignments_classroom_idx on public.classroom_staff_assignments(classroom_id);
create unique index classroom_staff_assignments_one_default_idx
  on public.classroom_staff_assignments(staff_profile_id)
  where is_default and status = 'active';
create index classroom_device_sessions_classroom_idx on public.classroom_device_sessions(classroom_id);
create index classroom_child_enrollments_child_idx on public.classroom_child_enrollments(child_id);
create index classroom_child_enrollments_classroom_idx on public.classroom_child_enrollments(classroom_id);
create unique index classroom_child_enrollments_one_active_idx
  on public.classroom_child_enrollments(child_id)
  where status = 'active' and ends_on is null;
create index member_permission_overrides_user_idx on public.member_permission_overrides(user_id);
create unique index member_permission_overrides_unique_scope_idx
  on public.member_permission_overrides(
    org_id,
    coalesce(centre_id, '00000000-0000-0000-0000-000000000000'::uuid),
    user_id,
    permission_definition_id
  );
create index audit_events_org_centre_created_idx on public.audit_events(org_id, centre_id, created_at desc);
create index audit_events_resource_idx on public.audit_events(resource_type, resource_id);

create trigger organizations_set_updated_at
before update on public.organizations
for each row execute function public.set_updated_at();

create trigger centres_set_updated_at
before update on public.centres
for each row execute function public.set_updated_at();

create trigger profiles_set_updated_at
before update on public.profiles
for each row execute function public.set_updated_at();

create trigger organization_memberships_set_updated_at
before update on public.organization_memberships
for each row execute function public.set_updated_at();

create trigger centre_memberships_set_updated_at
before update on public.centre_memberships
for each row execute function public.set_updated_at();

create trigger classrooms_set_updated_at
before update on public.classrooms
for each row execute function public.set_updated_at();

create trigger staff_profiles_set_updated_at
before update on public.staff_profiles
for each row execute function public.set_updated_at();

create trigger guardian_profiles_set_updated_at
before update on public.guardian_profiles
for each row execute function public.set_updated_at();

create trigger children_set_updated_at
before update on public.children
for each row execute function public.set_updated_at();

create trigger child_guardians_set_updated_at
before update on public.child_guardians
for each row execute function public.set_updated_at();

create trigger classroom_staff_assignments_set_updated_at
before update on public.classroom_staff_assignments
for each row execute function public.set_updated_at();

create trigger classroom_device_sessions_set_updated_at
before update on public.classroom_device_sessions
for each row execute function public.set_updated_at();

create trigger classroom_child_enrollments_set_updated_at
before update on public.classroom_child_enrollments
for each row execute function public.set_updated_at();

create trigger member_permission_overrides_set_updated_at
before update on public.member_permission_overrides
for each row execute function public.set_updated_at();

create or replace function public.current_user_id()
returns uuid
language sql
stable
as $$
  select auth.uid();
$$;

create or replace function public.is_org_member(target_org_id uuid, allowed_roles public.app_role[] default null)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.organization_memberships om
    where om.org_id = target_org_id
      and om.user_id = public.current_user_id()
      and om.status = 'active'
      and (allowed_roles is null or om.role = any(allowed_roles))
  );
$$;

create or replace function public.is_centre_member(target_centre_id uuid, allowed_roles public.app_role[] default null)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.centre_memberships cm
    where cm.centre_id = target_centre_id
      and cm.user_id = public.current_user_id()
      and cm.status = 'active'
      and (allowed_roles is null or cm.role = any(allowed_roles))
  );
$$;

create or replace function public.is_owner_director_admin(target_centre_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.centre_memberships cm
    where cm.centre_id = target_centre_id
      and cm.user_id = public.current_user_id()
      and cm.status = 'active'
      and cm.role in ('owner', 'director', 'admin')
  )
  or exists (
    select 1
    from public.centres c
    join public.organization_memberships om on om.org_id = c.org_id
    where c.id = target_centre_id
      and om.user_id = public.current_user_id()
      and om.status = 'active'
      and om.role = 'owner'
  );
$$;

create or replace function public.can_manage_centre_membership(target_centre_id uuid, target_role public.app_role)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.centre_memberships cm
    where cm.centre_id = target_centre_id
      and cm.user_id = public.current_user_id()
      and cm.status = 'active'
      and cm.role in ('owner', 'director')
  )
  or exists (
    select 1
    from public.centres c
    join public.organization_memberships om on om.org_id = c.org_id
    where c.id = target_centre_id
      and om.user_id = public.current_user_id()
      and om.status = 'active'
      and om.role = 'owner'
  )
  or (
    target_role = 'staff'
    and exists (
      select 1
      from public.centre_memberships cm
      where cm.centre_id = target_centre_id
        and cm.user_id = public.current_user_id()
        and cm.status = 'active'
        and cm.role = 'admin'
    )
  );
$$;

create or replace function public.can_read_child(target_child_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.children c
    where c.id = target_child_id
      and c.status <> 'deleted'
      and (
        public.is_owner_director_admin(c.centre_id)
        or exists (
          select 1
          from public.child_guardians cg
          join public.guardian_profiles gp on gp.id = cg.guardian_profile_id
          where cg.child_id = c.id
            and cg.status = 'active'
            and cg.can_view_profile
            and gp.status = 'active'
            and gp.auth_user_id = public.current_user_id()
        )
        or exists (
          select 1
          from public.staff_profiles sp
          join public.classroom_staff_assignments csa on csa.staff_profile_id = sp.id
          where sp.auth_user_id = public.current_user_id()
            and sp.status = 'active'
            and csa.status = 'active'
            and csa.classroom_id = c.current_classroom_id
        )
      )
  );
$$;

create or replace function public.can_read_child_billing(target_child_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.children c
    where c.id = target_child_id
      and c.status <> 'deleted'
      and (
        public.is_owner_director_admin(c.centre_id)
        or exists (
          select 1
          from public.child_guardians cg
          join public.guardian_profiles gp on gp.id = cg.guardian_profile_id
          where cg.child_id = c.id
            and cg.status = 'active'
            and cg.can_view_billing
            and gp.status = 'active'
            and gp.auth_user_id = public.current_user_id()
        )
      )
  );
$$;

create or replace function public.can_read_child_photos(target_child_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.children c
    where c.id = target_child_id
      and c.status <> 'deleted'
      and (
        public.is_owner_director_admin(c.centre_id)
        or exists (
          select 1
          from public.child_guardians cg
          join public.guardian_profiles gp on gp.id = cg.guardian_profile_id
          where cg.child_id = c.id
            and cg.status = 'active'
            and cg.can_view_photos
            and gp.status = 'active'
            and gp.auth_user_id = public.current_user_id()
        )
      )
  );
$$;

create or replace function public.can_read_child_reports(target_child_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.children c
    where c.id = target_child_id
      and c.status <> 'deleted'
      and (
        public.is_owner_director_admin(c.centre_id)
        or exists (
          select 1
          from public.child_guardians cg
          join public.guardian_profiles gp on gp.id = cg.guardian_profile_id
          where cg.child_id = c.id
            and cg.status = 'active'
            and cg.can_view_reports
            and gp.status = 'active'
            and gp.auth_user_id = public.current_user_id()
        )
      )
  );
$$;

create or replace function public.can_message_for_child(target_child_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.children c
    where c.id = target_child_id
      and c.status <> 'deleted'
      and (
        public.is_owner_director_admin(c.centre_id)
        or exists (
          select 1
          from public.child_guardians cg
          join public.guardian_profiles gp on gp.id = cg.guardian_profile_id
          where cg.child_id = c.id
            and cg.status = 'active'
            and cg.can_view_messages
            and cg.can_message_staff
            and gp.status = 'active'
            and gp.auth_user_id = public.current_user_id()
        )
      )
  );
$$;

create or replace function public.has_permission(
  permission_code text,
  target_org_id uuid,
  target_centre_id uuid default null
)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  with selected_permission as (
    select pd.id
    from public.permission_definitions pd
    where pd.code = permission_code
  ),
  active_roles as (
    select om.role
    from public.organization_memberships om
    where om.org_id = target_org_id
      and om.user_id = public.current_user_id()
      and om.status = 'active'
    union
    select cm.role
    from public.centre_memberships cm
    where cm.org_id = target_org_id
      and (target_centre_id is null or cm.centre_id = target_centre_id)
      and cm.user_id = public.current_user_id()
      and cm.status = 'active'
    union
    select 'guardian'::public.app_role
    from public.guardian_profiles gp
    where gp.org_id = target_org_id
      and (target_centre_id is null or gp.centre_id = target_centre_id)
      and gp.auth_user_id = public.current_user_id()
      and gp.status = 'active'
  ),
  explicit_override as (
    select mpo.allowed
    from public.member_permission_overrides mpo
    join selected_permission sp on sp.id = mpo.permission_definition_id
    where mpo.org_id = target_org_id
      and (
        (target_centre_id is null and mpo.centre_id is null)
        or mpo.centre_id = target_centre_id
      )
      and mpo.user_id = public.current_user_id()
      and (mpo.expires_at is null or mpo.expires_at > now())
    order by case when mpo.centre_id is not null then 0 else 1 end
    limit 1
  )
  select coalesce(
    (select allowed from explicit_override),
    exists (
      select 1
      from active_roles ar
      join public.role_permissions rp on rp.role = ar.role
      join selected_permission sp on sp.id = rp.permission_definition_id
      where rp.allowed
    ),
    false
  );
$$;

alter table public.organizations enable row level security;
alter table public.centres enable row level security;
alter table public.profiles enable row level security;
alter table public.organization_memberships enable row level security;
alter table public.centre_memberships enable row level security;
alter table public.classrooms enable row level security;
alter table public.staff_profiles enable row level security;
alter table public.guardian_profiles enable row level security;
alter table public.children enable row level security;
alter table public.child_guardians enable row level security;
alter table public.classroom_staff_assignments enable row level security;
alter table public.classroom_staff_movements enable row level security;
alter table public.classroom_device_sessions enable row level security;
alter table public.classroom_child_enrollments enable row level security;
alter table public.classroom_child_movements enable row level security;
alter table public.permission_definitions enable row level security;
alter table public.role_permissions enable row level security;
alter table public.member_permission_overrides enable row level security;
alter table public.audit_events enable row level security;

create policy organizations_select_member
on public.organizations
for select
to authenticated
using (
  public.is_org_member(id)
  or exists (
    select 1
    from public.centre_memberships cm
    where cm.org_id = organizations.id
      and cm.user_id = public.current_user_id()
      and cm.status = 'active'
  )
);

create policy organizations_update_owner
on public.organizations
for update
to authenticated
using (public.is_org_member(id, array['owner']::public.app_role[]))
with check (public.is_org_member(id, array['owner']::public.app_role[]));

create policy centres_select_scoped
on public.centres
for select
to authenticated
using (
  public.is_org_member(org_id)
  or public.is_centre_member(id)
  or exists (
    select 1
    from public.children c
    join public.child_guardians cg on cg.child_id = c.id
    join public.guardian_profiles gp on gp.id = cg.guardian_profile_id
    where c.centre_id = centres.id
      and cg.status = 'active'
      and gp.status = 'active'
      and gp.auth_user_id = public.current_user_id()
  )
);

create policy centres_write_admin
on public.centres
for update
to authenticated
using (public.is_owner_director_admin(id))
with check (public.is_owner_director_admin(id));

create policy profiles_select_own_or_admin
on public.profiles
for select
to authenticated
using (
  id = public.current_user_id()
  or exists (
    select 1
    from public.centre_memberships admin_cm
    join public.centre_memberships target_cm on target_cm.centre_id = admin_cm.centre_id
    where admin_cm.user_id = public.current_user_id()
      and admin_cm.status = 'active'
      and admin_cm.role in ('owner', 'director', 'admin')
      and target_cm.user_id = profiles.id
      and target_cm.status = 'active'
  )
  or exists (
    select 1
    from public.centre_memberships admin_cm
    join public.guardian_profiles gp on gp.centre_id = admin_cm.centre_id
    where admin_cm.user_id = public.current_user_id()
      and admin_cm.status = 'active'
      and admin_cm.role in ('owner', 'director', 'admin')
      and gp.auth_user_id = profiles.id
  )
);

create policy profiles_update_own
on public.profiles
for update
to authenticated
using (id = public.current_user_id())
with check (id = public.current_user_id());

create policy organization_memberships_select_scoped
on public.organization_memberships
for select
to authenticated
using (
  user_id = public.current_user_id()
  or public.is_org_member(org_id, array['owner']::public.app_role[])
);

create policy organization_memberships_write_owner
on public.organization_memberships
for all
to authenticated
using (public.is_org_member(org_id, array['owner']::public.app_role[]))
with check (public.is_org_member(org_id, array['owner']::public.app_role[]));

create policy centre_memberships_select_scoped
on public.centre_memberships
for select
to authenticated
using (
  user_id = public.current_user_id()
  or public.is_owner_director_admin(centre_id)
);

create policy centre_memberships_write_admin
on public.centre_memberships
for all
to authenticated
using (public.can_manage_centre_membership(centre_id, role))
with check (public.can_manage_centre_membership(centre_id, role));

create policy classrooms_select_scoped
on public.classrooms
for select
to authenticated
using (
  public.is_owner_director_admin(centre_id)
  or exists (
    select 1
    from public.staff_profiles sp
    join public.classroom_staff_assignments csa on csa.staff_profile_id = sp.id
    where sp.auth_user_id = public.current_user_id()
      and sp.status = 'active'
      and csa.status = 'active'
      and csa.classroom_id = classrooms.id
  )
  or exists (
    select 1
    from public.children c
    join public.child_guardians cg on cg.child_id = c.id
    join public.guardian_profiles gp on gp.id = cg.guardian_profile_id
    where c.current_classroom_id = classrooms.id
      and cg.status = 'active'
      and gp.status = 'active'
      and gp.auth_user_id = public.current_user_id()
  )
);

create policy classrooms_write_admin
on public.classrooms
for all
to authenticated
using (public.is_owner_director_admin(centre_id))
with check (public.is_owner_director_admin(centre_id));

create policy staff_profiles_select_admin_or_self
on public.staff_profiles
for select
to authenticated
using (
  public.is_owner_director_admin(centre_id)
  or auth_user_id = public.current_user_id()
);

create policy staff_profiles_write_admin
on public.staff_profiles
for all
to authenticated
using (public.is_owner_director_admin(centre_id))
with check (public.is_owner_director_admin(centre_id));

create policy guardian_profiles_select_admin_or_self
on public.guardian_profiles
for select
to authenticated
using (
  public.is_owner_director_admin(centre_id)
  or auth_user_id = public.current_user_id()
);

create policy guardian_profiles_write_admin
on public.guardian_profiles
for all
to authenticated
using (public.is_owner_director_admin(centre_id))
with check (public.is_owner_director_admin(centre_id));

create policy children_select_scoped
on public.children
for select
to authenticated
using (public.can_read_child(id));

create policy children_write_admin
on public.children
for all
to authenticated
using (public.is_owner_director_admin(centre_id))
with check (public.is_owner_director_admin(centre_id));

create policy child_guardians_select_scoped
on public.child_guardians
for select
to authenticated
using (
  public.is_owner_director_admin(centre_id)
  or exists (
    select 1
    from public.guardian_profiles gp
    where gp.id = child_guardians.guardian_profile_id
      and gp.auth_user_id = public.current_user_id()
      and gp.status = 'active'
  )
);

create policy child_guardians_write_admin
on public.child_guardians
for all
to authenticated
using (public.is_owner_director_admin(centre_id))
with check (public.is_owner_director_admin(centre_id));

create policy classroom_staff_assignments_select_scoped
on public.classroom_staff_assignments
for select
to authenticated
using (
  public.is_owner_director_admin(centre_id)
  or exists (
    select 1
    from public.staff_profiles sp
    where sp.id = classroom_staff_assignments.staff_profile_id
      and sp.auth_user_id = public.current_user_id()
      and sp.status = 'active'
  )
);

create policy classroom_staff_assignments_write_admin
on public.classroom_staff_assignments
for all
to authenticated
using (public.is_owner_director_admin(centre_id))
with check (public.is_owner_director_admin(centre_id));

create policy classroom_staff_movements_select_admin_or_staff
on public.classroom_staff_movements
for select
to authenticated
using (
  public.is_owner_director_admin(centre_id)
  or exists (
    select 1
    from public.staff_profiles sp
    where sp.id = classroom_staff_movements.staff_profile_id
      and sp.auth_user_id = public.current_user_id()
      and sp.status = 'active'
  )
);

create policy classroom_staff_movements_insert_admin
on public.classroom_staff_movements
for insert
to authenticated
with check (public.is_owner_director_admin(centre_id));

create policy classroom_device_sessions_select_admin
on public.classroom_device_sessions
for select
to authenticated
using (public.is_owner_director_admin(centre_id));

create policy classroom_device_sessions_write_admin
on public.classroom_device_sessions
for all
to authenticated
using (public.is_owner_director_admin(centre_id))
with check (public.is_owner_director_admin(centre_id));

create policy classroom_child_enrollments_select_scoped
on public.classroom_child_enrollments
for select
to authenticated
using (
  public.is_owner_director_admin(centre_id)
  or public.can_read_child(child_id)
);

create policy classroom_child_enrollments_write_admin
on public.classroom_child_enrollments
for all
to authenticated
using (public.is_owner_director_admin(centre_id))
with check (public.is_owner_director_admin(centre_id));

create policy classroom_child_movements_select_scoped
on public.classroom_child_movements
for select
to authenticated
using (
  public.is_owner_director_admin(centre_id)
  or public.can_read_child(child_id)
);

create policy classroom_child_movements_insert_admin
on public.classroom_child_movements
for insert
to authenticated
with check (public.is_owner_director_admin(centre_id));

create policy permission_definitions_select_authenticated_member
on public.permission_definitions
for select
to authenticated
using (
  exists (
    select 1
    from public.organization_memberships om
    where om.user_id = public.current_user_id()
      and om.status = 'active'
  )
  or exists (
    select 1
    from public.centre_memberships cm
    where cm.user_id = public.current_user_id()
      and cm.status = 'active'
  )
  or exists (
    select 1
    from public.guardian_profiles gp
    where gp.auth_user_id = public.current_user_id()
      and gp.status = 'active'
  )
);

create policy role_permissions_select_authenticated_member
on public.role_permissions
for select
to authenticated
using (
  exists (
    select 1
    from public.organization_memberships om
    where om.user_id = public.current_user_id()
      and om.status = 'active'
  )
  or exists (
    select 1
    from public.centre_memberships cm
    where cm.user_id = public.current_user_id()
      and cm.status = 'active'
  )
  or exists (
    select 1
    from public.guardian_profiles gp
    where gp.auth_user_id = public.current_user_id()
      and gp.status = 'active'
  )
);

create policy member_permission_overrides_select_admin_or_self
on public.member_permission_overrides
for select
to authenticated
using (
  user_id = public.current_user_id()
  or (centre_id is not null and public.is_owner_director_admin(centre_id))
  or (centre_id is null and public.is_org_member(org_id, array['owner']::public.app_role[]))
);

create policy member_permission_overrides_write_admin
on public.member_permission_overrides
for all
to authenticated
using (
  (centre_id is not null and public.is_owner_director_admin(centre_id))
  or (centre_id is null and public.is_org_member(org_id, array['owner']::public.app_role[]))
)
with check (
  (centre_id is not null and public.is_owner_director_admin(centre_id))
  or (centre_id is null and public.is_org_member(org_id, array['owner']::public.app_role[]))
);

create policy audit_events_select_admin
on public.audit_events
for select
to authenticated
using (
  (centre_id is not null and public.is_owner_director_admin(centre_id))
  or (centre_id is null and org_id is not null and public.is_org_member(org_id, array['owner']::public.app_role[]))
);

grant usage on schema public to anon, authenticated;
grant select on all tables in schema public to anon, authenticated;
grant insert, update on all tables in schema public to authenticated;
grant execute on all functions in schema public to anon, authenticated;
