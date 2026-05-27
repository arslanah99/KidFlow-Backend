# KidFlow Product Requirements

Status: planning baseline before application scaffolding.

KidFlow is a Canada-first childcare operations platform for daycare owners, directors, staff, and parents. It competes with HiMama/Lillio by combining registration, waitlist, enrollment, attendance, parent communication, daily reports, billing, and staff operations in a product designed for small and mid-size Canadian childcare centres.

This document is the master source of truth. Feature specs, repo rules, design references, and implementation prompts must point back here.

## Product Goals

- Help childcare directors run registration, enrollment, billing, attendance, staff workflows, and parent communication from one system.
- Give parents a mobile-first experience for payments, daily updates, photos, reports, messages, invoices, receipts, and account access.
- Give staff a fast tablet workflow for check-in/out, attendance, activity logging, reports, incidents, photos, and messaging.
- Keep children and family data protected by design. Child data is the highest sensitivity class in this product.
- Ship a practical MVP as a solo developer without creating duplicated backend ownership across repos.

## Product Surfaces And Ownership

KidFlow has three user-facing apps plus one backend/API repo. The apps should stay mentally separate because each has a different audience and workflow. The backend should also stay separate because it owns server-only secrets, Supabase setup, API contracts, and jobs.

```text
kidflow-web       # Product web app for directors/admins/staff/parents
kidflow-mobile    # Expo app for parents, staff, directors, and admins
kidflow-site      # Public marketing website
kidflow-backend   # APIs, Supabase initialization, RLS, secrets, jobs, integrations
```

Each repo must keep a local copy of this product requirements file so the LLM has enough context no matter which repo is open. The synchronized product requirement files are:

- `kidflow-backend/docs/PRODUCT_REQUIREMENTS.md`
- `kidflow-web/docs/PRODUCT_REQUIREMENTS.md`
- `kidflow-mobile/docs/PRODUCT_REQUIREMENTS.md`
- `kidflow-site/docs/PRODUCT_REQUIREMENTS.md`

KidFlow uses one shared Supabase database. No app owns a separate database.

### `kidflow-web`

`kidflow-web` is the main product web app. It is not the marketing website, and it is not the backend/API repo.

It provides permission-based web dashboards:

- Director/admin dashboard.
- Staff/classroom dashboard.
- Parent/guardian web portal.
- Public or embedded registration/tour/application flows when those flows need product security, consent, payment, or database integration.

Director/admin web capabilities include:

- Dashboard and centre overview.
- Children, classrooms, staff, and staff hours.
- Registration, tour bookings, waitlist, and enrollment.
- Billing setup for parents, tuition plans, invoices, receipts, payment tracking, and failed-payment visibility.
- Form builder and public/embedded forms.
- Reports, messages, incidents, settings, imports, legal/privacy/admin tools.
- Permission-based views so directors/admins see centre-level operations, staff see classroom/workflow operations, and parents see only their family data.

Parent web capabilities include:

- Today/status.
- Payment hub.
- Invoice detail.
- Receipts and payment history.
- Daily reports.
- Messages.
- Profile/settings.

Staff web capabilities include:

- Classroom dashboard.
- Roster/status.
- Check-in/check-out support where appropriate.
- Activity/reporting workflows if useful on desktop.

`kidflow-web` must not own:

- Stripe secret logic or webhook authority.
- Supabase service-role logic.
- Marketing-only landing pages, pricing pages, SEO pages, or public sales content.

### `kidflow-mobile`

`kidflow-mobile` is the mobile app for parents, staff, directors, and admins.

It should mirror the role-based product experience from the web app in mobile form:

- Directors/admins get a mobile version of the operational dashboard where it makes sense.
- Staff get fast classroom/tablet workflows.
- Parents get child, billing, communication, and report access.

Mobile capabilities include:

- Parent today/status, reports, photos, messages, invoices, receipts, payment hub, profile.
- Staff roster, check-in/check-out, activity logs, photos, incidents, reports, messages.
- Director/admin mobile views for dashboards, urgent messages, child/classroom/staff visibility, billing status, incidents, and approvals where practical.
- Push notifications and device-specific flows.

`kidflow-mobile` must not own:

- Supabase service-role keys.
- Stripe secret keys.
- Webhook handling.
- Database migrations/RLS authority.
- Canonical billing, enrollment conversion, registration approval, or permission logic.

### `kidflow-site`

`kidflow-site` is the public marketing site for acquiring daycare customers.

It owns:

