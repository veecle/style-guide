# Git

## `.gitignore`

Repository `.gitignore` files should contain only entries directly related to that repository's content, such as `target/` for Rust projects or `book/` for mdBook projects.
User-specific entries like IDE configuration or system files like `.DS_Store` should be added to the user's global `.gitignore` (see [`man gitignore`][] for more details; this file is typically located at `~/.config/git/ignore`).

[`man gitignore`]: https://git-scm.com/docs/gitignore

## Creating commits

Changes to code require:

* Traceability to change requests
* Clear marking of breaking changes

Commit messages must follow the [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) specification.

Commit messages that close a Linear or Github issue should include a `Closes:` footer with the issue identifier.
If the commit is related to the issue but does not close it, then use a `Refs:` footer instead.

For example:

```
feat: add foobar

Also changed baz.

Closes: DEV-123
```
