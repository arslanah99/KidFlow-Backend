# KidFlow Development Workflow

Status: mandatory workflow before development

Date: 2026-05-28

## Principle

Branches are not environments.

KidFlow should use protected branches, pull requests, separate runtime environments, and explicit promotion. This avoids four repos drifting across separate `dev`, `qa`, and `prod` branches.

The full environment model is the production-ready target. While KidFlow is on free-tier tooling, use the Phase 0 workflow below.

## Phase 0 Free-Tier Workflow

Free-tier development is allowed before real Sunridge data enters the system.

Phase 0 environments:

- Local: local app and local Supabase where practical.
- Cloud sandbox: one Supabase free project for shared/manual testing.
- No true cloud staging yet.
- No production yet.

Rules:

- Use synthetic data only.
- Stripe test mode only.
- No real child, parent, staff, billing, medical, incident, message, or photo data.
- No live Sunridge operations.
- QA means manual/browser/mobile checks against local and the cloud sandbox.
- Do not call the cloud sandbox "production."
- Do not build production launch assumptions around free-tier limits.

Before real Sunridge use, move out of Phase 0:

- Create paid production Supabase in Canada Central.
- Create staging/QA as a separate project or approved production-like environment.
- Enable backup/PITR plan.
- Complete restore test.
- Complete legal/vendor/privacy review.
- Complete RLS verification.

## Repos

KidFlow has four repos:

- `kidflow-backend`
- `kidflow-web`
- `kidflow-mobile`
- `kidflow-site`

Each repo keeps its own `docs/PRODUCT_REQUIREMENTS.md`, rules, feature specs, and implementation code.

Each repo's `rules/` folder is mandatory implementation context and must be treated as the source of truth for code style, architecture, package expectations, privacy/security, testing, and repo-specific best practices. Every feature-specific implementation plan must list the rules files consulted before code is written.

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

## GitHub Free-Tier Limitations

If private-repo branch protection, rulesets, automatic branch deletion, or other GitHub governance features are unavailable on the current plan, do not distort the architecture to work around that.

Use this manual process until upgrading GitHub is worth it:

1. Work on `codex/kf-###-short-name` or `feature/kf-###-short-name`.
2. Merge through a PR whenever practical.
3. Do not commit directly to `main` except for deliberate docs-only bootstrap work.
4. After merge, delete the remote feature branch manually in GitHub or with:

```bash
git push origin --delete branch-name
```

5. Prune local stale branches periodically:

```bash
git fetch --prune
```

GitHub Actions may still be used on private repos within included free minutes. Keep CI small while free-tier:

- Run checks on PRs and `main`.
- Skip full CI for docs-only changes when possible.
- Prefer Linux runners.
- Avoid expensive scheduled jobs.
- Run local checks before pushing.

Upgrade GitHub only when branch protection, required checks, team permissions, or higher Actions usage becomes materially useful.

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

- May use Supabase free tier during Phase 0.
- Test Stripe only.
- Synthetic data only.
- Can be reset.
- No real Sunridge data.

### Staging / QA

Purpose: production-like testing before release.

Rules:

- Separate Supabase project once paid infrastructure exists.
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
   - Lists exact rules files consulted, dummy frontend approval status or backend-only exception, files, migrations, functions, UI pieces, tests, feedback loop, verification steps, Codex in-app browser QA, and rollout notes.
   - Requires approval before implementation.

No implementation starts without an approved feature overview and implementation plan.

## Default Feature Delivery Loop

For user-facing features, KidFlow builds in this order:

1. Dummy frontend first in the affected frontend repo.
2. Backend only after the dummy frontend is reviewed and accepted.
3. Connect frontend and backend.
4. Manual test with synthetic data.
5. Provide feedback for manual testing and repeat steps 4 and 5 until accepted.

Backend-only foundation, RLS/security, migration, job, webhook, or API-contract work can skip dummy frontend only when the implementation plan explicitly documents the exception and provides contracts, fixtures, SQL/RLS cases, or mock responses instead.

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
- Codex in-app browser QA completed for browser-visible endpoints/pages/flows, or explicitly marked not applicable with reason.

Web:

- Type check.
- Lint.
- Build.
- Codex in-app browser smoke check for changed flow.

Mobile:

- Type check.
- Lint.
- Expo/mobile smoke check for changed flow.
- Codex in-app browser QA for Expo web/auth callback/payment redirect/registration mobile-web or other browser-visible affected surfaces.

Site:

- Type check.
- Lint.
- Build.
- Codex in-app browser smoke check.

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
4. Scaffold backend/Supabase foundation locally and against the cloud sandbox.
5. Add initial schema, RLS, generated types, and synthetic seed data.
6. Build director web shell/dashboard against the approved backend foundation.
7. Upgrade/create paid staging and production only before real Sunridge data or live payments.