- Landing pages.
- Pricing and product positioning.
- SEO content.
- Demo requests and sales lead capture.
- Links into tour booking, registration, or product login flows.
- Public trust, privacy, security, and legal pages.

`kidflow-site` must not own:

- Child records.
- Parent accounts.
- Staff accounts.
- Registration submissions.
- Billing authority.
- Product dashboards.
- Operational childcare data.

### `kidflow-backend`

`kidflow-backend` is the backend/API repo behind the apps.

It owns or will own:

- Supabase initialization/configuration.
- Database migrations.
- RLS policies.
- Generated database types.
- Server-only secrets.
- Stripe webhooks, SetupIntents, Checkout/PaymentIntent creation, Connect onboarding, invoice/payment reconciliation.
- Registration submission APIs.
- Enrollment approval/conversion APIs.
- Auth callbacks/session support.
- Health checks.
- Background jobs such as invoice generation, payment retries, reminders, and report aggregation.
- Secure APIs used by web and mobile.

`kidflow-backend` is not a user-facing app. It exists to make the web, mobile, and site apps safer and simpler by keeping server authority in one place.

## User Dashboards

KidFlow is permission-based. The same product may expose different dashboards depending on role.

- Director/admin: centre-wide dashboard, children, classrooms, staff, staff hours, billing, registration, enrollment, reports, incidents, messages, settings, imports, legal/privacy/admin tools.
- Staff/classroom: assigned classrooms, roster, attendance, check-in/out, activity logs, reports, incidents, photos, messages, schedule/hours where applicable.
- Parent/guardian: own children only, today/status, registration status, reports, photos, messages, payments, invoices, receipts, profile/settings.
- Public applicant: tour booking, QR/link registration, application form, deposit/payment if required, confirmation, email next steps.

## MVP Feature Groups

- Registration and waitlist: public application forms, guardian details, child profile, emergency contacts, allergy/medical information, consent, deposit payment, waitlist queue, director review, approval into enrollment, parent account access.
- Tour booking and embeddable intake: Calendly-like public/embedded booking surfaces that can live on a customer's website, QR code, or direct link and feed the daycare's KidFlow pipeline.
- Enrollment: classroom assignment, tuition plan assignment, payer assignment, start/end dates, sibling/subsidy/manual discounts.
- Billing: Stripe Connect onboarding, saved payment methods, autopay, invoice generation, payment attempts, receipts, failed payment recovery, parent billing history.
- Attendance: check-in, check-out, authorized pickup, staff roster views, parent realtime status.
- Daily operations: activity logs, meals, naps, bathroom, mood, notes, daily reports, photo uploads, per-child tagging.
- Messaging: parent/staff threads, director visibility, notifications, support-safe audit trail.
- Incidents: staff incident report, photos, director approval, parent acknowledgement.
- Staff: staff invites, role/classroom assignment, deactivation, least-privilege access.
- Parent app: today view, payments, reports, photos, messages, invoices, receipts, profile.
- Marketing site: public product pages, pricing, contact/demo request, legal links.

## Stack Decisions

- Web app: Next.js App Router, TypeScript, Tailwind.
- Mobile app: Expo, React Native, TypeScript, expo-router.
- Marketing site: likely Next.js, TypeScript, Tailwind.
- Backend/API: separate `kidflow-backend` repo. Must support Supabase migrations/RLS, secure API endpoints, server-only secrets, Stripe webhooks, background jobs, and shared contracts for web/mobile/site.
- Database/auth/storage/realtime: Supabase in Canada Central/Toronto when available for the selected project.
- Payments: Stripe and Stripe Connect. Card details must never touch KidFlow servers directly.
- Email: Resend and React Email.
- SMS: Twilio only when explicitly needed.
- Push: Expo Notifications.
- Hosting: Vercel for web/site, EAS for mobile builds.
- Error tracking: Sentry.

## Child Data Protection Baseline

Child data includes names, DOBs, photos, attendance, allergy and medical notes, incident records, daily reports, custody/pickup information, parent/guardian links, billing relationships, messages, and consent records.

Rules:

- Treat child data as highest sensitivity.
- Default to least privilege for every role, route, API, and database policy.
- No public child data.
- No child data in analytics tools.
- No child data in logs unless explicitly justified and redacted.
- No child data copied into AI prompts, external tools, or vendors unless approved in writing and documented in `docs/vendors/THIRD_PARTY_PROCESSORS.md`.
- Parent/guardian consent is required for collection, use, disclosure, photos, messaging, billing, and registration workflows.
- Sensitive actions must leave an audit trail.
- Data retention and deletion behavior must be designed before launch, not after.
- Professional Canadian privacy/legal review is required before production launch.

