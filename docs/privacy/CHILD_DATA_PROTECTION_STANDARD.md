# Child Data Protection Standard

Status: mandatory planning standard.

KidFlow handles children, families, staff, and childcare operations. Child data is the highest sensitivity class.

## Core Principles

- Default deny: no access unless the role and purpose require it.
- Purpose limitation: collect and use child data only for documented childcare, billing, safety, communication, or legal/compliance purposes.
- Data minimization: do not collect optional sensitive information unless it changes care, safety, billing, or compliance.
- No public child data: never expose child records, photos, attendance, reports, incidents, or waitlist status through public URLs.
- No raw child data in logs: redact names, medical notes, addresses, messages, and form payloads.
- No child data in analytics: avoid child identifiers, free-text notes, photos, and detailed family data.
- No unapproved AI/vendor sharing: any AI or third-party processor use must be documented and approved first.
- Auditability: sensitive access and state changes need audit trails.

## Required Controls

- Supabase RLS on every table that contains personal information.
- `org_id` or equivalent tenant boundary on operational records.
- Parent/guardian access scoped to their own children/family and guardian permissions.
- Staff access scoped to assigned/current classrooms and operational need.
- Director/admin access scoped to their centre/organization.
- Service-role usage restricted to `kidflow-backend` server-only paths.
- No service-role key in mobile, website, browser code, logs, screenshots, or docs.
- Server-side validation for all sensitive writes.
- Private storage policies for photos and documents.
- Signed URLs or equivalent private access for media.
- Redaction for logs and support views.
- Backups and restore testing before launch.

## Sensitive Feature Checklist

Before implementing any feature that touches child data:

- [ ] Feature spec lists data touched.
- [ ] Consent requirement is known.
- [ ] Role access is known.
- [ ] RLS impact is known.
- [ ] Logging/redaction approach is known.
- [ ] Vendor/processor impact is known.
- [ ] Retention/deletion impact is known.
- [ ] Failure mode is known.
- [ ] Test plan includes security/RLS checks.

If any item is unclear, implementation stops.
