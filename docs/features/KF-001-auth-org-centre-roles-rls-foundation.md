# KF-001 Auth, Organization, Centre, Roles, And RLS Foundation

Status: Draft

Approval status: Not approved for implementation.

## Goal

Create the backend foundation that every KidFlow feature depends on: Supabase Auth, organizations, centres, users/profiles, memberships, roles, basic staff/guardian/child relationships, classroom scoping, and first-pass RLS.

This feature should prove that KidFlow can safely separate director/admin, staff/classroom, parent/guardian, restricted guardian, and public/applicant access before building registration, billing, attendance, photos, reports, or messaging.

## Decisions Captured

- Supabase Auth is the MVP auth provider.
- Phase 0 uses one local/dev database plus one Supabase free-tier cloud sandbox with synthetic data only.
- Production will later use paid Supabase in Canada Central before real Sunridge data or live payments.
- One user account can belong to multiple organizations/centres and can have different roles per context.
- Same person may eventually be both staff and parent/guardian, so permissions must be contextual, not hardcoded by email.
- `organization` means the daycare company/operator.
- `centre` means a physical daycare location.
- Example: `The Kids Planet` is the organization; `Sunridge`, `Edmonton Trail`, and `Centre Street` are centres.
- The first synthetic centre name is `The Kids Planet Sunridge`.
- `owner`, `director`, and `admin` have full centre access for MVP.
- `owner`, `director`, and `admin` are separate role values, but can behave the same operationally in MVP.
- Director and admin use the same product view and can do the same operational job in MVP.
- Owners can have a higher-level overview across multiple centres and, later, multiple organizations if assigned that way.
- Multiple owners and multiple directors are allowed.
- Admins do not invite other admins in MVP.
- Directors/admins can invite staff.
- Parents/guardians are not manually invited before a child exists in registration/enrollment, because a child may have unusual guardian/foster/no-parent situations.
- Parent/guardian app access starts after enrollment/approval.
- Staff are daycare staff records first and do not require individual app logins for MVP classroom operations.
- Staff may have no auth user account unless they are also a parent/guardian, director/admin, or a future staff self-service user.
- Staff who are also parents use their parent/guardian login for parent access; that does not automatically grant staff/admin app access.
- Keep separate role values: `owner`, `director`, `admin`, `staff`, `guardian`, `support`.
- User type is contextual. The same auth user can be staff, parent/guardian, admin, or another role depending on organization/centre/child relationships.
- Staff are assigned to existing classrooms by director/admin, can have a default classroom, and can move/switch classrooms during the day.
- Staff and child classroom movement must be tracked.
- Shared classroom tablet access does not require staff PIN entry for MVP.
- Shared classroom tablet actions may be attributed to the classroom/device session unless an individual staff actor is selected by the workflow.
- Shared classroom tablet UI should ask staff to select their name for action attribution, but no PIN is required in MVP.
- Parent/guardian access is per child, not only per family.
- Operational tables should include both `org_id` and `centre_id` where practical.
- Children should support graduation/deactivation/soft deletion before hard deletion.
- Full deletion must require explicit confirmation and relationship cleanup rules.
- Hard deletion is blocked while guardian links, billing, attendance, reports, incidents, audit events, or other dependent records exist.
- Support/founder access is disabled by default until an audited support workflow exists.
- `audit_events` belongs in KF-001.

## Non-Goals

- No production Sunridge data.
- No real child, parent, staff, billing, medical, incident, message, or photo data.
- No live Stripe payments.
- No full registration form builder.
- No full application-wide CRUD permission matrix yet.
- No billing/invoice tables beyond placeholders needed for future references.
- No daily reports/photos/messages/incidents implementation.
- No mobile or web UI implementation except auth callback assumptions if needed later.
- No legal consent copy.
- No production launch.

## Users

- Owner: can access assigned organization/centre operational data and billing/admin settings once those features exist.
- Director/admin: can access assigned organization/centre operational data.
- Staff: can access assigned/current classroom data only.
- Parent/guardian: can access linked child/family data only.
- Restricted guardian: can be limited from areas such as billing, photos, messages, or reports.
- Public applicant: can later create registration/tour records without seeing existing records.
- Support/founder: no default broad access; any future support access must be explicit and audited.

