# API Rules

- Validate every request at the server boundary.
- Authorize every request by user, organization, role, and resource ownership.
- Keep API responses minimal and role-specific.
- Do not leak child/family existence through public endpoints.
- Make sensitive mutations idempotent where retries are possible.
- Audit important state changes: registration submit, approval, decline, enrollment conversion, consent, payment, incident, staff deactivation.
- Error messages must not expose tenant, child, family, payment, or internal integration details.
