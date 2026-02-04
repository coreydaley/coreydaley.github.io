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

## GitHub Project Management

### Project: "Blog: coreydaley.dev"

All issues and pull requests for this repository are managed through the **"Blog: coreydaley.dev"** GitHub Project.

### Issue Management Workflow

When working on an issue, follow this workflow:

1. **Pick up an issue** - When starting work on an issue:
   - **Assign the issue to yourself** for the duration of work
   - **Move the issue to "In Progress"** status in the project
   - Create a feature branch for your work

2. **Create a pull request** - When ready to submit your work:
   - **Always link the PR to the issue** using one of GitHub's supported methods:
     - In the PR description, use keywords: `Closes #<issue-number>`, `Fixes #<issue-number>`, or `Resolves #<issue-number>`
     - Alternative: Use the "Development" section in the issue sidebar to link the PR
   - Example PR description: `Closes #42 - Add new blog post about Hugo themes`
   - **Add the PR to the "Blog: coreydaley.dev" project** with "In Progress" status

3. **PR Status Options**:
   - **Option 1: Draft PR** - Create the PR as a draft while work is in progress
     - PR shows in the project with "In Progress" status
     - When ready, **mark the PR as "Ready for review"** (convert from draft)
     - **PR status automatically moves to "Review"** in the project
   - **Option 2: Ready PR** - Create the PR as ready for review immediately
     - PR added to the project in "In Progress" status
     - Manually **mark as "Ready for review"** when prepared for code review
     - **PR status automatically moves to "Review"** in the project

4. **Issue Status Management** - When the PR is ready for review:
   - **Manually move the associated issue to "Review"** status
   - This signals that both the code changes and the issue are ready for review

5. **Automatic Issue Closure** - When a PR is merged:
   - The linked issue is automatically closed via GitHub workflow
   - Both the issue and PR move to "Done" status automatically

### Pull Request Best Practices

- **Always link PRs to issues** - Every PR should reference at least one issue
- **Use closing keywords** - Use `Closes #123`, `Fixes #123`, or `Resolves #123` in PR descriptions
- **Add PR to project** - When creating a PR, add it to the "Blog: coreydaley.dev" project with "In Progress" status
- **Draft PRs for work in progress** - Create PRs as drafts if work is still in progress, then mark as "Ready for review" when complete
- **Update project status** - Move items through the project board as work progresses
- **Self-assign issues** - Assign issues to yourself when you start working on them

### Project Status Flow

**Issue Status (manual updates required):**
```
Backlog → In Progress → Review → Done (auto-closed on PR merge)
```

**PR Status (partially automated):**
```
Created → Added to "In Progress" → Mark "Ready for review" → Auto-moves to "Review" → Merged → Auto-moves to "Done"
```

**Key Automation Points:**
- ⚠️ PR must be manually added to project when created (status: "In Progress")
- ✅ PR automatically moves to "Review" when marked "Ready for review"
- ✅ Issue automatically closes when PR merges
- ✅ Both PR and issue automatically move to "Done" on merge
- ⚠️ Issue status must be manually updated to "Review" when PR is ready

## Content Creation Workflow with GitHub Issues

### Issue-Based Content Management

Blog posts and tutorials are managed through GitHub Issues with the following workflow:

1. **Create an Issue** - Create a GitHub issue with the "blog post" or "tutorial" label
   - Title should describe the content topic
   - Description should outline key points to cover
   - Issue is automatically added to the "Blog: coreydaley.dev" project

2. **Issue Assignment** - When starting work:
   - **Assign the issue to yourself** (or GitHub Copilot)
   - **Move issue to "In Progress"** status in the project

3. **Content Creation** - Create the blog post file:
   ```bash
   # If Hugo is available locally
   hugo new posts/descriptive-filename.md
   
   # Otherwise, manually create with proper TOML frontmatter
   # File: content/posts/descriptive-filename.md
   +++
   date = '2026-02-04T16:25:00-05:00'
   draft = true
   title = 'Your Post Title'
   description = 'Brief description for SEO and previews'
   tags = ['tag1', 'tag2', 'tag3']
   +++
   ```

4. **Create Pull Request** - When content is ready:
   - Create a PR with the content changes
   - **Link the PR to the issue**: `Closes #<issue-number>`
   - PR is automatically added to the project in "In Progress" status

5. **Ready for Review** - When PR is complete:
   - If PR was created as a draft, **mark it as "Ready for review"** (convert from draft)
   - **Move the PR to "Review"** status in the project
   - **Move the issue to "Review"** status in the project
   - This signals that both are ready for review

6. **Publishing** - After review and merge:
   - Merge PR to `main` branch
   - Issue is automatically closed by workflow
   - Both PR and issue move to "Done" status

### Benefits of Issue-Based Workflow

- **Tracking**: All content ideas are tracked in one place
- **Project Visibility**: Progress is visible through the project board
- **Transparency**: Status updates show work in progress
- **Automation**: Issues auto-close when PRs merge via workflow
- **Linking**: PRs are always linked to issues for context
- **History**: Git commits link back to originating issues

## When Modifying Content

- **New posts**: Use `hugo new posts/filename.md` to ensure proper archetype/frontmatter
- **Publishing**: Change `draft = false` in frontmatter
- **Testing locally**: Always use `-D` flag to preview drafts
- **Theme changes**: Theme is a git submodule - modifications require separate commit in submodule
- **Search updates**: Pagefind indexes automatically in CI - no manual steps needed

## When creating content such as blog posts or tutorials
- At the bottom of the new content add "Authored by GitHub Copilot"
