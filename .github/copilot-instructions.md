# GitHub Copilot Instructions

## Repository Context
This is Veecle's engineering handbook - a documentation site built with mdBook that documents team practices, workflows, and standards.
Reviews should focus on documentation quality, accuracy of described processes, and maintainability.

## Key Review Areas
*Note: YAML syntax and mdBook build success are verified by CI - focus on content quality*

### Documentation Accuracy
- **Command Examples**: Validate CLI commands are correct for described use cases
- **External Links**: Check links to external resources are current and relevant
- **Tool Recommendations**: Ensure recommended tools/versions are appropriate

### Content Quality
- **Clarity**: Explanations should be clear and actionable for new team members
- **Completeness**: Processes should include necessary context and follow-up steps
- **Consistency**: Use consistent terminology and formatting throughout
- **Examples**: Include concrete examples for complex procedures
- **Cross-references**: Related sections should link to each other appropriately

### Structure & Organization
- **Logical Flow**: Changes to SUMMARY.md maintain sensible organization
- **Heading Hierarchy**: Consistent structure for navigation and accessibility
- **Code Block Context**: Ensure code examples have sufficient surrounding explanation

## Review Priorities

### 🔴 Critical (Must Fix)
- Incorrect command examples that won't work as documented
- Broken external links to key resources

### 🟡 Important (Should Fix)
- Outdated tool recommendations or deprecated practices
- Missing examples for complex workflows
- Inconsistent terminology across sections
- Poor cross-referencing between related topics

### 🟢 Minor (Nice to Have)
- Additional cross-references between sections
- Minor markdown formatting improvements
- Enhanced examples or more detailed explanations

## Team Context
Engineering team using diverse operating systems building Rust-based products.
Documentation should be clear for onboarding and accurate for day-to-day reference.
