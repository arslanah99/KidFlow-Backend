# Incident Response Runbook

Status: planning baseline requiring legal/security review.

## Incident Types

- Unauthorized access to child/family/staff data.
- Lost or exposed secrets.
- RLS policy failure.
- Payment/webhook mismatch.
- Public form data exposure.
- Photo/media leakage.
- Mis-sent email/SMS/push notification.
- Compromised staff/director account.
- Vendor breach affecting KidFlow data.

## Immediate Response

1. Contain the issue.
2. Preserve evidence.
3. Disable affected keys, endpoints, accounts, jobs, or public forms if needed.
4. Identify affected organizations, users, records, and data categories.
5. Assess sensitivity and probability of misuse.
6. Notify legal/privacy counsel.
7. Decide regulator/customer/individual notification requirements.
8. Record the incident and decisions.
9. Fix root cause.
10. Add regression tests or monitoring.

## Breach Record Fields

- Incident ID.
- Date/time detected.
- Date/time occurred if known.
- Reporter.
- Affected organizations.
- Affected individuals or estimate.
- Data categories involved.
- Cause.
- Systems/vendors involved.
- Containment actions.
- Risk assessment.
- Notification decision.
- Notifications sent.
- Root-cause fix.
- Follow-up owner.
