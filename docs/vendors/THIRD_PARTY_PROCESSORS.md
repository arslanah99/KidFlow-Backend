# Third-Party Processors

Status: planning baseline.

No third-party processor may receive child/family/staff data unless it is documented here and approved for the specific purpose.

## Processor Register

| Vendor | Purpose | Data Shared | Region/Data Residency | Status | Notes |
| --- | --- | --- | --- | --- | --- |
| Supabase | Database, auth, storage, realtime, edge functions | Child/family/staff/billing metadata depending on implementation | Canada region preferred/required for production decision | Planned | Confirm project region and DPA before launch. |
| Stripe | Payments, Connect, deposits, autopay, receipts | Parent payer info, payment identifiers, invoice/payment metadata | Verify Canadian account/data terms | Planned | No raw card data touches KidFlow. |
| Resend | Transactional email | Email address, email content, links, limited account context | Verify before launch | Planned | Avoid sensitive child medical/incident details in email. |
| Twilio | SMS reminders if used | Phone number, short message content | Verify before launch | Deferred | Do not send sensitive child data by SMS. |
| Expo | Push notifications | Push token, notification payload | Verify before launch | Planned | Notification payloads must avoid sensitive details. |
| Sentry | Error tracking | Error context, scrubbed metadata | Verify before launch | Planned | Enable PII scrubbing before production. |
| Vercel | Web/site hosting | Request metadata and app execution | Verify before launch | Planned | Personal data should remain in Supabase where possible. |

## AI Vendor Rule

Do not send child records, family records, staff records, photos, messages, medical notes, incident reports, or billing records to AI tools unless a future feature spec, legal review, vendor review, and explicit user approval allow it.
