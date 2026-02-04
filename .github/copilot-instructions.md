# Copilot Instructions for coreydaley.github.io

## Project Overview

This is a personal blog/portfolio site built with **Hugo (v0.155.1 extended)** and the **github-style theme**. The site is deployed to GitHub Pages automatically via GitHub Actions on every push to `main`.

## Key Architecture Decisions

- **Static Site Generator**: Hugo was chosen for speed, simplicity, and developer experience (millisecond rebuilds)
- **Theme**: github-style theme (Git submodule at `themes/github-style/`) provides GitHub-inspired UI with clean, minimal design
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
   date = '2026-02-01T22:16:10-05:00'
   draft = false
   title = 'Post Title'
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

## Theme Integration

The github-style theme supports:

- Pin posts with `pin: true` frontmatter
- LaTeX/KaTeX with `katex: math` frontmatter
- Summary display (via `summary` frontmatter or `<!--more-->` separator)
- Custom CSS/JS (configured via `custom_css`/`custom_js` params in hugo.toml)
- User profile with avatar, status emoji, social links, location

## When Modifying Content

- **New posts**: Use `hugo new posts/filename.md` to ensure proper archetype/frontmatter
- **Publishing**: Change `draft = false` in frontmatter
- **Testing locally**: Always use `-D` flag to preview drafts
- **Theme changes**: Theme is a git submodule - modifications require separate commit in submodule
- **Search updates**: Pagefind indexes automatically in CI - no manual steps needed

## When creating content such as blog posts or tutorials
- At the bottom of the new content add "Authored by GitHub Copilot"

## When working on an issue
- Assign the issue to yourself
- Move the issue to "In Progress"
- When a pull request is created move the issue to "In Review"
- When the pull request is merged move the issue to "Done"