Official baseline references to consult while drafting legal/privacy work:

- PIPEDA fair information principles: https://www.priv.gc.ca/en/privacy-topics/privacy-laws-in-canada/the-personal-information-protection-and-electronic-documents-act-pipeda/p_principle/
- Meaningful consent and children: https://www.priv.gc.ca/en/privacy-topics/business-privacy/collecting-personal-information/consent/gl_omc_201805/
- Mandatory breach reporting guidance: https://www.priv.gc.ca/en/privacy-topics/business-privacy/breaches-and-safeguards/privacy-breaches-at-your-business/gd_pb_201810/
- Provincial laws that may apply instead of PIPEDA: https://www.priv.gc.ca/en/privacy-topics/privacy-laws-in-canada/the-personal-information-protection-and-electronic-documents-act-pipeda/r_o_p/prov-pipeda/

This document is not legal advice. Legal review is a launch blocker.

## Coding Workflow

KidFlow uses four planning levels:

1. Master PRD: this file defines product, architecture, privacy, repo ownership, and workflow.
2. App/system bible: each app and `kidflow-backend` must have a bible describing its users, screens or APIs, responsibilities, non-responsibilities, data access, and implementation rules.
3. Feature spec: every feature gets one markdown file in `docs/features/`.
4. Implementation steps: each feature spec contains the concrete sequence for that feature.

Rules:

- No feature coding without a feature spec.
- No app scaffolding without an app/system bible.
- No implementation without an approved plan.
- The LLM must read the PRD, feature spec, relevant rules, privacy/security docs, and design references before implementation.
- The LLM must ask blocking questions, raise concerns, suggest improvements, and create a plan.
- If child-data impact is unclear, implementation stops.
- If payment, consent, legal, security, or production-data behavior is unclear, implementation stops.
- Implementation must end with verification evidence.

## Feature Expectations

Every feature must define:

- User outcome.
- Affected surfaces/repos.
- Data touched.
- Child-data impact.
- Consent impact.
- Permissions/RLS impact.
- Design references or explicit "no design exists yet."
- API/server action impact.
- Database migration impact.
- Error/empty/loading states.
- Tests and acceptance criteria.

## Design Expectations

- Follow the visual direction in the existing KidFlow mocks and screenshots.
- Every feature spec must link to relevant Figma/screenshots/mock files or state no design exists yet.
- Do not redesign while implementing unless the feature plan explicitly calls for it.
- For staff tablet flows, prioritize speed, large touch targets, clear status, and low cognitive load.
- For parent flows, prioritize trust, plain language, payment clarity, and privacy-sensitive presentation.
- For director/admin flows, prioritize dense but readable information, filtering, auditability, and support visibility.

## Master Feature Spec Prompt

Use this prompt whenever a new feature is about to be planned:

```text
Use the KidFlow planning workflow.

Create or update a feature spec in kidflow-web/docs/features/ for:
- Ticket ID:
- Feature name:
- Affected surfaces: kidflow-web, kidflow-mobile, kidflow-site, kidflow-backend
- Relevant designs/screenshots/Figma:
- Source ticket/backlog notes:

Before writing the final spec:
1. Read the local `docs/PRODUCT_REQUIREMENTS.md` in the repo you are working from.
2. Read relevant docs in `kidflow-web/docs/privacy` and `kidflow-web/docs/security` until those docs are moved to a neutral shared location.
3. Read relevant repo rules in each affected repo's rules/ folder.
4. Check kidflow-web/docs/design/README.md for design references.
5. Ask blocking questions if the feature touches child data, consent, payments, RLS, registration, public forms, notifications, or production safety.
6. Surface concerns and recommendations.

The feature spec must include:
- Goal
- Non-goals
- Users
- Affected surfaces/repos
- Design references
- Data touched
- Child-data impact
- Consent/legal impact
- Privacy/security risk
- API/backend impact
- Database/RLS impact
- Implementation steps
- Testing plan
- Acceptance criteria
- Approval status

Do not implement until the plan is approved.
```

## Launch Blockers

- Canadian privacy lawyer review.
- Terms, privacy policy, registration consent, photo consent, payment consent, and breach response review.
- Stripe/PCI implementation review.
- Supabase RLS review.
- Backup/restore test.
- Incident response drill.
- Vendor processor list complete.
- Data retention/deletion policy complete.
