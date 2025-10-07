# AI Agent Context

When repositories contain context for AI Agents they should follow these guidelines.

`AGENTS.md` (see <https://agents.md>) should be used as a top-level entrypoint to the information an agent should always have loaded.
This should include basic knowledge on what the repository is implementing, useful file structures, and useful workflows.

If it's preferred to split sections into separate files, these should be placed under `.agents/rules`.
Sections can be imported into the top-level `AGENTS.md` using the `@` import syntax supported by many agents.

These context files should be kept up to date as necessary, with updates reviewed like normal documentation updates to ensure consistency.
This by necessity means they should be kept succinct to reduce the review burden.
If there is existing human-targeted documentation that is relevant that should be imported instead of duplicating it.

Users should configure their agents to load this file.
<https://agents.md> documents how to configure this for some agents, others may need hacks like symlinking the file which should not be committed.
As a special case—because Claude Code-based CI workflows require `CLAUDE.md` specifically—we should have a symlink `ln -s AGENTS.md CLAUDE.md` committed into the repo.

Other user-specific agent files, such as Cline's `activeContext.md`, should not be committed in the repo.
They could for example be stored in `.agents/local` with a user's `.gitignore` ignoring this, but that is up to each user on how they want to structure it.
