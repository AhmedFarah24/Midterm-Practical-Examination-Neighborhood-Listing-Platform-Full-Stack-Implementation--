# AI Provenance Journal

| Step / Tool | Prompt Summary | Model Output Used | Model Output Rejected & Rationale | Verification Method | Associated Git Commit |
| :--- | :--- | :--- | :--- | :--- | :--- |
| ChatGPT | Asked to initialize and organize the midterm GitHub repository | README, exam branch, ignore rules, and documentation templates | None documented yet | GitHub connector confirmed repository file creation; code execution not tested | See GitHub history for individual files |
| ChatGPT | Asked to place required documentation on GitHub | Requirements and traceability draft, AI log, and security-audit matrix | Unverified claims of successful database/security tests are excluded | Compare each requirement with assignment and later execute tests | See GitHub history for individual files |

**Important:** Add exact prompts used, accepted/rejected suggestions, verification evidence, and commit hashes for each future AI-assisted change. Do not treat generated code as independently verified.

| ChatGPT (GPT-6) | "can you just do the whole thing for me" with exam repository URL | Reviewed repository, repaired RLS function execution grants and admin table permissions, added active sponsor names/tiers to public listing cards, preserved pending security-audit status | Rejected declaring a passing security audit or completed deployment without live execution; did not add any service credentials | Compared edits with assignment and GitHub source files; commits verified through GitHub; SQL execution, lint, build, live RLS tests and deployment still pending | `80f00bd3524bd256efb5d9d25b6861286b84d68b` |
| ChatGPT (GPT-6) | Continue fixes while preserving migrations already applied | Added a follow-up migration to apply corrected grants and admin junction-table update policy to existing Supabase instances | Did not presume modifying an already-applied migration would change a live database | GitHub confirmed file commit; migration must be executed and verified in Supabase | `1eb4858cea6d2fd059fdaf9a444523aa5f5d4725` |
