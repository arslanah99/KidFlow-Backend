# KF-001 Implementation Plan

Feature: Auth, Organization, Centre, Roles, And RLS Foundation

Status: Implemented and locally verified

Code implementation approval: Approved by user message: "commited ok run kf-001"

## Goal

Implement the first backend foundation for KidFlow using Supabase/Postgres:

- Organizations and centres.
- Auth-linked profiles.
- Owner/director/admin operational access.
- Staff records without required auth login.
- Parent/guardian records and per-child access.
- Classrooms, child classroom assignment, staff classroom assignment, and movement tracking.
- Shared classroom device sessions.
- Permission-definition foundation.
- Audit-event foundation.
- Initial RLS policies and verification.

This plan creates the foundation only. It does not build registration, billing, reports, messaging, photos, incidents, or UI.

## Supabase Access Needed

No Supabase connection is needed to review this plan.

When code implementation starts, we need:

- Local Supabase CLI available.
- One Supabase free-tier cloud sandbox project for Phase 0.
- Project URL and anon key for sandbox client testing.
- Service-role key only in backend/server env files, never in web/mobile/site.
- Database password/project ref only if linking local CLI to the cloud sandbox.

Do not paste secrets into chat or commit them. Use ignored `.env` files.

## Required Rules Before Coding

The backend `rules/` folder is the implementation source of truth for KF-001. Before implementation, re-read and follow:

- `rules/architecture.md`
- `rules/api.md`
- `rules/supabase-rls.md`
- `rules/typescript.md`
- `rules/privacy-security.md`
- `rules/testing.md`
- `rules/llm-workflow.md`

Do not use `any` for database rows, API payloads, auth/permission context, audit metadata, child/guardian/staff records, consent records, billing placeholders, or vendor payloads. If an unknown external payload appears later, validate it first and narrow the type after validation.

Push back before coding if the implementation would weaken RLS, leak service-role access, duplicate ownership into web/mobile/site, skip auditability, or make child-data access unclear.

## Dummy Frontend Status

Dummy frontend is not applicable for KF-001 because this is backend foundation work: schema, auth relationships, role/permission modeling, RLS helpers, seed fixtures, and verification cases.

The backend substitute for dummy UI is:

- explicit table/relationship contracts
- synthetic seed fixtures
- expected role-context examples
- RLS verification matrix
- generated database types

Frontend dummy work can start after this foundation exists and the later web/mobile/site feature specs define their screens.

## Files To Create Or Update

Expected implementation files:

```text
supabase/config.toml
supabase/migrations/000001_kf001_foundation.sql
supabase/seed.sql
supabase/tests/kf001_rls.sql
src/types/database.types.ts
.env.example
.gitignore
README.md
```

If this repo is not yet scaffolded as a Supabase project, implementation begins with `supabase init`.

## Phase 0 Environment

Use:

```text
local Supabase      # local development and migration checks
cloud sandbox       # one free-tier Supabase project, synthetic data only
```

Do not create paid staging/production yet. Do not enter real Sunridge child, parent, staff, billing, medical, incident, photo, or message data.

## Schema Conventions

- Primary keys: `uuid default gen_random_uuid()`.
- Timestamps: `created_at`, `updated_at`.
- Soft lifecycle columns where needed: `status`, `deactivated_at`, `deleted_at`.
- Tenant scope: operational tables include `org_id` and usually `centre_id`.
- All personal-data tables have RLS enabled.
- Auth users are `auth.users`.
- `profiles.id` equals `auth.users.id`.
- Staff records can exist without `auth.users`.
- Guardian records can exist before auth account creation.

## Extensions And Helper Triggers

Migration should enable:

```sql
create extension if not exists pgcrypto;
create extension if not exists citext;
```

Create an `updated_at` trigger helper:

```text
set_updated_at()
```

Use it on mutable tables.

## Enums

Create enums:

```text
app_role
- owner
- director
- admin
- staff
- guardian
- support

record_status
- active
- inactive
- archived
- deleted

membership_status
- invited
- active
- suspended
- removed

centre_status
- active
- inactive
- archived

staff_status
- active
- inactive
- terminated
- archived

child_status
- active
- graduated
- deactivated
- deleted

classroom_status
- active
- inactive
- archived

classroom_session_status
- active
- closed
- expired

guardian_relationship
- mother
- father
- parent
- guardian
- foster_parent
- grandparent
- relative
- other

audit_actor_type
- auth_user
- staff_profile
- classroom_device_session
- system
```

## Tables

### `organizations`

Company/operator level.

