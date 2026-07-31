# CI

## GitHub Actions

Pin actions to specific commits instead of tags, `actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1` instead of `actions/checkout@v7.0.1`.
Append a comment such as `# v7.0.1` to declare the underlying version.

Malicious actors can move a tag to a malicious commit; doing the same with a commit is not as simple.
