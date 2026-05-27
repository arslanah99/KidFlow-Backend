# Data Retention And Deletion

Status: planning baseline requiring legal review.

KidFlow must define retention before launch because it handles child, family, billing, photo, message, staff, and incident data.

## Default Approach

- Keep data only as long as needed for childcare operations, billing records, safety records, legal requirements, dispute handling, and customer support.
- Prefer soft deletion for operational records that need auditability.
- Prefer hard deletion or irreversible anonymization for data with no remaining operational/legal need.
- Never promise deletion timelines until legal review confirms them.

## Data Categories

| Data | Initial Retention Direction | Notes |
| --- | --- | --- |
| Registration submissions | Define centre policy and legal minimums. | Declined/incomplete submissions need shorter retention. |
| Consent records | Retain while related records may be disputed or needed. | Versioned consent is audit evidence. |
| Child profile | Retain during enrollment plus legally reviewed post-enrollment period. | Deactivate instead of deleting while enrolled. |
| Attendance | Retain for operational/legal needs. | May be needed for safety and licensing disputes. |
| Daily reports | Define centre/customer retention. | Parent-facing history may be limited by plan. |
| Photos/media | Shorter retention by default unless centre policy requires more. | Must support removal requests where appropriate. |
| Incidents | Longer retention likely needed. | Legal review required. |
| Messages | Define retention and export policy. | Avoid indefinite retention by accident. |
| Billing/payments | Retain per accounting/tax/payment obligations. | Card data remains with Stripe. |
| Staff records | Retain per employment/customer needs. | Staff deactivation must not erase audit trails. |

## Required Product Capabilities Before Launch

- Data export process for a family/centre.
- Data correction process.
- Deactivation/archive process for children, parents, staff, centres.
- Deletion/anonymization request workflow.
- Backup retention documented.
- Restore test documented.
- Support runbook for access/deletion requests.

Every feature spec must state whether the feature creates new data that needs retention/deletion policy.