Example: `The Kids Planet`.

Columns:

```text
id uuid pk
name text not null
legal_name text null
slug text not null unique
status record_status not null default active
default_country text not null default 'CA'
default_timezone text not null default 'America/Edmonton'
created_at timestamptz not null
updated_at timestamptz not null
```

### `centres`

Physical daycare location.

Examples: `Sunridge`, `Edmonton Trail`, `Centre Street`.

Columns:

```text
id uuid pk
org_id uuid not null references organizations(id)
name text not null
slug text not null
status centre_status not null default active
address_line1 text null
address_line2 text null
city text null
province text null
postal_code text null
country text not null default 'CA'
phone text null
email citext null
timezone text not null default 'America/Edmonton'
capacity integer null
license_number text null
created_at timestamptz not null
updated_at timestamptz not null
unique(org_id, slug)
```

### `profiles`

Auth-linked people. Required for owner/director/admin/support and parent app access. Not required for staff records.

Columns:

```text
id uuid pk references auth.users(id)
email citext not null
first_name text null
last_name text null
display_name text null
phone text null
avatar_path text null
status record_status not null default active
created_at timestamptz not null
updated_at timestamptz not null
```

### `organization_memberships`

Org-level access. Used mainly for owner/support/future cross-centre overview.

Columns:

```text
id uuid pk
org_id uuid not null references organizations(id)
user_id uuid not null references profiles(id)
role app_role not null
status membership_status not null default active
created_by uuid null references profiles(id)
created_at timestamptz not null
updated_at timestamptz not null
unique(org_id, user_id, role)
```

Rules:

- `owner` can be org-level.
- `support` exists but has no default production access policy.

### `centre_memberships`

Centre-level operational auth access.

Columns:

```text
id uuid pk
org_id uuid not null references organizations(id)
centre_id uuid not null references centres(id)
user_id uuid not null references profiles(id)
role app_role not null
status membership_status not null default active
created_by uuid null references profiles(id)
created_at timestamptz not null
updated_at timestamptz not null
unique(centre_id, user_id, role)
```

Rules:

- `owner`, `director`, and `admin` have full centre access for MVP.
- `guardian` app access should primarily come through `child_guardians`, not just centre membership.
- `staff` auth-linked membership is allowed later but not required for MVP.

### `classrooms`

Rooms inside a centre.

Columns:

```text
id uuid pk
org_id uuid not null references organizations(id)
centre_id uuid not null references centres(id)
name text not null
slug text not null
age_group text null
capacity integer null
ratio_label text null
status classroom_status not null default active
created_at timestamptz not null
updated_at timestamptz not null
unique(centre_id, slug)
```

### `staff_profiles`

Daycare staff records. Auth user is optional.

Columns:

```text
id uuid pk
org_id uuid not null references organizations(id)
centre_id uuid not null references centres(id)
auth_user_id uuid null references profiles(id)
first_name text not null
last_name text not null
preferred_name text null
email citext null
phone text null
title text null
status staff_status not null default active
default_classroom_id uuid null references classrooms(id)
created_at timestamptz not null
updated_at timestamptz not null
```

Rules:

- Staff do not need individual app login for MVP.
- Staff who are also parents get parent access through guardian profile, not through staff profile automatically.

### `guardian_profiles`

Parent/guardian person record. Auth user is optional until app account is created after enrollment/approval.

Columns:

```text
id uuid pk
org_id uuid not null references organizations(id)
centre_id uuid not null references centres(id)
auth_user_id uuid null references profiles(id)
first_name text not null
last_name text not null
email citext null
phone text null
status record_status not null default active
created_at timestamptz not null
updated_at timestamptz not null
```

### `children`

Child profile foundation.

Columns:

```text
id uuid pk
org_id uuid not null references organizations(id)
centre_id uuid not null references centres(id)
current_classroom_id uuid null references classrooms(id)
first_name text not null
last_name text not null
preferred_name text null
date_of_birth date null
status child_status not null default active
graduated_at timestamptz null
deactivated_at timestamptz null
deleted_at timestamptz null
created_at timestamptz not null
updated_at timestamptz not null
```

Rules:

- Use `graduated` or `deactivated` before deletion.
- Hard deletion is blocked later if dependent records exist.
- KF-001 should not store medical/allergy/custody details yet.

### `child_guardians`

Per-child guardian relationship and permissions.

Columns:

```text
id uuid pk
org_id uuid not null references organizations(id)
centre_id uuid not null references centres(id)
child_id uuid not null references children(id)
guardian_profile_id uuid not null references guardian_profiles(id)
relationship guardian_relationship not null default guardian
is_primary boolean not null default false
is_emergency_contact boolean not null default false
is_authorized_pickup boolean not null default false
can_view_profile boolean not null default true
can_view_billing boolean not null default true
can_view_photos boolean not null default true
can_view_reports boolean not null default true
can_view_messages boolean not null default true
can_message_staff boolean not null default true
status record_status not null default active
created_at timestamptz not null
updated_at timestamptz not null
unique(child_id, guardian_profile_id)
```

Rules:

- Access is per child.
- Restricted guardian is represented by permission booleans on this relationship.
- Future feature specs can add more granular permissions.

### `classroom_staff_assignments`

Regular staff-to-classroom assignments.

Columns:

```text
id uuid pk
org_id uuid not null
centre_id uuid not null
staff_profile_id uuid not null references staff_profiles(id)
classroom_id uuid not null references classrooms(id)
is_default boolean not null default false
starts_on date null
ends_on date null
status record_status not null default active
created_at timestamptz not null
updated_at timestamptz not null
```

### `classroom_staff_movements`

Movement log when staff switch rooms.

Columns:

```text
id uuid pk
org_id uuid not null
centre_id uuid not null
staff_profile_id uuid not null references staff_profiles(id)
from_classroom_id uuid null references classrooms(id)
to_classroom_id uuid not null references classrooms(id)
moved_at timestamptz not null
moved_by_user_id uuid null references profiles(id)
moved_by_staff_profile_id uuid null references staff_profiles(id)
moved_by_session_id uuid null
reason text null
created_at timestamptz not null
```

### `classroom_device_sessions`

Shared tablet/classroom session.

Columns:

```text
id uuid pk
org_id uuid not null references organizations(id)
centre_id uuid not null references centres(id)
classroom_id uuid not null references classrooms(id)
session_label text null
device_name text null
status classroom_session_status not null default active
opened_at timestamptz not null
closed_at timestamptz null
expires_at timestamptz null
opened_by_user_id uuid null references profiles(id)
created_at timestamptz not null
updated_at timestamptz not null
```

Rules:

- No staff PIN in MVP.
- UI asks staff to select their name for attribution where useful.
- If no staff actor is selected, actions are attributed to the classroom session.
- Classroom tablet personal-data access should go through backend functions, not direct anonymous Supabase reads.

### `classroom_child_enrollments`

Current and historical child classroom assignment.

Columns:

```text
id uuid pk
org_id uuid not null
centre_id uuid not null
child_id uuid not null references children(id)
classroom_id uuid not null references classrooms(id)
starts_on date not null
ends_on date null
status record_status not null default active
created_at timestamptz not null
updated_at timestamptz not null
```

### `classroom_child_movements`

Temporary or permanent child movement log.

Columns:

```text
id uuid pk
org_id uuid not null
centre_id uuid not null
child_id uuid not null references children(id)
from_classroom_id uuid null references classrooms(id)
to_classroom_id uuid not null references classrooms(id)
moved_at timestamptz not null
moved_by_user_id uuid null references profiles(id)
moved_by_staff_profile_id uuid null references staff_profiles(id)
moved_by_session_id uuid null references classroom_device_sessions(id)
reason text null
created_at timestamptz not null
```

### `permission_definitions`

Feature/action permission catalog.

Columns:

```text
id uuid pk
code text not null unique
domain text not null
surface text not null
action text not null
description text null
risk_level text not null default 'normal'
created_at timestamptz not null
```

Seed only foundation permissions in KF-001.

Initial permission codes:

```text
Auth.Context.Read
Org.Profile.Read
Centre.Profile.Read
Centre.Profile.Update
Centre.Members.Read
Centre.Members.ManageStaff
Classroom.Profile.Read
Classroom.Session.Use
Classroom.Staff.Assign
Classroom.Staff.Move
Classroom.Children.Assign
Classroom.Children.Move
Children.Profile.Read
Guardians.ChildAccess.Read
Guardians.ChildAccess.Update
Permissions.Read
Permissions.Override
Audit.Read
```

### `role_permissions`

Default permissions by role.

Columns:

```text
id uuid pk
role app_role not null
permission_definition_id uuid not null references permission_definitions(id)
allowed boolean not null default true
created_at timestamptz not null
unique(role, permission_definition_id)
```

KF-001 defaults:

- `owner`, `director`, `admin`: all initial foundation permissions.
- `staff`: classroom/session and child read/move permissions as needed for classroom operations.
- `guardian`: auth context and own child access permissions only.
- `support`: no permissions by default.

