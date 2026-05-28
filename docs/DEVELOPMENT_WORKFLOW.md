# KidFlow Development Workflow

Status: mandatory workflow before development

Date: 2026-05-28

## Principle

Branches are not environments.

KidFlow should use protected branches, pull requests, separate runtime environments, and explicit promotion. This avoids four repos drifting across separate `dev`, `qa`, and `prod` branches.

## Repos

KidFlow has four repos:

- `kidflow-backend`
- `kidflow-web`
- `kidflow-mobile`
- `kidflow-site`

Each repo keeps its own `docs/PRODUCT_REQUIREMENTS.md`, rules, feature specs, and implementation code.

`kidflow-backend` owns database, RLS, APIs, Stripe, auth, jobs, secrets, generated types, and canonical backend decisions.

## Branching Model

Use trunk-based development with protected `main`.

Branches:

- `main`: always deployable, protected, no direct commits once code starts.
- `codex/kf-###-short-name`: feature branches used by Codex.
- `feature/kf-###-short-name`: feature branches used manually by the developer.
- `hotfix/kf-###-short-name`: urgent fix branches from `main`.

Do not create long-lived `dev`, `qa`, or `prod` branches by default.

Why:

- Long-lived branches drift.
- Four repos make branch synchronization painful.
- Environment promotion should be controlled by deployment config and release tags, not by permanently divergent branches.

If a future team needs release trains, add `release/YYYY-MM-DD` branches later.

## Environments

### Local

Purpose: solo development.

Rules:

- Local Supabase stack where practical.
- Stripe test mode only.
- Synthetic seed data only.
- No real child, parent, staff, medical, billing, incident, message, or photo data.

### Dev

Purpose: shared sandbox if needed.

Rules:

- May use Supabase free tier.
- Test Stripe only.
- Synthetic data only.
- Can be reset.
- No real Sunridge data.

### Staging / QA

Purpose: production-like testing before release.

Rules:

- Separate Supabase project.
- Prefer Canada Central.
- Test Stripe only unless a controlled live-payment test is explicitly approved.
- Same migrations as production.
- Same RLS model as production.
- Synthetic or anonymized data only.
- Used for QA, browser/mobile checks, and smoke tests.

### Production

Purpose: real customer data.

Rules:

- Paid Supabase project in Canada Central.
- Backups/PITR enabled before real data.
- Live Stripe and Stripe Connect only here.
- Real secrets only here.
- Legal/vendor/privacy review before launch.
- Backup restore process tested before launch.
- No direct database changes outside migrations unless an emergency runbook is followed.

## Deployment And Promotion

Default flow:

1. Create or update feature spec.
2. Create feature branch.
3. Implement approved plan.
4. Run checks locally.
5. Open PR into `main`.
6. Merge only when checks pass.
7. Deploy `main` to staging/QA.
8. Promote a known commit/tag to production after smoke tests and release approval.

Production should deploy from an explicit Git commit or tag, not from an unreviewed local state.

Suggested production tag format:

```text
prod-YYYY-MM-DD-N
```

Example:

```text
prod-2026-06-15-1
```

## Feature Planning Levels

KidFlow uses three levels of planning:

1. Main plan / product bible:
   - `docs/PRODUCT_REQUIREMENTS.md`
   - Defines product, users, scope, architecture, safety, and repo ownership.

2. Feature overview:
   - `docs/features/KF-###-feature-name.md`
   - Defines goal, non-goals, affected repos, data touched, child-data impact, APIs, DB/RLS, risks, tests, and acceptance criteria.

3. Feature-specific implementation plan:
   - Created immediately before coding.
   - Lists exact files, migrations, functions, UI pieces, tests, verification steps, and rollout notes.
   - Requires approval before implementation.

No implementation starts without an approved feature overview and implementation plan.

## Cross-Repo Feature Rule

If a feature touches data, auth, RLS, payments, registration conversion, notifications, jobs, vendors, or child-data permissions, the lead feature spec lives in `kidflow-backend`.

Create web/mobile/site child specs only when UI work has enough detail to need separate implementation steps.

Example:

```text
kidflow-backend/docs/features/KF-001-auth-org-centre-roles-rls-foundation.md
kidflow-web/docs/features/KF-001-director-shell-auth-integration.md
kidflow-mobile/docs/features/KF-001-parent-staff-auth-integration.md
```

## Database Change Rules

- All schema changes are SQL migrations in `kidflow-backend`.
- Migrations run local/dev first, staging second, production last.
- Migrations must be reversible or include a rollback/repair note.
- Personal-data tables require RLS before production.
- Generated DB types are regenerated after schema changes.
- Seed data must be synthetic.
- No production data dumps into local/dev.

## Secrets

- No secrets in git.
- No service-role keys in web, mobile, site, browser bundles, screenshots, or docs.
- Secrets are environment-specific.
- Stripe test/live keys must never mix.
- Webhook signing secrets are unique per environment.

## Minimum Checks Before Merge

Backend:

- SQL migration applies cleanly.
- RLS/permission tests or manual verification documented.
- API/function tests or smoke checks pass.
- Stripe webhook/idempotency behavior verified if touched.

Web:

- Type check.
- Lint.
- Build.
- Browser smoke check for changed flow.

Mobile:

- Type check.
- Lint.
- Expo/mobile smoke check for changed flow.

Site:

- Type check.
- Lint.
- Build.
- Browser smoke check.

## Release Gates Before Real Sunridge Data

Production launch is blocked until:

- Paid production Supabase project exists in Canada Central.
- Backup/PITR plan exists and restore test is documented.
- Legal/privacy review is complete.
- Vendor/processor register is reviewed.
- Stripe Connect/payment terms are reviewed.
- Incident response and breach log process exist.
- RLS matrix is tested for director/admin, staff, parent/guardian, restricted guardian, and public applicant boundaries.
- Logging redaction is verified.

## First Development Sequence

1. Commit current planning/design docs.
2. Create `KF-001 auth + org/centre + roles + RLS foundation` in `kidflow-backend`.
3. Approve the `KF-001` implementation plan.
4. Scaffold backend/Supabase foundation.
5. Add initial schema, RLS, generated types, and synthetic seed data.
6. Build director web shell/dashboard against the approved backend foundation.