## Affected Surfaces/Repos

- `kidflow-backend`: owns all schema, migrations, RLS, seed data, generated types, and auth/role helper functions.
- `kidflow-web`: later consumes auth/session/role context for director/admin/staff/parent web surfaces.
- `kidflow-mobile`: later consumes auth/session/role context for parent/staff/director mobile surfaces.
- `kidflow-site`: no direct dependency except future safe public links into registration/tour flows.

## Product Requirements Read

- `kidflow-backend/docs/PRODUCT_REQUIREMENTS.md`: backend authority, Supabase-first, RLS, roles, centres, child data, multi-centre readiness.
- `kidflow-backend/docs/architecture/ADR-001-backend-platform-and-database.md`: Supabase Cloud Postgres MVP decision, free-tier Phase 0 sandbox, portability rules.
- `kidflow-backend/docs/DEVELOPMENT_WORKFLOW.md`: Phase 0 local/cloud sandbox flow, no real data, feature planning levels.
- `kidflow-backend/docs/privacy/CHILD_DATA_PROTECTION_STANDARD.md`: default deny, tenant isolation, parent/staff/director scoping.
- `kidflow-backend/docs/security/SECURITY_BASELINE.md`: RLS, server-side validation, no service-role keys in clients.
- `kidflow-backend/rules/supabase-rls.md`: RLS requirements.

## Design References

- `docs/design/artifacts/kidflow-director-web-print.pdf`: director/admin and centre/classroom concepts.
- `docs/design/artifacts/kidflow-staff-tablet-print.pdf`: shared classroom/staff tablet and classroom scoping concepts.
- `docs/design/artifacts/kidflow-parent-mobile-print.pdf`: parent/guardian access concepts.
- `docs/design/artifacts/kidflow-enrollment-system-print.pdf`: public applicant and parent onboarding concepts.

## Data Touched

- Child data: synthetic child rows only for RLS proof.
- Parent/guardian data: synthetic guardian/profile rows only.
- Staff data: synthetic staff/profile rows only.
- Billing/payment data: none in this slice.
- Consent/legal records: none in this slice.
- Photos/media: none in this slice.
- Messages/notifications: none in this slice.

## Child-Data Impact

This feature creates the first data model and access rules that will later protect child records. It may create synthetic child rows for local/dev RLS testing.

No real child data may be entered. If testing needs realistic names/photos/medical notes, use synthetic fixtures only.

## Consent And Legal Impact

- Consent required: not for synthetic dev data.
- Consent copy/version needed: no.
- Withdrawal/deletion impact: not implemented in this slice, but tables must not block future deletion/deactivation/anonymization workflows.
- Legal/privacy review needed: before production launch, not before Phase 0 development.

## Privacy And Security Risk

- Permissions/RLS: highest risk area in this feature. RLS must be designed and tested before dependent features.
- Feature/action permissions: KidFlow needs a permission model similar in spirit to a CRUD capability matrix, but the first slice should not attempt to define every future feature permission.
- Logging/redaction: migrations/tests must not log raw personal payloads; synthetic seed data only.
- Audit trail: create an `audit_events` foundation or explicitly defer with a clear follow-up.
- External vendors: Supabase only in this slice.
- Abuse/misuse cases:
  - parent sees another family's child
  - staff sees children outside current classroom
  - director sees another centre/org
  - restricted guardian sees billing/photos/messages when blocked
  - public applicant can enumerate existing children/families
- Failure impact: broken RLS can expose child/family/staff data across families, classrooms, centres, or organizations.

## API And Backend Impact

- API routes/functions:
  - optional auth/session role-context endpoint if needed for clients
  - no large feature APIs yet
- Supabase direct access:
  - allowed for RLS verification and later simple safe reads
  - every direct access pattern must remain safe under RLS
- Stripe/Resend/Twilio/Expo/Sentry:
  - none in this slice
- Secrets:
  - local/dev Supabase anon key only for clients
  - service-role key only in backend/local server context if needed
- Scheduled/background jobs:
  - none in this slice

## Database And RLS Impact

