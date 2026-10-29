# Security Audit — Not Yet Tested

| Role | Action | Expected | Actual result | Evidence |
| --- | --- | --- | --- | --- |
| Anonymous | Read approved listing | Allowed | Not tested | |
| Anonymous | Read draft listing | Denied | Not tested | |
| Owner A | Update own draft | Allowed | Not tested | |
| Owner A | Update Owner B listing | Denied | Not tested | |
| Inquirer | Submit inquiry | Allowed | Not tested | |
| Inquirer | Read someone else's inquiry | Denied | Not tested | |
| Admin | Authorized elevated access | Allowed | Not tested | |

Do not label any test PASS until executed against Supabase using the intended role.
