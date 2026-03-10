# Agent Instructions for coreydaley.github.io

## Project

Hugo (v0.155.1 extended) personal blog with the **coreydaley-dev theme**, deployed to GitHub Pages via GitHub Actions on every push to `main`. Search is powered by Pagefind, indexed post-build in CI.

## Commands

```bash
hugo server -D                                        # dev server with live reload (includes drafts)
hugo --minify                                         # build to public/
hugo new posts/2026/03/my-post-title/index.md         # new post as leaf bundle (draft by default)
```

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
image = "your-image.webp"
aliases = ["/posts/your-post-slug/"]
+++
```

- **`image`** is optional; used for og:image / twitter:image social previews. Use a **filename only** (e.g., `"hero.webp"`) — the image must be in the same directory as `index.md`. Do not use absolute `/images/posts/...` paths.
- **`aliases`** — add an `aliases` array if the post was previously published at a different URL (or if it's the first publish and you want to ensure the old flat URL redirects). Always include `["/posts/your-slug/"]` for new posts to handle any pre-existing links.
- **`tags`**: lowercase, hyphenated, specific.
- **`categories`**: exactly 3 per post, Title Case, broader than tags. Common values: `AI`, `Web Development`, `Productivity`, `Tools`, `Career`, `Automation`, `Best Practices`, `Getting Started`.
- **Static pages** (`content/pages/`): omit `tags` and `categories` — the sidebar navigation filters them out. No `image` field required.

### Image Workflow (mandatory, in order)

Posts are **leaf bundles**: each post lives at `content/posts/YYYY/MM/slug/index.md` and its images live in the same directory.

1. **Place** — put the PNG/JPG source image in the post's bundle directory (same folder as `index.md`).
2. **Optimize** — run `./scripts/optimize-images.sh` from the repo root. It converts PNG/JPG to WebP and creates a `thumbs/` subfolder inside the bundle for list thumbnails. Originals are preserved on disk and stripped from the deployed site by CI.
3. **Alt text** — read the `.webp` file directly and write ~10-word alt text describing what is _literally depicted_. Do not base alt text on the filename or post title; screen readers depend on accuracy.
4. **Insert** — use the filename only (no path) in the shortcode: `{{< figure-float src="example.webp" alt="your alt text" >}}`
5. **Frontmatter** — if `image` is not already set, set it to the filename only of the first inserted image: `image = "example.webp"`

### Reader Engagement

End every blog post with a thought-provoking question in italics, directly related to the post content.

### Content Locations

| Type         | Path                                           |
| ------------ | ---------------------------------------------- |
| Blog posts   | `content/posts/YYYY/MM/slug/index.md`          |
| Post images  | `content/posts/YYYY/MM/slug/image.webp`        |
| Post thumbs  | `content/posts/YYYY/MM/slug/thumbs/image.webp` |
| Static pages | `content/pages/*.md`                           |
| Search page  | `content/search.md`                            |
| Site config  | `hugo.toml`                                    |

Blog posts are Hugo **leaf bundles**: all files related to a post (images, thumbnails) live alongside `index.md` in the post's directory. Do not place post images in `static/images/posts/`.

## AI Authorship

Set `author` in frontmatter as `"Agent Name (Model Family Version)"`. Do not include the full model ID with a date suffix.

Examples: `"Claude Code (Claude Sonnet 4.6)"`, `"Task Agent (Claude Haiku 4.5)"`, `"ChatGPT (GPT-4o)"`

## CI/CD

`.github/workflows/hugo.yml` installs Hugo v0.155.1 extended + Dart Sass + Node.js + Pagefind, builds with `hugo --minify`, runs `npx pagefind --site "public"`, and deploys to GitHub Pages. The Hugo version in CI must match the local version.