Initial tables/enums to evaluate in implementation plan:

- `organizations`
- `centres`
- `profiles`
- `organization_memberships`
- `centre_memberships`
- `role` enum or lookup
- `classrooms`
- `staff_profiles`
- `guardian_profiles`
- `children`
- `child_guardians`
- `classroom_staff_assignments`
- `classroom_staff_movements`
- `classroom_device_sessions`
- `classroom_child_enrollments`
- `classroom_child_movements`
- `guardian_access_overrides` or permission fields on `child_guardians`
- `permission_definitions`
- `role_permissions`
- `member_permission_overrides`
- `audit_events`

Migration requirements:

- All personal-data tables must have RLS enabled.
- All operational rows must have `org_id` or a documented path to tenant scope.
- Centre-scoped rows must include `centre_id` where practical.
- Staff records must not require an auth user ID.
- Auth-linked profile records must be optional for staff and required for director/admin/owner/support/parent app access.
- RLS helper functions must be stable, readable, and tested.
- Constraints must prevent orphaned child/guardian/classroom relationships.
- Seed data must be synthetic and safe to reset.

Generated types:

- Generate database types after migrations exist.
- Treat generated types in `kidflow-backend` as canonical.

Backfill/seed data:

- Seed one synthetic organization.
- Seed `The Kids Planet Sunridge` as the synthetic centre.
- Seed owner, director, and admin user/profile records.
- Seed staff records without requiring auth user accounts.
- Seed parent/guardian user/profile.
- Seed restricted guardian user/profile.
- Seed synthetic child/classroom links.

## Permission Model Direction

KidFlow needs two permission layers:

1. Data-boundary permissions:
   - Enforced primarily by Postgres RLS.
   - Answers: "Which organization, centre, classroom, child, family, invoice, photo, or message can this user access?"
   - Examples: parent cannot see another parent's child; staff cannot see another classroom; director cannot see another organization.

2. Feature/action permissions:
   - Enforced by backend APIs and UI using a capability matrix.
   - Answers: "Can this role see this screen/button/action, and can they create/read/update/delete this object?"
   - Examples: `Billing.Web.Invoices`, `Children.Web.Profile`, `Messaging.Mobile.Thread`, `Reports.Mobile.SendReport`.

The company permission matrix example is a good pattern for feature/action permissions, but KidFlow should not store every future permission in KF-001. KF-001 should create the foundation that can support it:

- role values
- membership context
- permission definition table
- role-permission table
- per-member override table
- audit events for role/permission changes

Future feature specs should add their own permission codes and CRUD/action rules through migrations or seed scripts owned by that feature. Do not create one giant speculative matrix before features exist.

Recommended permission code shape:

```text
Domain.Surface.Area.Action
```

Examples:

```text
Children.Web.Profile.Read
Children.Web.Profile.Update
Billing.Web.Invoices.Read
Billing.Web.Invoices.MarkPaid
Reports.Mobile.Send
Photos.Mobile.TagChild
Incidents.Web.Approve
Registration.Web.Submissions.Approve
```

CRUD letters are useful shorthand in planning docs, but backend code should use explicit action names for sensitive operations.

## Initial RLS Matrix

Director/admin:

- Can read/write data for assigned organization/centre according to role.
- Cannot access another organization/centre.

Staff:

- Can read assigned/current classroom children.
- Can be assigned to one or more existing classrooms.
- Has a default classroom where they start their day.
- Can move/switch classrooms during the day.
- Classroom movement is tracked.
- Can read operational child profile details needed for care.
- Cannot read unrelated classroom children.
- Cannot read sensitive custody notes by default.
- Cannot manage billing.
- Shared classroom tablet actions can be scoped to the active classroom session without staff PIN verification in MVP.
- Shared classroom tablet actions should store selected staff actor when the UI collects one; otherwise they fall back to the classroom/device session actor.
- Staff operational access in MVP comes from classroom/device session context, not from individual staff app login.

Parent/guardian:

- Can read linked child records based on guardian permissions.
- Access is per child, not merely per family.
- Cannot read another family's child.
- Cannot read staff/private operational notes unless explicitly parent-visible.

Restricted guardian:

