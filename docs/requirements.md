# Requirements & Traceability — Midterm Practical

## Story 1 — Property Owner
**User story:** As a registered property owner, I want to submit listing drafts so prospective buyers can review them after administrative approval.

**Size:** Medium

**Given** the user is authenticated and has the property_owner role  
**When** they POST a valid listing payload  
**Then** the system saves a listing linked to their auth.uid() with status draft.

**Negative case:** Unauthorized users must not submit a property, and an owner must not edit another owner's listing or modify a live listing.

**Migration:** `supabase/migrations/20261029140000_exam_schema_persistence.sql`  
**Route:** `src/app/api/properties/route.ts`

## Story 2 — Public Inquirer
**User story:** As a prospective resident, I want to browse approved properties with active tier-level sponsors and send an inquiry without seeing anyone else's inquiries.

**Size:** Large

**Given** an anonymous visitor  
**When** they request available listings  
**Then** only approved properties and active sponsors appear.

**Given** the visitor submits an inquiry with valid email and message  
**When** the system accepts the request  
**Then** the inquiry is saved without exposing previous inquiries to visitors.

**Migration:** `supabase/migrations/20261029140000_exam_schema_persistence.sql`  
**Routes:** `src/app/api/properties/route.ts`, `src/app/api/inquiries/route.ts`

## Story 3 — Platform Administrator
**User story:** As a platform administrator, I want authorized administrative access to records so I can audit compliance and moderate property listings.

**Size:** Large

**Given** an authenticated, verified platform administrator  
**When** they perform an authorized compliance or moderation action  
**Then** the backend permits the action using verified elevated authorization.

**Negative case:** An ordinary property owner or public user cannot gain administrative privileges by changing request data or profile metadata.

**Migration:** `supabase/migrations/20261029140000_exam_schema_persistence.sql`  
**Route:** Dedicated authenticated admin route to be implemented and tested; privileged service access must never be exposed to browsers.

## Verification status
Acceptance criteria are specifications, not passing test results. Confirm actual application, database, and RLS behavior before declaring completion.
