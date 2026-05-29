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
- Codex in-app browser QA is required for final completion when the backend change has any browser-visible endpoint, docs page, health page, or affected web/mobile/site flow.
- If there is no browser-visible surface, the final verification must explicitly mark Codex browser QA as not applicable with the reason.
