# AI Agent Instructions for Veecle Style Guide

## Repository Context

This repository serves dual purposes:

1. **Style Guide**: A documentation site built with mdBook from the `src/` directory that documents Veecle's code standards for day-to-day reference.

2. **Shared Agent Context Source**: Provides reusable agent guidelines (`.agents/rules/shared/` files) referencing the style guide for other repositories.

### Content Type Guidelines

**Guide Content (`src/**/*.md`)**:
- Follow all style guides: @src/introduction.md, @src/markdown.md, @src/writing.md
- Maintain mdBook structure and cross-references via @src/SUMMARY.md
- Target Veecle's engineering team using diverse operating systems building Rust products

**Shared Agent Contexts (`.agents/rules/shared/*.md`)**:
- Prioritize clarity and cross-repository compatibility over strict guidebook formatting
- Design for reuse across repositories that include this guidebook as a reference
- Should reference guidebook paths (`@src/introduction.md`, etc.) rather than duplicating information
- Enable consuming repositories to inherit guidebook standards through path references

**Repository-Specific Agent Instructions (`AGENTS.md`, `CLAUDE.md`)**:
- Integrate shared guidelines with repository-specific requirements

## Repository-Specific Instructions

### mdBook Integration

- **Build process**: YAML syntax and mdBook build success are verified by CI - focus reviews on content quality
- **Structure changes**: When modifying @src/SUMMARY.md, ensure changes maintain logical organization and navigation flow
- **Cross-references**: Use relative paths for internal links (e.g., `./markdown.md`) to work properly with mdBook's structure

### Content Organization

- **Chapter structure**: Follow the established handbook organization as defined in @src/SUMMARY.md
- **File placement**: New content should fit logically within the existing chapter structure
- **Navigation**: Ensure new pages are properly integrated into the summary for discoverability
