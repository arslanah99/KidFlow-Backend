# KF-001 Verification Notes

Status: implemented and locally verified.

## Created

- Supabase project scaffold: `supabase/config.toml`
- Foundation migration: `supabase/migrations/000001_kf001_foundation.sql`
- Synthetic seed data: `supabase/seed.sql`
- RLS verification SQL: `supabase/tests/kf001_rls.sql`
- Environment example: `.env.example`
- Generated-types instructions: `src/types/README.md`

## Dummy Frontend Status

Not applicable for KF-001 because this is backend foundation work. The backend substitute is schema contracts, synthetic seed fixtures, RLS helper functions, and SQL verification cases.

## Validation Attempt

Initial validation attempt was blocked because Docker Desktop was not running. After Docker Desktop was started, KidFlow local Supabase ports were moved to avoid a conflict with another local Supabase project:

- API: `55321`
- DB: `55322`
- Studio: `55323`
- Inbucket: `55324`
- Analytics: `55327`

Validated:

```bash
supabase start
supabase db reset
supabase gen types typescript --local
psql "postgresql://postgres:postgres@127.0.0.1:55322/postgres" -v ON_ERROR_STOP=1 -f supabase/tests/kf001_rls.sql
```

Result:

```text
Finished supabase db reset on branch main.
KF-001 RLS checks passed
```

Notes:

- `citext` grant warnings appear during reset. They are Supabase extension grant warnings, not migration failures.
- `src/types/database.types.ts` was generated from the local schema.

## Repeat Validation

With Docker Desktop running:

```bash
supabase start
supabase db reset
supabase gen types typescript --local > src/types/database.types.ts
psql "postgresql://postgres:postgres@127.0.0.1:55322/postgres" -v ON_ERROR_STOP=1 -f supabase/tests/kf001_rls.sql
```

## Browser QA

Codex in-app browser QA is not applicable yet because KF-001 currently creates no browser-visible endpoint, health page, docs page, or UI flow. If a browser-visible endpoint is added later, it must be verified in the Codex in-app browser before KF-001 is marked complete.