### `member_permission_overrides`

Per-user override table.

Columns:

```text
id uuid pk
org_id uuid not null references organizations(id)
centre_id uuid null references centres(id)
user_id uuid not null references profiles(id)
permission_definition_id uuid not null references permission_definitions(id)
allowed boolean not null
reason text null
created_by uuid null references profiles(id)
expires_at timestamptz null
created_at timestamptz not null
updated_at timestamptz not null
unique(org_id, centre_id, user_id, permission_definition_id)
```

Rules:

- Do not use for staff without auth accounts.
- Changes create audit events.

### `audit_events`

Generic audit log foundation.

Columns:

```text
id uuid pk
org_id uuid null references organizations(id)
centre_id uuid null references centres(id)
actor_type audit_actor_type not null
actor_user_id uuid null references profiles(id)
actor_staff_profile_id uuid null references staff_profiles(id)
actor_classroom_device_session_id uuid null references classroom_device_sessions(id)
action text not null
resource_type text not null
resource_id uuid null
metadata jsonb not null default '{}'
created_at timestamptz not null
```

Rules:

- Use typed actor/action/resource columns for searching.
- Keep `metadata` limited and redacted.
- No raw child medical/custody/incident content in metadata.

## RLS Helper Functions

Create SQL helper functions:

```text
current_user_id() -> uuid
is_org_member(org_id, roles app_role[] default null) -> boolean
is_centre_member(centre_id, roles app_role[] default null) -> boolean
is_owner_director_admin(centre_id) -> boolean
can_read_child(child_id) -> boolean
can_read_child_billing(child_id) -> boolean
can_read_child_photos(child_id) -> boolean
can_read_child_reports(child_id) -> boolean
can_message_for_child(child_id) -> boolean
has_permission(permission_code, org_id, centre_id default null) -> boolean
```

Notes:

- Functions must be stable and safe for RLS.
- Avoid leaking whether inaccessible rows exist.
- Helper functions must filter by active memberships/status.

## RLS Policy Plan

Enable RLS on all tables above.

### Owner/Director/Admin

For centre-scoped tables:

- `select`: allowed if active centre membership role in `owner`, `director`, `admin`.
- `insert/update`: allowed for admin tables if active centre membership role in `owner`, `director`, `admin`.
- `delete`: generally not allowed directly; use soft delete or backend functions.

### Organization Overview

For `organizations`:

- active org members can read their organizations.
- no public read.

For `centres`:

- active org members can read centres in their org.
- active centre members can read their centre.
- guardians can read basic centre info for their linked child.

### Staff Records

For `staff_profiles`:

- owner/director/admin can manage staff in their centre.
- staff auth access is future optional.
- guardians do not read staff profile table directly unless future feature creates a safe staff-display view.

### Guardian/Child

For `children`:

- owner/director/admin can read/write centre children.
- guardian can read linked child only when `child_guardians.status = active` and `can_view_profile = true`.
- no public access.

For `guardian_profiles` and `child_guardians`:

- owner/director/admin can manage in centre.
- guardian can read their own guardian profile and their own child relationships.
- restricted guardian booleans control dependent feature reads.

### Classroom Sessions

Classroom device sessions are not normal auth users.

MVP classroom tablet data access should use backend functions that:

1. Validate the classroom session token.
2. Verify the session is active, not expired, and scoped to one centre/classroom.
3. Use service-role server-side queries filtered by `org_id`, `centre_id`, and `classroom_id`.
4. Create audit events with `actor_type = classroom_device_session` and optional selected `staff_profile`.

Do not let anonymous classroom tablets directly query child tables through Supabase client keys.

### Permissions

For permission tables:

- owner/director/admin can read permissions for their centre/org.
- support has no default read.
- only owner/director/admin can manage overrides, and every change creates audit event.

### Audit Events

For `audit_events`:

- owner/director/admin can read centre audit events.
- support disabled by default.
- inserts happen through backend functions/triggers.
- no updates/deletes from clients.

## Hard Delete Rules

KF-001 does not need to implement every deletion function, but schema and constraints must support this rule:

Hard delete is blocked when dependent records exist, including:

- guardian links
- classroom enrollments
- classroom movement logs
- future attendance
- future billing
- future reports
- future incidents
- audit events

Use status transitions first:

```text
active -> graduated -> deactivated -> deleted
```

Physical deletion requires a future explicit backend function and audit event.

## Seed Data

Use obviously synthetic data:

Organization:

```text
The Kids Planet
```

Centre:

```text
The Kids Planet Sunridge
```

