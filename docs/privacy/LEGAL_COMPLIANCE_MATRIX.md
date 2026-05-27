# Legal Compliance Matrix

Status: planning baseline, not legal advice.

Legal review by a qualified Canadian privacy lawyer is required before launch.

## Scope

KidFlow is planned as a Canada-first childcare SaaS. It will process personal information about children, parents/guardians, staff, directors, billing contacts, and public applicants.

This matrix is a planning checklist for product and engineering. It does not replace legal counsel.

## Canada-Wide Baseline

| Area | Planning Requirement | Product Impact | Launch Status |
| --- | --- | --- | --- |
| Accountability | Assign a privacy owner and document responsibilities. | Privacy officer/contact must exist before launch. | Open |
| Identifying purposes | State why each data category is collected before or at collection. | Registration, billing, photos, daily reports, messaging, and incident flows need clear purposes. | Open |
| Meaningful consent | Consent must be understandable and tied to specific purposes. | Registration and parent onboarding need versioned consent records. | Open |
| Children and consent | Parent/guardian consent is required for young children who cannot meaningfully consent. | Child data collection cannot start without guardian consent flow. | Open |
| Limiting collection | Collect only what is needed for childcare operations and billing. | Avoid optional sensitive fields unless justified. | Open |
| Limiting use/disclosure/retention | Use data only for stated purposes and retain only as long as required. | Retention/deletion policy must exist before launch. | Open |
| Accuracy | Allow appropriate correction/update flows. | Parent and director editing workflows must be designed. | Open |
| Safeguards | Safeguards must match sensitivity. Child data requires strongest controls. | RLS, least privilege, encryption, audit logs, admin controls, and redaction required. | Open |
| Openness | Privacy practices must be public and accessible. | Privacy policy and processor list needed. | Open |
| Individual access/challenge | Families may need access/correction/challenge workflows. | Support process and export/correction tools needed. | Open |
| Breach reporting | Breaches posing real risk of significant harm may require regulator reporting, individual notice, and records. | Incident response runbook and breach log required. | Open |

## Provincial/Territorial Overlay

Design to a strict practical Canada-wide baseline. Alberta, British Columbia, and Quebec have private-sector privacy laws substantially similar to PIPEDA; Quebec/Law 25 needs its own launch checklist before Quebec sales.

## Launch Blockers

- Legal privacy review.
- Terms of service review.
- Privacy policy review.
- Registration consent review.
- Photo/media consent review.
- Payment/deposit terms review.
- Breach response review.
- Vendor processor list review.
- Retention/deletion policy review.
