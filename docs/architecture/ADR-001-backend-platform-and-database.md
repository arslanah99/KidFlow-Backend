# ADR-001 Backend Platform And Database

Status: Accepted for MVP planning

Date: 2026-05-28

## Context

KidFlow is a Canada-first childcare operations platform. It will process high-sensitivity child, family, staff, billing, consent, photo, attendance, incident, and message data.

The first real centre is Sunridge / Kids Planet. The schema must still support multiple organizations and multiple centres from the beginning.

The backend must support:

- Strong tenant isolation.
- Role-based permissions.
- Parent/guardian-specific access.
- Staff classroom scoping.
- Private file storage.
- Stripe Connect billing.
- Secure public registration and tour flows.
- Auditable sensitive changes.
- A migration path if the platform changes later.

## Decision

KidFlow will use Supabase Cloud Postgres for MVP development and production readiness.

Default setup:

- Database: Postgres through Supabase Cloud.
- Region: Canada Central (`ca-central-1`) for production.
- Auth: Supabase Auth.
- Authorization: Postgres Row Level Security.
- Storage: Supabase Storage with private buckets and RLS-backed access rules.
- Backend APIs: Supabase Edge Functions/serverless functions in `kidflow-backend`.
- Payments: Stripe and Stripe Connect. Stripe stores card/payment method details.
- Migrations: plain SQL migrations owned by `kidflow-backend`.
- Generated DB types: generated from the backend schema and treated as canonical.

The free tier may be used for local/dev experimentation only. Real Sunridge child, parent, staff, billing, medical, incident, or photo data must not enter a free-tier/dev project.

Before real production data:

- Create paid production Supabase project in Canada Central.
- Create separate dev/staging/production environments.
- Enable appropriate backups/PITR for production.
- Confirm vendor/DPA/legal review.
- Confirm backup and restore process.
- Confirm RLS verification for all personal-data tables.

## Portability Rules

Supabase is the MVP managed platform, but KidFlow must avoid unnecessary lock-in.

Rules:

- Keep schema changes in SQL migrations.
- Keep business rules in `kidflow-backend` APIs, migrations, constraints, RLS, and reusable server modules.
- Do not scatter privileged business rules across web/mobile clients.
- Store Stripe object IDs and billing state in Postgres, but never raw card numbers.
- Store file metadata in Postgres and files in private storage buckets.
- Keep service-role use in backend-only code.
- Keep web/mobile/site as clients of backend APIs for sensitive operations.
- Document every Supabase-specific dependency in feature specs.

If Supabase becomes limiting later, the intended migration path is:

- Postgres data/schema to AWS RDS/Aurora Postgres, Neon, Crunchy Bridge, or another managed Postgres.
- Auth migrated separately with a planned user/account migration.
- Storage files migrated separately with metadata mapping.
- Backend APIs moved to a dedicated server or serverless platform.
- Stripe remains the payment vault if the same Stripe account/Connect setup is preserved.

## Alternatives Considered

### AWS RDS/Aurora Postgres From Day One

Pros:

- Maximum infrastructure control.
- Mature enterprise backup/networking options.
- Clear separation between database and application platform.

Cons:

- Requires separate auth, storage, RLS integration patterns, API hosting, local dev setup, admin tooling, and operational work.
- Higher solo-dev complexity.
- More chances to create security gaps before product-market fit.

Decision: do not start here. Revisit after MVP or if Supabase limits block production needs.

### Self-Hosted Postgres/Auth/Storage

Pros:

- Maximum control.

Cons:

- Too much operational and security burden for a solo-dev childcare SaaS.
- Higher launch risk for child data.

Decision: not appropriate for MVP.

## Consequences

- Supabase must be treated as production infrastructure, not a toy.
- RLS design is a first-class product requirement.
- `kidflow-backend` owns all schema, RLS, APIs, secrets, jobs, and generated types.
- Web/mobile/site must not bypass backend authority for sensitive writes.
- Free tier is only a sandbox.
- Production launch requires paid infrastructure, backups/PITR, legal/vendor review, and restore testing.

## Open Follow-Ups

- Choose exact Supabase project names for local/dev/staging/prod.
- Decide whether staging also uses Canada Central.
- Define backup export process outside Supabase.
- Define auth email templates and redirect URLs per environment.
- Define first RLS matrix in `KF-001`.
