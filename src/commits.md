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
