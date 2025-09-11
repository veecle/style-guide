# Markdown

When writing Markdown files, use the ["one sentence per line" style][one-sentence].
Besides the advantages listed in the linked documentation, one sentence per line frequently makes diffs easier to read.

[one-sentence]: https://asciidoctor.org/docs/asciidoc-recommended-practices/#one-sentence-per-line

The drawback is that URLs in links can make some lines disproportionately long.
GitHub-flavored Markdown supports [link labels].
You can use link labels to help readability.
The preceding "link labels" link is a link label, check the Markdown source of this document to see how it works.

[link labels]: https://github.github.com/gfm/#link-label

### Code blocks and spans

Code blocks (triple backtick) and spans (single backtick) mark up content that readers interpret "literally", such as:

* Reproduction of terminal input and output
* Reproduction of code
* References to code identifiers

In general, literal content (or parts of it) must be reproduced character by character because some system processing the content will fail if syntax is not accurate.

Do not use code blocks and spans for other purposes, such as highlighting or quoting.
You can use emphasis (or admonitions, when they are available) for highlighting, or block quotes for quoting.

Typically, code blocks and spans are subject to special treatment because of their literal content, such as:

* Disabling spell checkers
* Different formatting, such as disabling word wrapping

This special treatment is often undesirable for non-literal content.

#### Console sessions

When documenting console usage, consider using syntax highlighting to help users identify what must be typed on the console and what is program output.

You can specify the `console` language identifier and use `$` to represent the prompt.
GitHub shows terminal input and output with different styles:

```console
$ uptime
 12:58:45 up  3:08,  1 user,  load average: 0.76, 0.90, 0.82
```

You can use `#` prompts for commands that require superuser privileges.

For example:

```console
# apt update
Hit:1 http://archive.ubuntu.com/ubuntu focal InRelease
Reading package lists... Done
```
