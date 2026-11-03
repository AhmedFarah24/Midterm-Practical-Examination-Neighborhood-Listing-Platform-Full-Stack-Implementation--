# Security Audit — Verification Pending

The SQL file documents intended controls, but **no authenticated, anonymous, or service-role execution results have been verified in this session**. Do not label a case PASS without actual evidence.

| Role | Test | Expected outcome | Actual result | Evidence |
| --- | --- | --- | --- | --- |
| Anonymous | Read approved properties | Allowed | Not tested | Pending |
| Anonymous | Read draft properties | No rows returned | Not tested | Pending |
| Anonymous | Read active sponsors | Allowed | Not tested | Pending |
| Anonymous | Read inactive sponsors | No rows returned | Not tested | Pending |
| Owner A | Create own draft | Allowed | Not tested | Pending |
| Owner A | Update own draft | Allowed | Not tested | Pending |
| Owner A | Update Owner B listing | Denied | Not tested | Pending |
| Owner A | Update approved listing | Denied | Not tested | Pending |
| Public inquirer | Insert valid inquiry | Allowed | Not tested | Pending |
| Public inquirer | Read existing inquiries | Denied | Not tested | Pending |
| Owner A | Read inquiries for own listing | Allowed | Not tested | Pending |
| Owner A | Read inquiry for Owner B listing | Denied | Not tested | Pending |
| Admin | Read/write all five tables | Allowed | Not tested | Pending |

## How to verify
1. Apply the versioned migration in a fresh test Supabase project. If this migration was already applied, create a **new follow-up migration** for the adjusted grants and policies; do not assume editing an applied migration changes the database.
2. Create Owner A, Owner B, an administrator, and public/anonymous sessions.
3. Create an approved listing, a draft listing, one active sponsor, one inactive sponsor, and an inquiry using authorized setup operations.
4. Run each case under the corresponding JWT or anonymous API key; SQL Editor's elevated role cannot prove normal-user RLS.
5. Record redacted screenshots or API responses and date, then change each "Not tested" cell to PASS or FAIL based on observed behavior.
6. Check admin elevation, permissions, and UI availability separately. Avoid placing credentials in audit logs.

## Security notes
- The admin-check function is callable by anonymous users but only returns a boolean and cannot elevate anonymous access.
- Sensitive service-role credentials must never be exposed to the browser.
- RLS testing is necessary even if schema creation succeeded.