- Can be denied billing, photos, messages, reports, or other areas per child/guardian relationship.
- Cannot infer hidden data exists through counts/errors.

Public applicant:

- No authenticated read access to children/families.
- Future public insert paths must avoid enumeration.

Support/founder:

- No default broad access in normal app role policies.
- Future support access requires explicit process and audit.

## Implementation Steps

1. Planning and questions:
   - Confirm classroom shared-device session approach.
   - Confirm exact delete/graduation rules for children and guardians.
2. Data/contracts:
   - Draft ERD for foundation tables.
   - Define role enum/lookup and permission fields.
3. API/functions:
   - Define auth/session role-context needs for web/mobile.
   - Define RLS helper SQL functions.
4. Database/RLS:
   - Create initial migrations.
   - Enable RLS.
   - Add tenant/role/guardian/classroom policies.
   - Add synthetic seed data.
5. Privacy/security:
   - Verify no real data in seeds.
   - Verify service-role usage is backend-only.
   - Verify public/no-auth behavior.
6. Tests:
   - RLS tests for director/admin, staff, parent, restricted guardian, public/no-auth.
   - Migration apply/reset checks.
7. Verification:
   - Document manual verification matrix.
   - Generate types.
   - Confirm future feature specs can depend on this foundation.

## Open Questions

- Blocking:
  - None at feature-overview level.
- Recommended:
  - Should permission definitions be seeded in KF-001 only for foundation areas, then expanded per feature? Recommended: yes.
  - Should `audit_events` use a generic JSON payload plus typed columns for actor/action/resource, or separate tables per domain? Recommended: generic table with typed columns and limited JSON metadata.
- Optional:
  - Should CRUD-style permission matrix docs live in backend only, or should each repo maintain a surface-specific permission matrix?

## Concerns And Recommendations

- Critical concern: do not build dashboard, registration, billing, photos, or messaging before RLS boundaries are proven.
- Critical concern: do not use real Sunridge records in the free-tier cloud sandbox.
- Critical concern: do not let web/mobile read/write sensitive data by bypassing backend APIs unless RLS is explicitly tested.
- Strong recommendation: include `audit_events` foundation now because sensitive role/guardian/classroom changes need traceability.
- Strong recommendation: model multi-centre from the start even while testing one centre.
- Strong recommendation: keep restricted guardian access in the foundation, even if UI controls come later, because custody/safety risk is high.
- Strong recommendation: use explicit capability names for backend enforcement rather than relying only on broad roles.
- Nice-to-have: add an ERD diagram after the implementation plan is approved.

## Testing Plan

- Unit:
  - SQL helper functions for role/centre/guardian access.
  - Permission helper behavior if implemented in TypeScript.
- Integration:
  - Migration apply/reset.
  - Seed data creation.
  - Role-context endpoint if implemented.
- RLS/security:
  - Director/admin cannot cross org/centre boundary.
  - Staff cannot see unrelated classroom child.
  - Parent cannot see unrelated child.
  - Restricted guardian cannot access blocked areas.
  - Anonymous/public cannot read operational records.
  - Service-role path is not exposed to client code.
- Webhook/job:
  - none.
- E2E/manual:
  - Use Supabase dashboard/SQL tests or local scripts to verify each role.

## Acceptance Criteria

- [ ] Foundation ERD is approved.
- [ ] Supabase Auth approach is documented.
- [ ] Multi-organization and multi-centre table structure is documented.
- [ ] Initial role/membership model is documented.
- [ ] Permission matrix foundation is documented.
- [ ] Staff classroom scoping model is documented.
- [ ] Staff/child classroom movement tracking is documented.
- [ ] Parent/guardian and restricted guardian model is documented.
- [ ] Child graduation/deactivation/deletion model is documented.
- [ ] Audit event foundation is documented.
- [ ] Public/no-auth boundary is documented.
- [ ] Child-data impact is documented.
- [ ] Permissions/RLS verification plan is documented.
- [ ] Consent/legal needs are handled or marked launch-blocking.
- [ ] API/data contracts are documented.
- [ ] Tests/verification are complete or planned for implementation.
- [ ] No implementation proceeds before implementation plan approval.
