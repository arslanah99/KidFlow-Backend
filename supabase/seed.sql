-- KF-001 synthetic seed data.
-- All names, emails, phone numbers, and records in this file are fake test fixtures.

insert into auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at,
  is_anonymous
)
values
  ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000101', 'authenticated', 'authenticated', 'owner@test.kidflow.local', crypt('Password123!', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"first_name":"Olivia","last_name":"Owner"}'::jsonb, now(), now(), false),
  ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000102', 'authenticated', 'authenticated', 'director@test.kidflow.local', crypt('Password123!', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"first_name":"Lena","last_name":"Director"}'::jsonb, now(), now(), false),
  ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000103', 'authenticated', 'authenticated', 'admin@test.kidflow.local', crypt('Password123!', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"first_name":"Avery","last_name":"Admin"}'::jsonb, now(), now(), false),
  ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000104', 'authenticated', 'authenticated', 'parent@test.kidflow.local', crypt('Password123!', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"first_name":"Pat","last_name":"Parent"}'::jsonb, now(), now(), false),
  ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000105', 'authenticated', 'authenticated', 'restricted-parent@test.kidflow.local', crypt('Password123!', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"first_name":"Riley","last_name":"Restricted"}'::jsonb, now(), now(), false),
  ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000106', 'authenticated', 'authenticated', 'support@test.kidflow.local', crypt('Password123!', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}'::jsonb, '{"first_name":"Sam","last_name":"Support"}'::jsonb, now(), now(), false)
on conflict (id) do update
set
  email = excluded.email,
  encrypted_password = excluded.encrypted_password,
  updated_at = now();

insert into public.organizations (id, name, legal_name, slug)
values
  ('10000000-0000-0000-0000-000000000001', 'The Kids Planet', 'The Kids Planet Test Operator Ltd.', 'the-kids-planet'),
  ('10000000-0000-0000-0000-000000000002', 'Other Test Operator', 'Other Test Operator Ltd.', 'other-test-operator')
on conflict (id) do update
set name = excluded.name,
    legal_name = excluded.legal_name,
    slug = excluded.slug;

insert into public.centres (id, org_id, name, slug, city, province, country, timezone, capacity)
values
  ('20000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001', 'The Kids Planet Sunridge', 'sunridge', 'Calgary', 'AB', 'CA', 'America/Edmonton', 154),
  ('20000000-0000-0000-0000-000000000002', '10000000-0000-0000-0000-000000000002', 'Other Test Centre', 'other-test-centre', 'Calgary', 'AB', 'CA', 'America/Edmonton', 24)
on conflict (id) do update
set name = excluded.name,
    slug = excluded.slug,
    city = excluded.city,
    province = excluded.province,
    capacity = excluded.capacity;

insert into public.profiles (id, email, first_name, last_name, display_name)
values
  ('00000000-0000-0000-0000-000000000101', 'owner@test.kidflow.local', 'Olivia', 'Owner', 'Olivia Owner'),
  ('00000000-0000-0000-0000-000000000102', 'director@test.kidflow.local', 'Lena', 'Director', 'Lena Director'),
  ('00000000-0000-0000-0000-000000000103', 'admin@test.kidflow.local', 'Avery', 'Admin', 'Avery Admin'),
  ('00000000-0000-0000-0000-000000000104', 'parent@test.kidflow.local', 'Pat', 'Parent', 'Pat Parent'),
  ('00000000-0000-0000-0000-000000000105', 'restricted-parent@test.kidflow.local', 'Riley', 'Restricted', 'Riley Restricted'),
  ('00000000-0000-0000-0000-000000000106', 'support@test.kidflow.local', 'Sam', 'Support', 'Sam Support')
on conflict (id) do update
set email = excluded.email,
    first_name = excluded.first_name,
    last_name = excluded.last_name,
    display_name = excluded.display_name;

insert into public.organization_memberships (id, org_id, user_id, role)
values
  ('11000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000101', 'owner')
on conflict (id) do update
set role = excluded.role,
    status = 'active';

