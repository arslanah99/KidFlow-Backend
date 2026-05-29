# FEATURE_ID Feature Name

Status: Draft

Approval status: Not approved for implementation.

## Goal

Describe the user outcome and backend/business reason.

## Non-Goals

List what this backend slice will not do.

## Users

- Director/admin:
- Staff:
- Parent/guardian:
- Public applicant:
- Support/founder:

## Affected Surfaces/Repos

- `kidflow-backend`:
- `kidflow-web`:
- `kidflow-mobile`:
- `kidflow-site`:

## Product Requirements Read

- `kidflow-backend/docs/PRODUCT_REQUIREMENTS.md`:
- Other affected repo PRDs:

## Repo Rules Read

List every relevant `rules/` file consulted before planning and implementation. The repo rules are the implementation source of truth.

- `rules/architecture.md`:
- `rules/api.md`:
- `rules/supabase-rls.md`:
- `rules/stripe.md`:
- `rules/typescript.md`:
- `rules/privacy-security.md`:
- `rules/testing.md`:
- `rules/llm-workflow.md`:
- Other:

## Data Touched

- Child data:
- Parent/guardian data:
- Staff data:
- Billing/payment data:
- Consent/legal records:
- Photos/media:
- Messages/notifications:

## Child-Data Impact

State whether the feature collects, displays, updates, transmits, stores, exports, deletes, or derives child data.

If child-data impact is unclear, do not implement.

## Consent And Legal Impact

- Consent required:
- Consent copy/version needed:
- Withdrawal/deletion impact:
- Legal/privacy review needed:

## Privacy And Security Risk

- Permissions/RLS:
- Logging/redaction:
- Audit trail:
- External vendors:
- Abuse/misuse cases:
- Failure impact:

## API And Backend Impact

- API routes/functions:
- Supabase direct access:
- Stripe/Resend/Twilio/Expo/Sentry:
- Secrets:
- Scheduled/background jobs:

## Database And RLS Impact

- Tables:
- Migrations:
- RLS policies:
- Indexes:
- Generated types:
- Backfill/seed data:

## Implementation Steps

Feature docs must break work into clear, sequential steps. If a step is too large, split it into smaller parts such as `2A`, `2B`, and `2C` so the feature can be completed properly without hiding risk inside one giant task.

1. Context and rules:
   - Read PRD, feature spec, repo rules, privacy/security docs, and design/API references.
2. Dummy frontend review gate:
   - If the feature has any user-facing surface, reference the accepted dummy frontend from `kidflow-web`, `kidflow-mobile`, or `kidflow-site`.
   - The LLM must explicitly ask the user to review the dummy frontend and provide feedback before backend implementation starts.
   - Fix requested dummy frontend changes before moving to backend.
   - If backend-only, document the exception and provide contracts, fixtures, SQL/RLS verification cases, or mock responses instead.
3. Backend build from approved requirements:
   - `3A` database/schema/migrations, if needed:
   - `3B` RLS/permissions/security, if needed:
   - `3C` API/functions/jobs/webhooks, if needed:
   - `3D` generated types/contracts, if needed:
4. Connect frontend and backend, if applicable:
   - Replace mocks with typed backend calls.
   - Keep fixtures separate from production code.
5. Manual test with synthetic data:
   - Run local/manual checks.
   - Capture issues, screenshots/log notes where useful, and verification results.
6. User feedback loop:
   - Provide results for user manual testing.
   - Ask the user what needs to be fixed.
   - Repeat steps 5 and 6 until accepted.
7. Final verification:
   - Run required tests/checks.
   - Run Codex browser QA if there is any browser-visible surface, or document why not applicable.

## Open Questions

- Blocking:
- Recommended:
- Optional:

## Concerns And Recommendations

- Critical concerns:
- Strong recommendations:
- Nice-to-have:

## Testing Plan

- Unit:
- Integration:
- RLS/security:
- Webhook/job:
- E2E/manual:
- Codex in-app browser QA:
  - Required final verification for browser-visible endpoints/pages/flows.
  - If not applicable, explain why this backend feature has no browser-visible surface.

## Acceptance Criteria

- [ ] User outcome works.
- [ ] Child-data impact is documented.
- [ ] Relevant repo rules were read, followed, and any approved exception is documented.
- [ ] Dummy frontend was reviewed by the user and accepted before backend work, or backend-only exception is documented.
- [ ] Permissions/RLS are verified.
- [ ] Consent/legal needs are handled or marked launch-blocking.
- [ ] API/data contracts are documented.
- [ ] Tests/verification are complete.
- [ ] Codex in-app browser QA is complete or explicitly marked not applicable with reason.
- [ ] No implementation proceeded before plan approval.
