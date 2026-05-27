# Security Baseline

Status: mandatory planning baseline.

## Core Rules

- Server secrets live only in `kidflow-backend` server environments.
- No Supabase service-role key in mobile, site, web browser code, client bundles, screenshots, docs, or logs.
- No Stripe secret key in mobile, site, or web browser code.
- Every personal-data table needs RLS before launch.
- Every sensitive endpoint must validate authenticated user, organization, role, and resource ownership.
- Avoid raw SQL string construction.
- Validate all user input at server boundaries.
- Redact sensitive payloads from logs.
- Use private storage buckets for child photos/documents.
- Add error monitoring before launch with PII scrubbing.
- Test backup and restore before launch.

## Authentication And Authorization

- Use magic link or approved auth provider.
- Require org and role context before loading operational views.
- Parent access is guardian/family scoped.
- Staff access is classroom scoped by default.
- Director/admin access is organization scoped.
- Support/founder access requires explicit support process and audit trail.

## Payments

- Use Stripe Elements, Checkout, PaymentSheet, or Stripe-hosted/tokenized flows.
- Never handle raw card numbers.
- Verify Stripe webhook signatures.
- Make webhook handlers idempotent.
- Store Stripe IDs and status, not card details.
- Keep payment authority server-side.

## Public Surfaces

- Public registration and marketing lead forms must have spam/rate-limit strategy before production.
- Public routes must never reveal whether a child/family exists.
- Error messages must avoid exposing record IDs, emails, child names, or tenant details.

## Security Verification Requirements

Each sensitive feature must include:

- RLS tests or manual RLS verification.
- Authenticated/unauthenticated access checks.
- Cross-tenant access checks.
- Parent/staff/director role checks.
- Logging/redaction check.
- Failure mode check.