insert into public.centre_memberships (id, org_id, centre_id, user_id, role)
values
  ('21000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000101', 'owner'),
  ('21000000-0000-0000-0000-000000000002', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000102', 'director'),
  ('21000000-0000-0000-0000-000000000003', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000103', 'admin')
on conflict (id) do update
set role = excluded.role,
    status = 'active';

insert into public.classrooms (id, org_id, centre_id, name, slug, age_group, capacity, ratio_label)
values
  ('30000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', 'Tiny Stars', 'tiny-stars', 'Toddler', 16, '1:6'),
  ('30000000-0000-0000-0000-000000000002', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', 'Galaxy Gang', 'galaxy-gang', 'Preschool', 18, '1:8'),
  ('30000000-0000-0000-0000-000000000003', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', 'Milky Way Minis', 'milky-way-minis', 'Preschool', 18, '1:8'),
  ('30000000-0000-0000-0000-000000000004', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', 'Jupiter', 'jupiter', 'School Age', 20, '1:10'),
  ('30000000-0000-0000-0000-000000000005', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', 'Apollo', 'apollo', 'School Age', 20, '1:10'),
  ('30000000-0000-0000-0000-000000000006', '10000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000002', 'Other Test Room', 'other-test-room', 'Preschool', 10, '1:8')
on conflict (id) do update
set name = excluded.name,
    slug = excluded.slug,
    age_group = excluded.age_group,
    capacity = excluded.capacity,
    ratio_label = excluded.ratio_label;

insert into public.staff_profiles (id, org_id, centre_id, first_name, last_name, preferred_name, email, title, default_classroom_id)
values
  ('40000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', 'Diana', 'Park', 'Diana', 'diana.park@test.kidflow.local', 'Educator', '30000000-0000-0000-0000-000000000001'),
  ('40000000-0000-0000-0000-000000000002', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', 'Marcus', 'Lee', 'Marcus', 'marcus.lee@test.kidflow.local', 'Educator', '30000000-0000-0000-0000-000000000002'),
  ('40000000-0000-0000-0000-000000000003', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', 'Priya', 'Singh', 'Priya', 'priya.singh@test.kidflow.local', 'Educator', '30000000-0000-0000-0000-000000000003'),
  ('40000000-0000-0000-0000-000000000004', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', 'Naomi', 'Reyes', 'Naomi', 'naomi.reyes@test.kidflow.local', 'Educator', '30000000-0000-0000-0000-000000000004')
on conflict (id) do update
set first_name = excluded.first_name,
    last_name = excluded.last_name,
    preferred_name = excluded.preferred_name,
    email = excluded.email,
    title = excluded.title,
    default_classroom_id = excluded.default_classroom_id;

insert into public.guardian_profiles (id, org_id, centre_id, auth_user_id, first_name, last_name, email, phone)
values
  ('50000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000104', 'Pat', 'Parent', 'parent@test.kidflow.local', '555-0104'),
  ('50000000-0000-0000-0000-000000000002', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000105', 'Riley', 'Restricted', 'restricted-parent@test.kidflow.local', '555-0105')
on conflict (id) do update
set auth_user_id = excluded.auth_user_id,
    first_name = excluded.first_name,
    last_name = excluded.last_name,
    email = excluded.email,
    phone = excluded.phone;

insert into public.children (id, org_id, centre_id, current_classroom_id, first_name, last_name, preferred_name, date_of_birth)
values
  ('60000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', '30000000-0000-0000-0000-000000000001', 'Mia', 'Testchild', 'Mia', '2022-04-10'),
  ('60000000-0000-0000-0000-000000000002', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', '30000000-0000-0000-0000-000000000002', 'Aiden', 'Testchild', 'Aiden', '2021-11-02'),
  ('60000000-0000-0000-0000-000000000003', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', '30000000-0000-0000-0000-000000000003', 'Zoe', 'Testchild', 'Zoe', '2020-06-18'),
  ('60000000-0000-0000-0000-000000000004', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', '30000000-0000-0000-0000-000000000004', 'Theo', 'Testchild', 'Theo', '2019-09-23'),
  ('60000000-0000-0000-0000-000000000005', '10000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000002', '30000000-0000-0000-0000-000000000006', 'Una', 'Unrelatedtest', 'Una', '2021-01-11')
on conflict (id) do update
set current_classroom_id = excluded.current_classroom_id,
    first_name = excluded.first_name,
    last_name = excluded.last_name,
    preferred_name = excluded.preferred_name,
    date_of_birth = excluded.date_of_birth;

insert into public.child_guardians (
  id,
  org_id,
  centre_id,
  child_id,
  guardian_profile_id,
  relationship,
  is_primary,
  is_emergency_contact,
  is_authorized_pickup,
  can_view_profile,
  can_view_billing,
  can_view_photos,
  can_view_reports,
  can_view_messages,
  can_message_staff
)
values
  ('70000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', '60000000-0000-0000-0000-000000000001', '50000000-0000-0000-0000-000000000001', 'parent', true, true, true, true, true, true, true, true, true),
  ('70000000-0000-0000-0000-000000000002', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', '60000000-0000-0000-0000-000000000002', '50000000-0000-0000-0000-000000000001', 'parent', true, true, true, true, true, true, true, true, true),
  ('70000000-0000-0000-0000-000000000003', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', '60000000-0000-0000-0000-000000000004', '50000000-0000-0000-0000-000000000002', 'parent', false, false, false, true, false, false, true, false, false)
on conflict (id) do update
set relationship = excluded.relationship,
    is_primary = excluded.is_primary,
    is_emergency_contact = excluded.is_emergency_contact,
    is_authorized_pickup = excluded.is_authorized_pickup,
    can_view_profile = excluded.can_view_profile,
    can_view_billing = excluded.can_view_billing,
    can_view_photos = excluded.can_view_photos,
    can_view_reports = excluded.can_view_reports,
    can_view_messages = excluded.can_view_messages,
    can_message_staff = excluded.can_message_staff;

insert into public.classroom_staff_assignments (id, org_id, centre_id, staff_profile_id, classroom_id, is_default, starts_on)
values
  ('80000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', '40000000-0000-0000-0000-000000000001', '30000000-0000-0000-0000-000000000001', true, current_date),
  ('80000000-0000-0000-0000-000000000002', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', '40000000-0000-0000-0000-000000000002', '30000000-0000-0000-0000-000000000002', true, current_date),
  ('80000000-0000-0000-0000-000000000003', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', '40000000-0000-0000-0000-000000000003', '30000000-0000-0000-0000-000000000003', true, current_date),
  ('80000000-0000-0000-0000-000000000004', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', '40000000-0000-0000-0000-000000000004', '30000000-0000-0000-0000-000000000004', true, current_date)
on conflict (id) do update
set classroom_id = excluded.classroom_id,
    is_default = excluded.is_default,
    starts_on = excluded.starts_on;

insert into public.classroom_device_sessions (id, org_id, centre_id, classroom_id, session_label, device_name, expires_at)
values
  ('90000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', '30000000-0000-0000-0000-000000000001', 'Tiny Stars test tablet', 'Tiny Stars iPad fixture', now() + interval '8 hours')
on conflict (id) do update
set classroom_id = excluded.classroom_id,
    session_label = excluded.session_label,
    device_name = excluded.device_name,
    status = 'active',
    expires_at = excluded.expires_at;

insert into public.classroom_child_enrollments (id, org_id, centre_id, child_id, classroom_id, starts_on)
values
  ('91000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', '60000000-0000-0000-0000-000000000001', '30000000-0000-0000-0000-000000000001', current_date),
  ('91000000-0000-0000-0000-000000000002', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', '60000000-0000-0000-0000-000000000002', '30000000-0000-0000-0000-000000000002', current_date),
  ('91000000-0000-0000-0000-000000000003', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', '60000000-0000-0000-0000-000000000003', '30000000-0000-0000-0000-000000000003', current_date),
  ('91000000-0000-0000-0000-000000000004', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', '60000000-0000-0000-0000-000000000004', '30000000-0000-0000-0000-000000000004', current_date),
  ('91000000-0000-0000-0000-000000000005', '10000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000002', '60000000-0000-0000-0000-000000000005', '30000000-0000-0000-0000-000000000006', current_date)
on conflict (id) do update
set classroom_id = excluded.classroom_id,
    starts_on = excluded.starts_on,
    status = 'active';

insert into public.permission_definitions (code, domain, surface, action, description, risk_level)
values
  ('Auth.Context.Read', 'Auth', 'Shared', 'Read', 'Read current auth, organization, centre, and role context.', 'normal'),
  ('Org.Profile.Read', 'Organization', 'Shared', 'Read', 'Read assigned organization profile.', 'normal'),
  ('Centre.Profile.Read', 'Centre', 'Shared', 'Read', 'Read assigned centre profile.', 'normal'),
  ('Centre.Profile.Update', 'Centre', 'Admin', 'Update', 'Update assigned centre profile.', 'sensitive'),
  ('Centre.Members.Read', 'Centre', 'Admin', 'Read', 'Read assigned centre memberships.', 'sensitive'),
  ('Centre.Members.ManageStaff', 'Centre', 'Admin', 'Update', 'Invite and manage staff records.', 'high'),
  ('Classroom.Profile.Read', 'Classroom', 'Shared', 'Read', 'Read assigned classroom profile.', 'normal'),
  ('Classroom.Session.Use', 'Classroom', 'Staff', 'Use', 'Use a classroom device/session workflow.', 'sensitive'),
  ('Classroom.Staff.Assign', 'Classroom', 'Admin', 'Create', 'Assign staff to classrooms.', 'sensitive'),
  ('Classroom.Staff.Move', 'Classroom', 'Admin', 'Update', 'Move staff between classrooms.', 'sensitive'),
  ('Classroom.Children.Assign', 'Classroom', 'Admin', 'Create', 'Assign children to classrooms.', 'high'),
  ('Classroom.Children.Move', 'Classroom', 'Admin', 'Update', 'Move children between classrooms.', 'high'),
  ('Children.Profile.Read', 'Children', 'Shared', 'Read', 'Read permitted child profile data.', 'high'),
  ('Guardians.ChildAccess.Read', 'Guardians', 'Admin', 'Read', 'Read guardian child access permissions.', 'high'),
  ('Guardians.ChildAccess.Update', 'Guardians', 'Admin', 'Update', 'Update guardian child access permissions.', 'high'),
  ('Permissions.Read', 'Permissions', 'Admin', 'Read', 'Read permission definitions and assignments.', 'sensitive'),
  ('Permissions.Override', 'Permissions', 'Admin', 'Update', 'Create member permission overrides.', 'high'),
  ('Audit.Read', 'Audit', 'Admin', 'Read', 'Read centre audit events.', 'high')
on conflict (code) do update
set domain = excluded.domain,
    surface = excluded.surface,
    action = excluded.action,
    description = excluded.description,
    risk_level = excluded.risk_level;

insert into public.role_permissions (role, permission_definition_id, allowed)
select role_value.role, pd.id, true
from (values ('owner'::public.app_role), ('director'::public.app_role), ('admin'::public.app_role)) as role_value(role)
cross join public.permission_definitions pd
on conflict (role, permission_definition_id) do update
set allowed = excluded.allowed;

insert into public.role_permissions (role, permission_definition_id, allowed)
select 'staff'::public.app_role, pd.id, true
from public.permission_definitions pd
where pd.code in (
  'Auth.Context.Read',
  'Centre.Profile.Read',
  'Classroom.Profile.Read',
  'Classroom.Session.Use',
  'Classroom.Staff.Move',
  'Children.Profile.Read'
)
on conflict (role, permission_definition_id) do update
set allowed = excluded.allowed;

insert into public.role_permissions (role, permission_definition_id, allowed)
select 'guardian'::public.app_role, pd.id, true
from public.permission_definitions pd
where pd.code in (
  'Auth.Context.Read',
  'Centre.Profile.Read',
  'Children.Profile.Read',
  'Guardians.ChildAccess.Read'
)
on conflict (role, permission_definition_id) do update
set allowed = excluded.allowed;

insert into public.audit_events (
  id,
  org_id,
  centre_id,
  actor_type,
  action,
  resource_type,
  resource_id,
  metadata
)
values (
  '92000000-0000-0000-0000-000000000001',
  '10000000-0000-0000-0000-000000000001',
  '20000000-0000-0000-0000-000000000001',
  'system',
  'seed.kf001.created',
  'seed_fixture',
  null,
  '{"fixture":"KF-001 synthetic seed","contains_real_data":false}'::jsonb
)
on conflict (id) do update
set metadata = excluded.metadata;
