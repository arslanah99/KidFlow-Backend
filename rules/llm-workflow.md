# LLM Workflow Rules

Before backend implementation:

1. Read `docs/PRODUCT_REQUIREMENTS.md`.
2. Read the relevant feature spec.
3. Read relevant privacy/security/legal docs.
4. Read relevant backend rules in this folder.
5. Ask blocking questions.
6. Surface concerns and recommendations.
7. Create a plan.
8. Wait for approval.

The `rules/` folder is the backend implementation source of truth. Every feature plan must list the rules files consulted, and implementation must follow those rules unless an exception is explicitly documented and approved in the feature spec.

## Default Feature Delivery Loop

Every feature document must include segmented implementation steps. If a step is too large, split it into smaller substeps such as `2A`, `2B`, and `2C` so the work can be completed properly without hiding risk inside one broad task.

Backend work normally starts after the relevant user-facing dummy frontend has been reviewed and approved in `kidflow-web`, `kidflow-mobile`, or `kidflow-site`.

Default loop:

1. Dummy frontend first:
   - The affected frontend repo creates or updates the dummy UI with synthetic typed data and mocked API responses.
   - The dummy frontend is reviewed and iterated until the desired UX, screens, copy, and flow are accepted.
   - The LLM explicitly asks the user to review the dummy frontend and provide feedback before backend implementation starts.
   - Requested dummy frontend fixes are completed before backend implementation starts.
2. Backend only:
   - Backend schema, RLS, functions, jobs, Stripe/webhook logic, and API contracts are created from the approved requirements, feature spec, privacy/security rules, and accepted dummy frontend flow.
   - Do not invent backend behavior that is not in the requirements or approved feature plan.
3. Connect frontend and backend:
   - Replace mocks with typed backend calls.
   - Keep test fixtures clearly separated from production code.
4. Manual test:
   - Test the connected feature end to end with synthetic data.
   - Include RLS/security checks, relevant automated checks, and Codex in-app browser QA for browser-visible surfaces.
5. Feedback loop:
   - Provide results for user manual testing.
   - Repeat steps 4 and 5 until the desired result is reached.
   - If feedback changes data model, permissions, payments, child-data handling, or UX materially, update the feature spec/plan before changing code.

Backend-only exception:

- Foundational backend work, security/RLS work, migrations, jobs, webhooks, and pure data-contract work can skip dummy frontend only when the feature plan explicitly says "dummy frontend not applicable" and explains why.
- In that case, create clear API contracts, SQL examples, seed fixtures, RLS verification cases, or mock response examples before implementation.

Use typed, DRY, maintainable code. Do not use `any` for domain, child-data, payment, consent, auth, permission, API, database, or vendor payloads unless a narrow boundary exception is justified. Push back when a requested implementation conflicts with privacy, security, architecture, data ownership, maintainability, or child-safety requirements.

Do not implement if database ownership, RLS, child-data handling, payments, public exposure, or secrets are unclear.
