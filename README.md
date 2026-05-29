# KidFlow Backend

Backend/API repo for KidFlow.

This repo owns server-side authority for the product. It is separate from the web, mobile, and marketing apps so secrets, database ownership, integrations, jobs, and API contracts stay in one controlled place.

## Repo Role

- Owns Supabase initialization/configuration.
- Owns database migrations and RLS policy definitions.
- Owns generated database types and shared contracts once the schema exists.
- Owns server-only secrets and service-role usage.
- Owns Stripe webhooks, Connect onboarding, SetupIntent/PaymentIntent creation, invoice/payment reconciliation, and billing authority.
- Owns registration submission APIs, enrollment approval/conversion APIs, auth callback support, health checks, and background jobs.
- Provides secure APIs consumed by `kidflow-web` and `kidflow-mobile`.

## Related Repos

- `../kidflow-web`: product web app.
- `../kidflow-mobile`: Expo mobile app.
- `../kidflow-site`: public marketing site.

## Before Backend Coding

1. Read `docs/PRODUCT_REQUIREMENTS.md`.
2. Read `docs/architecture/ADR-001-backend-platform-and-database.md`.
3. Read `docs/DEVELOPMENT_WORKFLOW.md`.
4. Read the relevant feature spec in `docs/features/`.
5. Read relevant privacy/security/vendor docs in `docs/privacy/`, `docs/security/`, and `docs/vendors/`.
6. Read relevant files in `rules/`.
7. Confirm data, child-data, consent, RLS, payment, and vendor impact.
8. Create a plan and get approval before implementation.

## KF-001 Local Supabase Foundation

KF-001 adds the first Supabase schema, synthetic seed data, and RLS verification checks.

Files:

- `supabase/config.toml`
- `supabase/migrations/000001_kf001_foundation.sql`
- `supabase/seed.sql`
- `supabase/tests/kf001_rls.sql`

Local commands:

```bash
supabase start
supabase db reset
supabase gen types typescript --local > src/types/database.types.ts
psql "postgresql://postgres:postgres@127.0.0.1:55322/postgres" -v ON_ERROR_STOP=1 -f supabase/tests/kf001_rls.sql
```

Phase 0 rules:

- Use synthetic data only.
- Do not enter real Sunridge child, parent, staff, billing, medical, incident, photo, or message data.
- Keep service-role keys only in ignored local env files.
- Treat `src/types/database.types.ts` as generated output from the local schema.
- KidFlow local Supabase uses ports `55320-55329` to avoid conflicts with other local Supabase projects.
