---
sidebar_position: 3
---

# Introduction Documentation Style Guide

This guide defines the style and formatting standards for Plantarium's introduction documentation.

## General Guidelines

### Tone and Voice
- Use a friendly, welcoming tone
- Write in second person ("you") when addressing users
- Keep language simple and clear
- Avoid technical jargon unless necessary
- Be encouraging and supportive

### Structure
- Start with a clear, engaging introduction
- Use consistent heading hierarchy
- Break content into digestible sections
- Include practical examples
- End with clear next steps

### Formatting

#### Headings
```markdown
# Main Title
## Section Title
### Subsection Title
```

#### Lists
- Use bullet points for features and benefits
- Use numbered lists for steps and procedures
- Keep list items parallel in structure
- Limit lists to 5-7 items when possible

#### Code Blocks
```dart
// Use dart syntax highlighting for code
final example = 'Keep code examples simple and relevant';
```

#### Links
- Use descriptive link text
- Include both internal and external links
- Verify all links are working
- Use relative paths for internal links

#### Images
- Use descriptive alt text
- Include captions when helpful
- Optimize image size
- Use consistent image style

## Content Guidelines

### Introduction Section
- Start with a compelling hook
- Explain the purpose clearly
- Highlight key benefits
- Set expectations

### Feature Descriptions
- Focus on user benefits
- Include practical examples
- Show real-world use cases
- Link to detailed documentation

### Code Examples
- Keep examples minimal and focused
- Include comments
- Show error handling
- Demonstrate best practices

### Navigation
- Use consistent navigation patterns
- Include clear next steps
- Link to related content
- Provide context for links

## Visual Elements

### Callouts
```markdown
:::tip
Use tips for helpful suggestions
:::

:::note
Use notes for important information
:::

:::warning
Use warnings for potential issues
:::
```

### Buttons
```markdown
<div style={{textAlign: 'center', marginTop: '2rem'}}>
  <p>Call to action text</p>
  <a href="../path" className="button button--primary button--lg">
    Button Text
  </a>
</div>
```

### Tables
```markdown
| Feature | Description | Example |
|---------|-------------|---------|
| Feature 1 | Description | Example |
| Feature 2 | Description | Example |
```

## Examples

### Good Introduction
```markdown
# Welcome to Plantarium 🌱

Plantarium is your digital garden companion, designed to make gardening accessible and enjoyable for everyone. Whether you're a seasoned gardener or just starting out, Plantarium provides the tools and guidance you need to create and maintain your perfect garden.

## Why Choose Plantarium?

- 🌿 Smart garden planning tools
- 📱 Easy-to-use interface
- 🌦️ Weather-aware gardening
- 📝 Digital garden journal
```

### Good Feature Description
```markdown
### Garden Layout

The Garden Layout feature helps you design your perfect garden space. Simply drag and drop plants onto your virtual garden, and Plantarium will suggest optimal placement based on:

- Sunlight requirements
- Companion planting
- Growth patterns
- Space optimization
```

## Next Steps

1. [Review Introduction Examples](../examples/introduction)
2. [Check Documentation Templates](../templates)
3. [View Style Guide](../style-guide)

---

<div style={{textAlign: 'center', marginTop: '2rem'}}>
  <p>Ready to write introduction documentation?</p>
  <a href="../templates/feature-template" className="button button--primary button--lg">
    Use the Template
  </a>
</div> 