# Veecle Style Guide

This repository contains the Veecle Style Guide, built with [mdBook](https://rust-lang.github.io/mdBook/).

## Dependencies

The only required tooling is mdBook, commonly available from package managers or see https://rust-lang.github.io/mdBook/guide/installation.html.
A Nix flake is provided.
If you use Nix, run `nix develop` to enter the development shell.

## Common Commands

```bash
# Serve the book locally with live reload.
mdbook serve

# Build the book.
mdbook build

# Clean build artifacts.
mdbook clean
```

## Using Shared AI Agent Guidelines

This repository provides reusable AI agent guidelines that can be referenced across all Veecle projects without duplicating content in each repository.

### Setup for Developers

1. Clone this repository on your development machine (the path given is just an example, it just must be consistent between these steps):
   ```bash
   git clone https://github.com/veecle/style-guide ~/sources/veecle/style-guide
   ```

2. Reference the shared guidelines from your AI agent configuration, e.g. using the `@` syntax for Claude Code:

   ```markdown
   # Development Practices

   Read @~/sources/veecle/style-guide/.agents/rules/shared/AGENTS.md for Veecle development practices.
   ```

### GitHub Actions Templates

For CI/CD integration, copy the workflow templates from this repository to enable AI agents in your GitHub Actions:

1. Copy workflow files to your repository:
   ```bash
   cp ~/sources/veecle/style-guide/.github/workflows/claude-review.yml .github/workflows/
   cp ~/sources/veecle/style-guide/.github/workflows/claude.yml .github/workflows/
   ```

2. Authentication uses [Workload Identity Federation](https://platform.claude.com/docs/en/manage-claude/wif-providers/github-actions):
   the workflows exchange their GitHub Actions OIDC token for a short-lived Anthropic access token, so no API key secret is needed.
   The federation rule and the `ANTHROPIC_FEDERATION_RULE_ID`, `ANTHROPIC_ORGANIZATION_ID` and `ANTHROPIC_SERVICE_ACCOUNT_ID` variables are configured at the organization level, so no per-repository setup is required.
   If your repository still has an `ANTHROPIC_API_KEY` secret from the previous setup, remove it.

The templates automatically:
- Check out the style guide to access shared guidelines
- Inject these guidelines into Claude via system prompts

#### Claude Reviews

These workflows include automated Claude-powered reviews for pull requests.
The Claude review workflow:

- Automatically triggers on opened and ready-for-review pull requests
- Can be requested on any pull request, by including `/claude-review` in a comment, any additional message provided will be included in the prompt, for example:
  ```
  /claude-review with extra focus on the public API consistency
  ```

