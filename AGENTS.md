# Agent Instructions for coreydaley.github.io

## Project Overview

This is a personal blog/portfolio site built with **Hugo (v0.155.1 extended)** and the **coreydaley-dev theme**. The site is deployed to GitHub Pages automatically via GitHub Actions on every push to `main`.

## Key Architecture Decisions

- **Static Site Generator**: Hugo was chosen for speed, simplicity, and developer experience (millisecond rebuilds)
- **Theme**: coreydaley-dev theme provides a fun, cartoony design
- **Search**: Pagefind is integrated post-build to provide client-side search functionality (indexed after Hugo build in CI)
- **Hosting**: GitHub Pages with automated deployments - no manual build/deploy steps required
- **Content Format**: TOML frontmatter with `+++` delimiters (not YAML), draft posts excluded from production

## Development Workflow

### Local Development

```bash
# Start dev server with live reload (includes drafts)
hugo server -D

# Build site to public/ directory
hugo --minify

# Create new post (always creates as draft by default)
hugo new posts/my-post-title.md
```

### Important Conventions

1. **Content Frontmatter**: Always use TOML format with `+++` delimiters:

   ```toml
   +++
   author = 'AI Agent that authored the content'
   date = '2026-02-01T22:16:10-05:00'
   draft = false
   title = 'Post Title'
   description = 'Brief description for SEO and previews'
   tags = ['tag1', 'tag2', 'tag3']
   +++
   ```

2. **Draft Publishing**: Posts default to `draft = true` (set in `archetypes/default.md`). Remove or set to `false` to publish.

3. **Content Organization**:
   - Blog posts: `content/posts/*.md`
   - Static pages: `content/pages/*.md`
   - Search page: `content/search.md` (special page for Pagefind UI)

4. **Site Configuration**: All site params in `hugo.toml` including author info, social links, avatar, location, search toggle

## CI/CD Pipeline

The `.github/workflows/hugo.yml` workflow:

1. Checks out code (including git submodules for theme)
2. Installs Hugo v0.155.1 extended, Dart Sass, Node.js, and Pagefind
3. Builds site with `hugo --minify`
4. Runs `npx pagefind --source "public"` to index content for search
5. Deploys to GitHub Pages automatically

**Critical**: The Hugo version in CI (0.155.1) must match local development version to avoid build inconsistencies.

## When Modifying Content

- **New posts**: Use `hugo new posts/filename.md` to ensure proper archetype/frontmatter
- **Publishing**: Change `draft = false` in frontmatter
- **Testing locally**: Always use `-D` flag to preview drafts
- **Search updates**: Pagefind indexes automatically in CI - no manual steps needed

## AI Agent Content Authorship

When an AI Agent creates new content such as blog posts or tutorials, it **MUST** set the `author` field in the frontmatter with the following format:

```
author = 'Agent Name (Model Name Version)'
```

**Examples**:

- `author = 'Claude Code (Claude Sonnet 4.5)'`
- `author = 'Claude Code (Claude Opus 4.6)'`
- `author = 'Task Agent (Claude Haiku 4.5)'`
- `author = 'ChatGPT (GPT-4o)'`
- `author = 'ChatGPT (GPT-4 Turbo)'`
- `author = 'GitHub Copilot (GPT-4)'`

**Format Requirements**:

- Include the agent name (e.g., "Claude Code", "ChatGPT", "GitHub Copilot", "Task Agent")
- Include the model family name (e.g., "Claude Sonnet", "GPT-4o", "GPT-4 Turbo")
- Include the major version number where applicable
- Do NOT include the full model ID with dates
- Use parentheses to separate agent name from model info

## AI Agent File Creation and Modification Tracking

### When Creating New Structure Files

When an AI Agent creates new HTML, CSS, JavaScript, TOML, or YAML files, it **MUST** include a comment block at the top of the file with:

- **Created By**: Agent name and model (same format as content authorship)
- **Date**: Current date and time in ISO 8601 format

**IMPORTANT**: Do NOT add comment blocks to Markdown content files as they can interfere with Hugo frontmatter parsing.

**Hugo Template (HTML) Example**:

For Hugo template files (in `themes/*/layouts/`), use Hugo template comment format:

```html
{{/* Created by: AI Agent | Date: 2026-02-08T14:30:00-05:00 */}}
<!DOCTYPE html>
<html>
  ...
</html>
```

**Standalone HTML Example**:

For standalone HTML files (not Hugo templates):

```html
<!--
Created By: Claude Code (Claude Sonnet 4.5)
Date: 2026-02-08T14:30:00-05:00
-->
<!DOCTYPE html>
<html>
  ...
</html>
```

**CSS Example**:

```css
/*
 * Created By: Claude Code (Claude Sonnet 4.5)
 * Date: 2026-02-08T14:30:00-05:00
 */
body {
  ...
}
```

**JavaScript Example**:

```javascript
/**
 * Created By: Claude Code (Claude Sonnet 4.5)
 * Date: 2026-02-08T14:30:00-05:00
 */
function example() {
  ...
}
```

**TOML Example**:

```toml
# Created by: AI Agent
# Date: 2026-02-08T14:30:00-05:00

baseURL = 'https://example.com/'
...
```

**YAML Example**:

```yaml
# Created by: AI Agent
# Date: 2026-02-08T14:30:00-05:00

name: Workflow Name
...
```

### When Modifying Existing Structure Files

When an AI Agent modifies existing HTML, CSS, JavaScript, TOML, or YAML files, it **MUST** update or add a "Last Modified By" entry in the comment block at the top of the file:

**Hugo Template (HTML) Example**:

```html
{{/* Created by: AI Agent | Date: 2026-02-08T14:30:00-05:00 | Last Modified By: ChatGPT (GPT-4o) | Last Modified: 2026-02-10T09:15:00-05:00 */}}
```

**Standalone HTML Example**:

```html
<!--
Created By: Claude Code (Claude Sonnet 4.5)
Date: 2026-02-08T14:30:00-05:00
Last Modified By: ChatGPT (GPT-4o)
Last Modified: 2026-02-10T09:15:00-05:00
-->
```

**CSS/JavaScript Example**:

```css
/*
 * Created By: Claude Code (Claude Sonnet 4.5)
 * Date: 2026-02-08T14:30:00-05:00
 * Last Modified By: GitHub Copilot (GPT-4)
 * Last Modified: 2026-02-10T09:15:00-05:00
 */
```

**TOML/YAML Example**:

```toml
# Created by: AI Agent
# Date: 2026-02-08T14:30:00-05:00
# Last Modified By: GitHub Copilot (GPT-4)
# Last Modified: 2026-02-10T09:15:00-05:00
```

**Important Notes**:

- Always preserve the original "Created By" information
- Update the "Last Modified By" and "Last Modified" fields with current agent and timestamp
- Use ISO 8601 date format with timezone (e.g., `2026-02-08T14:30:00-05:00`)
- If the file doesn't have a comment block, add one with both creation and modification info
- **Do NOT add comment blocks to Markdown content files** - they can break Hugo frontmatter parsing
- For Hugo template files (layouts), always use `{{/* ... */}}` comment format
- For standalone HTML, CSS, and JS files, use standard comment formats
