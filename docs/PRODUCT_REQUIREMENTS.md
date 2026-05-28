# KidFlow Backend Product Requirements

Status: repo-specific product bible before backend scaffolding.

## Shared Product Context

KidFlow is a Canada-first childcare operations platform for daycares. The first real centre is Sunridge / Kids Planet. The product must feel like a smooth transition from Lillio/HiMama for directors, staff, and parents, while improving registration, billing, staff hours, parent communication, reporting, and safety.

MVP is one centre first. The architecture should not hardcode Sunridge in a way that blocks later multi-centre expansion.

Repos:

```text
kidflow-backend   # APIs, Supabase, RLS, secrets, jobs, integrations
kidflow-web       # Product web app for directors/admins/staff/parents
kidflow-mobile    # Mobile app for parents, staff, directors, admins
kidflow-site      # Public marketing website
```

KidFlow is Canada-only for v1. Child data is highest sensitivity. Legal/privacy review is a launch blocker.

## Backend Mission

`kidflow-backend` is the server authority for KidFlow. It owns data contracts, Supabase setup, RLS, server-only secrets, Stripe, background jobs, and API endpoints used by web, mobile, and site.

It is not a user-facing app and must not contain product UI.

## Ownership

The backend owns:

- Supabase project initialization and configuration.
- Database migrations.
- RLS policies.
- Generated database types as the source of truth.
- Server-only secrets and service-role usage.
- API endpoints for web, mobile, and site.
- Stripe Connect, Checkout/PaymentIntent/SetupIntent creation, webhooks, payment reconciliation, and deposit handling.
- Registration submission APIs, tour/intake APIs, waitlist state changes, and enrollment conversion.
- Billing cadence, invoice lifecycle, manual payment recording, tax receipt generation, and billing exports.
- Scheduled/background jobs for invoices, reminders, reports, retries, receipt generation, and health checks.
- Email/SMS/push event dispatch where server validation is required.
- Audit logs for sensitive state changes.

The backend must not own:

- Web dashboard UI.
- Mobile UI.
- Marketing pages.
- Public sales content.
- Raw card handling.
- Legal advice or final legal copy.

## Architecture Defaults

Use a Supabase-first backend for MVP:

- Supabase migrations for schema.
- Supabase RLS for data isolation.
- Supabase Edge Functions or serverless API functions for privileged operations.
- Supabase scheduled jobs/cron where appropriate.
- Stripe webhooks and integration code in backend-only functions.

A traditional backend server such as NestJS/Fastify/Express is not the MVP default. Revisit only if Supabase-first functions are not enough.

The accepted platform decision is documented in `docs/architecture/ADR-001-backend-platform-and-database.md`. The development, branch, environment, and release workflow is documented in `docs/DEVELOPMENT_WORKFLOW.md`.

## API Shape

APIs should be grouped first by consuming surface, then domain:

```text
/web/billing/...
/web/registration/...
/web/children/...

/mobile/billing/...
/mobile/reports/...
/mobile/messages/...

/site/leads/...
/site/demo-requests/...
```

Domain logic must remain shared behind these routes so web and mobile do not duplicate billing, enrollment, registration, or permission rules.

For MVP, web and mobile should call backend APIs for writes and sensitive reads. Direct Supabase client access from web/mobile is allowed only when explicitly approved, RLS-safe, and documented in the feature spec.

## Generated Types

Generated database types live in `kidflow-backend` as the canonical source. Web/mobile can consume copied or packaged types later, but the schema authority remains backend.

## Core Data Domains

MVP backend domains:

- Organizations/centres.
- Roles and permissions: director/admin, staff/classroom, parent/guardian.
- Children.
- Parents/guardians.
- Guardian access permissions, including restricted/limited access.
- Emergency contacts and authorized pickups.
- Staff and classroom movement.
- Classrooms and ratio settings.
- Child attendance.
- Staff clock-in/out and staff hours.
- Registration forms, form versions, submissions, signatures, uploads, and save-and-continue state.
- Tour booking/intake.
- Waitlist and enrollment conversion.
- Billing plans, cadence, subsidies, discounts, invoices, payments, manual payments, deposits, receipts, and tax receipts.
- KidFlow centre subscriptions and public pricing plan state.
- Activity logs, daily reports, photos, messaging, incidents.
- Audit logs.

## Billing, Payments, And Tax Receipts

Parent tuition/deposit payments and KidFlow's own daycare subscription billing are separate systems. Do not mix parent invoice money with KidFlow plan/subscription revenue.

MVP must support flexible billing cadence per child/enrollment:

- Monthly.
- Weekly.
- Biweekly.
- Other predefined daycare-selected rates.

MVP must support:

- Subsidy tracking.
- Discounts attached to a child/enrollment and reflected on invoices.
- Manual one-off charges such as late fees, extra days, or other daycare-created invoice items.
- Manual payment recording for cash, e-transfer, or external card payments.
- Stripe payments through Stripe Connect directly to the daycare.
- Optional autopay controlled by parents, with daycare-level requirement settings and exemptions.
- Failed payment status visible in invoice lifecycle and parent notification.
- Automatic receipt emails where configured.

KidFlow does not decide daycare refunds. It records refund/adjustment facts when the daycare handles them.

Tax receipt MVP:

- Yearly tax receipts are required.
- Tax receipt totals include paid invoices only, including manual payments marked paid.
- Tax receipts are per child.
- Directors/admins can bulk export.
- Parents can download/receive receipts only when the daycare releases them.
- Directors adjust receipt amounts by correcting invoice/payment records, not by editing receipt totals directly.

## KidFlow Centre Subscription Model

KidFlow's public pricing is daycare-size based:

- Free tier for centres with up to 5 children.
- Paid plans after 5 children, based on daycare size.
- Primary buyer/user for this billing is the owner/director/admin, not the parent.

For the first Sunridge/Kids Planet internal MVP, centre subscription billing can be tracked manually if needed. The backend must still keep the data model conceptually separate from parent tuition payments so Stripe Connect daycare payouts do not become confused with KidFlow subscription revenue.

## Registration And Intake

MVP includes tour booking and registration together.

Flow:

1. Family books a tour, scans a QR code, or uses a daycare-specific registration/intake link.
2. Parent enters contact info: name, phone, email.
3. If configured, parent pays a non-refundable or registration-related fee through Stripe Connect.
4. Parent receives an email with a magic link to the daycare-specific registration form.
5. Parent completes one registration form per child.
6. Form supports save-and-continue.
7. Form supports e-signatures, file uploads, medical/allergy sections, and consent sections.
8. Submission goes to director/admin.
9. Director/admin may edit editable fields, but signed consent records must remain auditable and not silently editable.

Daycares can customize registration forms using KidFlow-provided templates. Importing existing daycare forms and staff registration forms are later features unless promoted.

## Attendance And Staff Hours

MVP separates child attendance from staff hours.

- Child check-in/out is done by staff, admin, or director.
- Parent QR/PIN pickup is post-MVP.
- Authorized pickup recording at checkout is not MVP unless promoted.
- Staff clock-in/out is MVP.
- Staff hours can be manually edited by director/admin for past days.
- Manual edit reason is optional.
- Staff cannot view their own hours in MVP.
- Staff cannot request time corrections in MVP.
- Ratio warnings use classroom settings, not hardcoded Alberta rules.

Staff can start in one classroom and move to another. Current classroom assignment determines which children staff can see.

## Daily Reports, Photos, Messaging, Incidents

Daily report MVP includes:

- Meals.
- Naps.
- Bathroom.
- Mood.
- Activities.
- Photos.
- Notes.

Reports can be sent manually, such as from a "send report" button after checkout, or automatically at a configured time. Staff can send reports directly.

Photos:

- Staff can upload photos.
- No director approval required for photos in MVP.
- One photo is tagged to one child in MVP.
- Parents can download photos.

Messaging:

- Parents can message staff.
- Parents can message director/admin.
- Staff can message parents directly.
- Director/admin can see staff-parent messages.
- Classroom/group announcements are MVP.
- Attachments/photos in messages are MVP.
- Read receipts are not MVP.

Incidents:

- MVP incident types: injury, illness, behavior, medication, other.
- Staff can create incident reports.
- Incidents require director/admin approval before parents see them.
- No parent signature/acknowledgement in MVP.
- Incident photos are not MVP unless promoted.
- Severe immediate parent notification before director approval is not MVP.
- Incident reports are not editable after parent acknowledgement when acknowledgement exists in a later version.

## Custody And Guardian Access

MVP must support guardian-level permissions because safety risk is high.

- Director/admin controls guardian access.
- One guardian can have full access while another has limited or no access.
- Limited-access permissions can hide messages, photos, reports, billing, or other areas as configured.
- Custody/restricted-access notes are visible only to director/admin by default.
- Staff should not see sensitive custody notes unless a later feature creates a need-to-know warning system.

## Child Data And Security

Backend must treat child data as highest sensitivity.

Rules:

- No raw child data in logs.
- No medical/custody/incident details in generic notification payloads.
- No child data sent to AI tools or unapproved vendors.
- RLS on every personal-data table.
- Tenant isolation from day one.
- Parent access scoped per guardian permission.
- Staff access scoped by current classroom assignment.
- Director/admin access scoped to the centre.
- Service-role use only in backend-only functions.
- Public endpoints must avoid record enumeration.
- Important actions require audit logs.

## MVP Scope

Backend MVP includes:

- Supabase schema and RLS foundation.
- Auth/session support for all apps.
- Role and permission model.
- Registration/tour/waitlist/enrollment APIs.
- Children, parents, staff, classrooms APIs.
- Staff hours and child attendance APIs.
- Billing, invoices, payments, deposits, receipts, tax receipt APIs.
- Daily reports, photos, messaging, incidents APIs.
- Stripe Connect and webhooks.
- Email and notification event dispatch.
- Health checks and basic monitoring hooks.

## Post-MVP

- Multi-centre organization management.
- Staff scheduling.
- Parent QR/PIN pickup.
- Staff time correction requests.
- Advanced custody warning workflows.
- Staff registration forms.
- Imported legacy registration forms.
- More advanced analytics.
- Traditional backend server if Supabase-first becomes limiting.

## Done Criteria Before Backend App Scaffolding

- This PRD is reviewed.
- Backend feature specs exist for schema, RLS, auth, and API foundation.
- Privacy/security docs are available to backend work.
- Initial API grouping decision is accepted.
- Supabase-first approach is accepted.
- No implementation starts without an approved plan.