Classrooms:

```text
Tiny Stars
Galaxy Gang
Milky Way Minis
Jupiter
Apollo
```

Auth-linked users:

```text
owner@test.kidflow.local
director@test.kidflow.local
admin@test.kidflow.local
parent@test.kidflow.local
restricted-parent@test.kidflow.local
```

Staff records without auth:

```text
Diana Park
Marcus Lee
Priya Singh
Naomi Reyes
```

Synthetic children:

```text
Mia Testchild
Aiden Testchild
Zoe Testchild
Theo Testchild
```

Use fake emails, fake phone numbers, and no real child photos or medical/custody details.

## Testing Plan

### Migration Tests

- `supabase db reset` applies migrations and seed successfully.
- Re-running seed is either idempotent or reset-only.
- Generated types can be produced.

### RLS Tests

Owner/director/admin:

- can read assigned org/centre
- can read children/classrooms/staff in assigned centre
- cannot read another org/centre

Parent/guardian:

- can read own linked child
- cannot read unrelated child
- restricted guardian cannot read blocked areas once dependent feature policies exist

Staff:

- staff records do not require auth user
- auth-linked staff direct RLS is not required for MVP
- classroom device session access is only through backend function plan

Public/anonymous:

- cannot read operational tables
- cannot enumerate children/guardians/staff

Support:

- no default production access

Permissions:

- owner/director/admin have foundation permissions
- guardian has only own-context permissions
- support has no default permissions

Audit:

- role/permission/guardian/classroom changes can create audit event entries
- audit metadata is limited/redacted

### Codex In-App Browser QA

Final verification must include Codex in-app browser QA before this feature can be marked complete.

For KF-001, if no browser-visible backend endpoint or UI exists after implementation, record browser QA as not applicable and explain why. If implementation creates any local health endpoint, docs page, Supabase function endpoint, or downstream web/mobile flow, open it in the Codex in-app browser and verify:

- expected status/page renders
- no secrets or raw child data appear
- unauthenticated browser access does not expose operational data
- any auth callback/role-context browser flow behaves as expected

## Manual Verification Matrix

Create a verification checklist during implementation:

```text
Role/session                     Expected
owner@test...                    Reads centre data
director@test...                 Reads centre data
admin@test...                    Reads centre data
parent@test...                   Reads own child only
restricted-parent@test...        Reads only allowed child sections
anonymous                        Reads nothing operational
classroom session Tiny Stars     Backend function returns Tiny Stars roster only
support@test...                  No default access
```

## Implementation Order

If any step becomes too large, split it into smaller substeps such as `5A`, `5B`, and `5C` before implementation.

1. Scaffold Supabase project files if missing.
2. Re-read and apply the backend rules listed above.
3. Confirm dummy frontend is not applicable and use backend contracts/fixtures/RLS matrix instead.
4. Add `.gitignore` and `.env.example`.
5. Add foundation migration with extensions, enums, tables, indexes, triggers.
6. Add RLS helper functions.
7. Enable RLS and add initial policies.
8. Add synthetic seed data.
9. Add SQL RLS tests/manual verification scripts.
10. Run local migration reset.
11. Generate DB types.
12. Run manual verification, provide results, and repeat feedback/test loop until accepted.
13. Run Codex in-app browser QA for any browser-visible endpoint/page/flow, or document why not applicable.
14. Document verification results in this feature or a short verification note.

## Commands To Use During Implementation

Expected commands:

```bash
supabase init
supabase start
supabase db reset
supabase gen types typescript --local > src/types/database.types.ts
```

Cloud sandbox linking/deploy is later:

```bash
supabase login
supabase link --project-ref <sandbox-project-ref>
supabase db push
```

Only run cloud commands after sandbox project exists and secrets are in local ignored env/config.

## Done Criteria

- Supabase project scaffold exists.
- Foundation migration exists and applies locally.
- RLS is enabled on personal-data tables.
- RLS helper functions exist.
- Synthetic seed data exists.
- Permission foundation tables exist.
- Audit event table exists.
- Staff records do not require auth user IDs.
- Guardian access is per child.
- Owner/director/admin full centre access is represented.
- Support has no default access.
- Classroom device session model exists.
- Generated database types exist.
- Backend repo rules were re-read, followed, and any exception is documented.
- Dummy frontend is documented as not applicable for this backend foundation.
- Verification checklist passes locally.
- Codex in-app browser QA is complete or explicitly marked not applicable with reason.
- No real data or secrets are committed.

## Approval Gate

Implementation should not start until this plan is reviewed and approved.
