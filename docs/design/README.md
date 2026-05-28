# Backend Design References

Backend features usually do not have visual designs, but they often support product screens.

Link the web, mobile, or site designs that depend on backend behavior. If no design exists, state that in the feature spec.

## Local Figma PDF Exports

- Director web print: `docs/design/artifacts/kidflow-director-web-print.pdf`
- Enrollment system print: `docs/design/artifacts/kidflow-enrollment-system-print.pdf`
- Parent mobile print: `docs/design/artifacts/kidflow-parent-mobile-print.pdf`
- Staff tablet print: `docs/design/artifacts/kidflow-staff-tablet-print.pdf`

These PDFs are checked into this repo so backend specs do not depend on Desktop files. If the live Figma changes, export a fresh PDF into `docs/design/artifacts/` and update this file.

## Backend Implications From Designs

- Auth/roles/RLS must support director/admin, staff/classroom, parent/guardian, public applicant, and support/founder.
- Attendance must support child check-in/out, parent/authorized adult verification, notes from parent, item checklists, and staff/classroom movement.
- Staff hours must support clock-in/out, breaks, room assignment, and director/admin correction later.
- Enrollment must support form builder schemas, PDF mapping, save-and-continue submissions, tour bookings, deposits, submission pipeline states, duplicate/spam handling, exports, consent versions, and app onboarding.
- Billing must support tuition plan templates, child-level plan assignment, discounts, subsidies, invoice generation, payment method onboarding, autopay, failed payment lifecycle, reminders, receipts/statements, and tax receipts.
- Messaging must support parent-staff, parent-director/admin, classroom/group announcements, attachments, translation planning, reply policy, and director visibility.
- Reports/photos must support activity logs, report preview/send, photo tagging, visibility controls, and media access rules.
- Incidents must support draft/review/approval, witness records, body/location details, private incident attachments, parent acknowledgement later, and audit logs.
- Public and mobile-web enrollment surfaces must avoid enumeration and must rate-limit/spam-protect before launch.
