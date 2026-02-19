# Agent Instructions for coreydaley.github.io

## Project

Hugo (v0.155.1 extended) personal blog with the **coreydaley-dev theme**, deployed to GitHub Pages via GitHub Actions on every push to `main`. Search is powered by Pagefind, indexed post-build in CI.

## Commands

```bash
hugo server -D                   # dev server with live reload (includes drafts)
hugo --minify                    # build to public/
hugo new posts/my-post-title.md  # new post (draft by default)
```

## ⚠️ Version Control — Never Commit

**Never** run `git add`, `git commit`, or `git push`. Never offer or ask to commit. When work is complete, inform the user so they can review and commit manually.

## Content Conventions

### Blog Post Frontmatter

Always TOML (`+++` delimiters), always double quotes (single quotes cause TOML parse errors). Required fields:

```toml
+++
author = "Claude Code (Claude Sonnet 4.6)"
date = "2026-02-01T22:16:10-05:00"
draft = false
title = "Post Title"
description = "SEO-friendly summary (~75 words)"
summary = "Conversational LinkedIn summary (~150 words, ends with a question or CTA)"
tags = ["lowercase-hyphenated", "specific-keywords"]
categories = ["Title Case", "Broad Topic", "Three Total"]
image = "/images/posts/your-image.png"
+++
```

- **`image`** is optional; used for og:image / twitter:image social previews.
- **`tags`**: lowercase, hyphenated, specific.
- **`categories`**: exactly 3 per post, Title Case, broader than tags. Common values: `AI`, `Web Development`, `Productivity`, `Tools`, `Career`, `Automation`, `Best Practices`, `Getting Started`.
- **Static pages** (`content/pages/`): omit `tags` and `categories` — the sidebar navigation filters them out. No `image` field required.

### Image Workflow (mandatory, in order)

1. **Resize** — run `./scripts/resize-images.sh` (max 512px wide) before referencing any image.
2. **Alt text** — read the image file directly and write ~10-word alt text describing what is *literally depicted*. Do not base alt text on the filename or post title; screen readers depend on accuracy.
3. **Insert** — use the shortcode: `{{< figure-float src="/images/posts/example.png" alt="your alt text" >}}`
4. **Frontmatter** — if `image` is not already set, set it to the first inserted image's path.

### Reader Engagement

End every blog post with a thought-provoking question in italics, directly related to the post content.

### Content Locations

| Type | Path |
|---|---|
| Blog posts | `content/posts/*.md` |
| Static pages | `content/pages/*.md` |
| Search page | `content/search.md` |
| Site config | `hugo.toml` |

## Notion Blog Post Topics Workflow

The [Blog Post Topics](https://www.notion.so/304f4ed7a28f80e6afdbca045866e5c3) page is a to-do list for blog post ideas.

**⚠️ All 4 steps are mandatory** — skipping steps 3–4 causes duplicates and list corruption on future runs.

1. Fetch the page and pick the first unchecked item.
2. Create the blog post.
3. Mark the item complete (`[x]`) in Notion.
4. Move the completed item to the bottom of the list.

## AI Authorship

Set `author` in frontmatter as `"Agent Name (Model Family Version)"`. Do not include the full model ID with a date suffix.

Examples: `"Claude Code (Claude Sonnet 4.6)"`, `"Task Agent (Claude Haiku 4.5)"`, `"ChatGPT (GPT-4o)"`

## File Comment Headers

**Never add comment blocks to Markdown files** — they break Hugo frontmatter parsing.

For all other file types (HTML templates, CSS, JS, TOML, YAML), include a header when creating or modifying a file.

**Creating** — use the language's native comment style:

```
{{/* Created by: Claude Code (Claude Sonnet 4.6) | Date: 2026-02-19T00:00:00-05:00 */}}
```
```css
/* Created By: Claude Code (Claude Sonnet 4.6) | Date: 2026-02-19T00:00:00-05:00 */
```
```toml
# Created by: Claude Code (Claude Sonnet 4.6) | Date: 2026-02-19T00:00:00-05:00
```

Hugo layout files (in `themes/*/layouts/`) must use `{{/* ... */}}`. Standalone HTML, CSS, and JS use their respective native comment syntax.

**Modifying** — preserve the original `Created by` line, append `Last Modified By` and `Last Modified`:

```
{{/* Created by: AI Agent | Date: 2026-02-08T14:30:00-05:00 | Last Modified By: Claude Code (Claude Sonnet 4.6) | Last Modified: 2026-02-19T00:00:00-05:00 */}}
```

Use ISO 8601 with timezone for all dates. If a file has no existing header, add one with both creation and modification fields.

## CI/CD

`.github/workflows/hugo.yml` installs Hugo v0.155.1 extended + Dart Sass + Node.js + Pagefind, builds with `hugo --minify`, runs `npx pagefind --site "public"`, and deploys to GitHub Pages. The Hugo version in CI must match the local version.
