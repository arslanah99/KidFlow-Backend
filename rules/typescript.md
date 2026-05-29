# TypeScript Rules

- Use TypeScript for Edge Functions, serverless APIs, scripts, generated clients, and shared backend utilities once backend code is scaffolded.
- Prefer generated Supabase database types as the canonical schema contract.
- Validate all external input at API/function boundaries with explicit schemas.
- Do not use `any` for child data, parent/guardian data, staff data, auth, permissions, API payloads, database rows, consent/legal records, billing/payment records, Stripe payloads, or vendor responses unless the feature plan documents a narrow boundary exception.
- Prefer `unknown` plus validation for untrusted input.
- Keep domain types narrow and explicit for organizations, centres, roles, children, guardians, staff, classrooms, enrollment, attendance, billing, payments, consents, incidents, messages, and audit events.
- Do not manually duplicate database shapes once generated types exist unless a feature-specific view model is clearly safer.
- Keep service-role-only code isolated behind backend functions and never leak privileged types or secrets to client repos.
