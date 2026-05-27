# Consent And Registration Requirements

Status: planning baseline.

Registration is a protected core workflow because it collects child and family data before a family has a full account.

## Registration Workflow

The registration flow may include:

- Daycare-specific public or QR/link entry.
- Parent/guardian identity.
- Child profile.
- Emergency contacts.
- Authorized pickup people.
- Allergy and medical notes.
- Photo/media consent.
- Communication consent.
- Billing/deposit consent.
- Waitlist status.
- Director approval or decline.
- Enrollment conversion.
- Parent mobile access after approval.

## Consent Requirements

Every consent capture must record:

- Consent type.
- Consent text/version.
- User who consented.
- Child/family relationship.
- Organization/centre.
- Timestamp.
- Source surface: web, mobile, public form, admin entered.
- Related form submission/enrollment/payment if applicable.
- Withdrawal status if withdrawn later.

Production consent text requires legal review.

## Approval Conversion Rules

Director approval must be idempotent. Retrying approval must not duplicate:

- Child records.
- Parent/guardian people.
- Guardian links.
- Emergency contacts.
- Enrollments.
- Billing assignments.

Every approval/decline must create an audit trail.
