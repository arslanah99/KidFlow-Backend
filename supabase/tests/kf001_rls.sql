-- KF-001 manual RLS verification.
-- Run after `supabase db reset` with:
--   psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f supabase/tests/kf001_rls.sql

create or replace function pg_temp.kf_assert_eq(test_name text, actual bigint, expected bigint)
returns void
language plpgsql
as $$
begin
  if actual is distinct from expected then
    raise exception 'KF-001 RLS check failed: %, expected %, got %', test_name, expected, actual;
  end if;
end;
$$;

create or replace function pg_temp.kf_assert_true(test_name text, actual boolean)
returns void
language plpgsql
as $$
begin
  if actual is not true then
    raise exception 'KF-001 RLS check failed: %, expected true', test_name;
  end if;
end;
$$;

create or replace function pg_temp.kf_assert_false(test_name text, actual boolean)
returns void
language plpgsql
as $$
begin
  if actual is not false then
    raise exception 'KF-001 RLS check failed: %, expected false', test_name;
  end if;
end;
$$;

begin;
  set local role authenticated;
  select set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-000000000101', true);

  select pg_temp.kf_assert_eq('owner reads assigned organization only', count(*), 1)
  from public.organizations;

  select pg_temp.kf_assert_eq('owner reads assigned centre only', count(*), 1)
  from public.centres;

  select pg_temp.kf_assert_eq('owner reads assigned centre children only', count(*), 4)
  from public.children;

  select pg_temp.kf_assert_eq('owner reads assigned centre staff only', count(*), 4)
  from public.staff_profiles;

  select pg_temp.kf_assert_true(
    'owner has permission override capability',
    public.has_permission(
      'Permissions.Override',
      '10000000-0000-0000-0000-000000000001',
      '20000000-0000-0000-0000-000000000001'
    )
  );
rollback;

begin;
  set local role authenticated;
  select set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-000000000102', true);

  select pg_temp.kf_assert_eq('director reads assigned centre children only', count(*), 4)
  from public.children;

  select pg_temp.kf_assert_eq('director cannot read other organization child', count(*), 0)
  from public.children
  where id = '60000000-0000-0000-0000-000000000005';

  select pg_temp.kf_assert_true(
    'director has child move permission',
    public.has_permission(
      'Classroom.Children.Move',
      '10000000-0000-0000-0000-000000000001',
      '20000000-0000-0000-0000-000000000001'
    )
  );
rollback;

begin;
  set local role authenticated;
  select set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-000000000103', true);

  select pg_temp.kf_assert_eq('admin reads assigned centre children only', count(*), 4)
  from public.children;

  select pg_temp.kf_assert_eq('admin reads assigned centre guardians only', count(*), 2)
  from public.guardian_profiles;

  insert into public.centre_memberships (org_id, centre_id, user_id, role)
  values (
    '10000000-0000-0000-0000-000000000001',
    '20000000-0000-0000-0000-000000000001',
    '00000000-0000-0000-0000-000000000106',
    'staff'
  );

  do $$
  begin
    insert into public.centre_memberships (org_id, centre_id, user_id, role)
    values (
      '10000000-0000-0000-0000-000000000001',
      '20000000-0000-0000-0000-000000000001',
      '00000000-0000-0000-0000-000000000106',
      'director'
    );

    raise exception 'KF-001 RLS check failed: admin should not be able to create director/admin memberships';
  exception
    when insufficient_privilege then
      null;
  end $$;
rollback;

begin;
  set local role authenticated;
  select set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-000000000104', true);

  select pg_temp.kf_assert_eq('parent reads own linked children only', count(*), 2)
  from public.children;

  select pg_temp.kf_assert_eq('parent cannot read unrelated centre child', count(*), 0)
  from public.children
  where id in (
    '60000000-0000-0000-0000-000000000003',
    '60000000-0000-0000-0000-000000000004',
    '60000000-0000-0000-0000-000000000005'
  );

  select pg_temp.kf_assert_eq('parent reads own guardian profile only', count(*), 1)
  from public.guardian_profiles;

  select pg_temp.kf_assert_true(
    'parent has own child read permission through guardian role context',
    public.has_permission(
      'Children.Profile.Read',
      '10000000-0000-0000-0000-000000000001',
      '20000000-0000-0000-0000-000000000001'
    )
  );

  select pg_temp.kf_assert_false(
    'parent cannot manage permission overrides',
    public.has_permission(
      'Permissions.Override',
      '10000000-0000-0000-0000-000000000001',
      '20000000-0000-0000-0000-000000000001'
    )
  );
rollback;

begin;
  set local role authenticated;
  select set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-000000000105', true);

  select pg_temp.kf_assert_eq('restricted guardian reads linked child profile only', count(*), 1)
  from public.children;

  select pg_temp.kf_assert_false(
    'restricted guardian cannot read child billing',
    public.can_read_child_billing('60000000-0000-0000-0000-000000000004')
  );

  select pg_temp.kf_assert_false(
    'restricted guardian cannot read child photos',
    public.can_read_child_photos('60000000-0000-0000-0000-000000000004')
  );

  select pg_temp.kf_assert_true(
    'restricted guardian can read allowed reports',
    public.can_read_child_reports('60000000-0000-0000-0000-000000000004')
  );
rollback;

begin;
  set local role authenticated;
  select set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-000000000106', true);

  select pg_temp.kf_assert_eq('support has no default organization access', count(*), 0)
  from public.organizations;

  select pg_temp.kf_assert_eq('support has no default child access', count(*), 0)
  from public.children;

  select pg_temp.kf_assert_false(
    'support has no default audit read permission',
    public.has_permission(
      'Audit.Read',
      '10000000-0000-0000-0000-000000000001',
      '20000000-0000-0000-0000-000000000001'
    )
  );
rollback;

begin;
  set local role anon;
  select set_config('request.jwt.claim.sub', '', true);

  select pg_temp.kf_assert_eq('anonymous cannot enumerate children', count(*), 0)
  from public.children;

  select pg_temp.kf_assert_eq('anonymous cannot enumerate guardians', count(*), 0)
  from public.guardian_profiles;

  select pg_temp.kf_assert_eq('anonymous cannot enumerate staff', count(*), 0)
  from public.staff_profiles;
rollback;

select 'KF-001 RLS checks passed' as result;
