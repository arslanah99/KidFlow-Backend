# Backend Architecture Rules

- `kidflow-backend` owns server authority.
- Keep one shared Supabase database.
- Web, mobile, and site are clients; they do not own server secrets or privileged database behavior.
- Put canonical business rules here when they affect permissions, registration conversion, enrollment, billing, payments, jobs, or integrations.
- Design APIs around explicit user, organization, role, and resource ownership checks.
- Keep integrations idempotent and auditable.
- Prefer boring, traceable server flows over clever abstractions.
