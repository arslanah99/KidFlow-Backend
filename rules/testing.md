# Testing Rules

Backend verification should include:

- Unauthenticated access denied.
- Cross-tenant access denied.
- Parent cannot access another family's data.
- Staff cannot access unassigned classroom data.
- Director/admin cannot access another organization.
- Public registration endpoints do not leak private records.
- Stripe webhooks are signature-verified and idempotent.
- Jobs can be retried safely.
- Logs are redacted.
