# Shared Code Review Guidelines

*Apply these guidelines when reviewing pull requests, providing feedback on code changes, or analyzing content quality.*

## When to Apply Review Guidelines

**Automatically apply when:**
- Request mentions "review", "feedback", "analyze", "check", or similar terms
- Working with pull request content or diff analysis
- Asked to evaluate code or documentation quality or accuracy

**Do NOT apply review guidelines for:**
- General questions about the codebase
- Help with writing new content
- Technical troubleshooting
- Non-review related tasks

## Review Approach

**Context Verification:**
Always begin each review with a brief 3-4 line factual summary of what the PR changes, without praise or assessment.
This verifies correct interpretation of the changes and indicates review completion.
Format as:
```
## Change Summary
[Factual description of changes and their purpose]
```

**Comment Rules:**
- Only comment when there is a specific problem that needs fixing
- Each comment must identify a concrete issue and suggest a solution
- Never use praise language: "Nice", "Good", "Excellent", "Smart", "Great", "Clean", etc.
- Never validate or acknowledge positive changes - only identify problems
- If no specific issues exist after the context verification, provide a brief completion note like "✅ Review complete - no issues found"
- No overall assessments about the PR being "well done" or "good approach"

## Review Areas

Apply relevant areas based on repository content type - code repositories focus on Code Quality, documentation-heavy repositories include Documentation Accuracy and Content Quality.

### Code Quality
- **Style guide compliance**: Verify adherence to the same references used for creating/editing content
- **Naming conventions**: Check for clear, non-abbreviated variable and function names
- **Code spacing**: Ensure logical separation of code blocks
- **Comments**: Verify comments explain reasoning, not redundant information
- **Text files**: Ensure files end with trailing newline, detect this based on whether you see "No newline at end of file" in `git diff` output, you cannot tell whether it is correct just from reading the file

### Documentation Accuracy
- **When documentation includes command examples**: Validate CLI commands by testing them in the appropriate environment (e.g., OS, shell, toolchain version) where feasible, and verify they work as documented for the described use cases.
- **Command compatibility**: Ensure commands are compatible with the current versions of referenced tools.
- **External Links**: Check links in documentation to external resources are current and relevant
- **Tool Recommendations**: Ensure recommended tools/versions are appropriate

### Content Quality
- **Clarity**: Explanations should be clear and actionable for developers unfamiliar with the codebase
- **Completeness**: Processes should include necessary context and follow-up steps
- **Consistency**: Use consistent terminology and formatting throughout
- **Examples**: Include concrete examples for complex procedures
- **Cross-references**: Related documentation sections should link appropriately when interconnected documentation exists

### Structure & Organization
- **Logical Flow**: Changes maintain sensible organization (applies to both code structure and documentation organization)
- **Heading Hierarchy**: Consistent structure for navigation and accessibility
- **Code Block Context**: Ensure code examples have sufficient surrounding explanation

## Review Priorities

### 🔴 Critical (Must Fix)
- Incorrect command examples that won't work as documented
- Broken external links to key resources
- Style guide violations that impact functionality or readability

### 🟡 Important (Should Fix)
- Style guide violations: unclear naming, improper markdown formatting, missing one-sentence-per-line
- Outdated tool recommendations or deprecated practices
- Missing examples for complex workflows
- Inconsistent terminology across sections
- Poor cross-referencing between related topics

### 🟢 Minor (Nice to Have)
- Additional cross-references between sections
- Minor markdown formatting improvements
- Enhanced examples or more detailed explanations
