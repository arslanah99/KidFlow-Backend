# Stripe Rules

- Raw card details never touch KidFlow servers.
- Use Stripe-hosted or tokenized flows: Checkout, Elements, SetupIntent, PaymentSheet, or equivalent.
- Verify webhook signatures.
- Make webhook handlers idempotent.
- Store Stripe IDs, status, amounts, currency, timestamps, and reconciliation state.
- Do not mark deposits, invoices, or payments as paid until Stripe confirmation is processed.
- Keep Connect account ownership, app fees, refunds, and failure states explicit.
- Web and mobile call backend endpoints for privileged payment actions.
