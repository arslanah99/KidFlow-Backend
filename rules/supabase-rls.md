# Supabase And RLS Rules

- All tables containing personal information must have RLS enabled before production use.
- Operational tables need `org_id` or a documented tenant path.
- Parent access is scoped through guardian/family relationships.
- Staff access is scoped through classroom assignments.
- Director/admin access is scoped to organization.
- Service-role use must stay in backend-only code paths.
- Direct mobile/web Supabase access must still be safe under RLS.
- Storage buckets for child photos/documents are private by default.
- Realtime channels must not leak cross-family or cross-organization events.
