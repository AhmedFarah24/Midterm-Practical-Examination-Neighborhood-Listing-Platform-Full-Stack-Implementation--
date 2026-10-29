# Security Audit — Results Pending

All expectations below require actual tests against the configured Supabase database using separate authenticated and anonymous roles. **No tests are claimed to have passed.**

| Role | Test | Expected outcome | Actual result | Evidence |
| --- | --- | --- | --- | --- |
| Anonymous | Read approved properties | Allowed | Not tested | Pending |
| Anonymous | Read draft properties | Denied | Not tested | Pending |
| Anonymous | Read active sponsors | Allowed | Not tested | Pending |
| Owner A | Create draft for own account | Allowed | Not tested | Pending |
| Owner A | Update own draft | Allowed | Not tested | Pending |
| Owner A | Update Owner B property | Denied | Not tested | Pending |
| Owner A | Update approved property | Denied | Not tested | Pending |
| Public inquirer | Submit valid inquiry | Allowed | Not tested | Pending |
| Public inquirer | Read existing inquiries | Denied | Not tested | Pending |
| Owner A | Read inquiry for own listing | Allowed | Not tested | Pending |
| Owner A | Read inquiry for Owner B | Denied | Not tested | Pending |
| Admin | Authorized elevated access across tables | Allowed | Not tested | Pending |

## Testing protocol
1. Create isolated test accounts for two distinct owners and an administrator.
2. Prepare an approved and a draft listing, linked sponsors, and test inquiries.
3. Execute each action using the intended user's session/JWT or anonymous role, never the SQL Editor's elevated role to simulate an ordinary user.
4. Record HTTP response, database results, role used, and redacted screenshots or logs.
5. Mark PASS only if observed behavior matches expectation; otherwise mark FAIL, correct the policy, and retest.

## Risk notes
A successful SQL migration does not demonstrate RLS correctness. Admin service-role authorization must remain server-side; public access must not receive service-role credentials.
