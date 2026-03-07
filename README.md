# coreydaley.github.io

Personal blog site built with Hugo and deployed to GitHub Pages.

## Project Overview

This is a static site built with Hugo v0.155.1 using the custom `coreydaley-dev` theme. The site features:

- Blog posts with categories and tags
- Client-side search powered by Pagefind
- Clean, responsive design with a fun cartoony aesthetic
- AI-generated content (clearly disclosed)
- Google Analytics integration
- Automated hero image generation via Claude + DALL-E 3

## Prerequisites

Before working on this project, ensure you have the following installed:

- **Hugo Extended** v0.155.1 ([installation guide](https://gohugo.io/installation/))
- **Node.js** (for Prettier and Pagefind)
- **npm** (comes with Node.js)
- **Python 3** (for image generation scripts)
- **Git** (for version control)
- **pre-commit** ([installation guide](https://pre-commit.com/#install)) — for git hooks

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/coreydaley/coreydaley.github.io.git
cd coreydaley.github.io
```

### 2. Install Node Dependencies

```bash
npm install
```

### 3. Set Up Git Hooks

```bash
# Install pre-commit (choose one)
pip install pre-commit
# or
brew install pre-commit

# Install the git hook scripts
pre-commit install
```

This sets up a pre-commit hook that checks image sizing before every commit.

### 4. Set Up Python Environment

The image generation script requires a virtualenv with a few dependencies:

```bash
python3 -m venv .venv
.venv/bin/pip install anthropic openai requests
```

### 5. Configure API Keys

Copy `.env.example` to `.env` and fill in your API keys:

```bash
cp .env.example .env
```

Then edit `.env`:

```
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-proj-...
```

The `.env` file is gitignored and will never be committed. These keys are used by the automated image generation script.

### 6. Start Development Server

```bash
hugo server -D
```

The site will be available at `http://localhost:1313`. The `-D` flag includes draft posts.

---

## AI-Assisted Blog Post Workflow

This project uses a competitive multi-draft workflow for blog post creation, orchestrated via Claude Code.

### `/create-blog-post <topic>`

Run this command from Claude Code to kick off the full 5-phase workflow:

1. **Orient** — Research the topic; review AGENTS.md and recent posts for voice calibration
2. **Draft** — Claude writes a complete draft to `content/posts/drafts/$SLUG-claude-draft.md`
3. **Compete** — Codex produces an independent draft and critiques Claude's draft
4. **Synthesize** — Both drafts are compared; merge notes written; final post produced at `content/posts/$SLUG.md`
5. **Image** — Hero image automatically generated and inserted (see below)

Draft files are written to `content/posts/drafts/` which is gitignored.

---

## Automated Image Generation

The `scripts/generate-post-image.py` script generates, optimizes, and inserts a hero image for any blog post in one command.

```bash
python3 scripts/generate-post-image.py content/posts/my-post.md
```

The script automatically re-execs itself using `.venv/bin/python3` — no manual activation needed.

### What it does

1. Reads the post and calls the **Claude API** to derive a concrete visual concept
2. Calls **DALL-E 3** (OpenAI API) to generate a 1792×1024 HD image
3. Downloads the PNG to `static/images/posts/`
4. Runs `./scripts/optimize-images.sh` to convert it to WebP
5. Calls **Claude vision** to read the actual WebP and write accurate alt text
6. Inserts the `figure-float` shortcode and `image` frontmatter field into the post

### Requirements

- `.env` file with `ANTHROPIC_API_KEY` and `OPENAI_API_KEY` set
- `.venv/` virtualenv with `anthropic openai requests` installed

---

## Development Workflow

### Creating New Content

#### New Blog Post (manual)

```bash
hugo new posts/my-post-title.md
```

Posts are created as drafts by default. Edit the file to fill in frontmatter and content.

#### Post Frontmatter Structure

Always use TOML (`+++` delimiters) with **double quotes** (single quotes cause TOML parse errors).

```toml
+++
author = "Claude Code (Claude Sonnet 4.6)"
date = "2026-02-08T14:30:00-05:00"
draft = false
title = "Post Title"
description = "SEO-friendly summary (~75 words)"
summary = "Conversational LinkedIn summary (~150 words, ends with a question or CTA)"
tags = ["lowercase-hyphenated", "specific-keywords"]
categories = ["Title Case", "Broad Topic", "Three Total"]
image = "/images/posts/your-image.webp"
+++
```

**Required fields:**

| Field | Notes |
|---|---|
| `author` | Format: `"Agent Name (Model Version)"` |
| `date` | ISO 8601 with timezone offset |
| `draft` | `false` to publish |
| `title` | Post title |
| `description` | ~75 words, SEO-friendly |
| `summary` | ~150 words, conversational, ends with question or CTA |
| `tags` | Lowercase, hyphenated, specific |
| `categories` | Exactly **3**, Title Case |
| `image` | Optional; `.webp` path for og:image / Twitter card |

### Image Workflow

1. **Generate** (automated) — run `python3 scripts/generate-post-image.py content/posts/my-post.md`
2. **Optimize** (manual) — if adding your own image, run `./scripts/optimize-images.sh` before referencing it. Converts PNG/JPG to WebP; originals are preserved locally and stripped by CI.
3. **Alt text** — read the `.webp` directly and write ~10-word alt text describing what is literally depicted
4. **Insert** — use the `.webp` path in the shortcode:
   ```
   {{< figure-float src="/images/posts/example.webp" alt="your alt text" >}}
   ```

### Building the Site

#### Development build (with drafts)

```bash
hugo server -D
```

#### Production build

```bash
hugo --minify
```

The built site will be in `public/`.

### Code Formatting

```bash
# Format Hugo templates
npx prettier --write "themes/coreydaley-dev/layouts/**/*.html"

# Check formatting
npx prettier --check "themes/coreydaley-dev/layouts/**/*.html"
```

---

## Project Structure

```
.
├── .claude/
│   └── commands/
│       └── create-blog-post.md    # /create-blog-post Claude Code command
├── .env                           # API keys (gitignored — copy from .env.example)
├── .env.example                   # API key template
├── .github/
│   └── workflows/
│       └── hugo.yml               # GitHub Actions CI/CD
├── .pre-commit-config.yaml        # Pre-commit hooks configuration
├── .prettierrc                    # Prettier configuration
├── .venv/                         # Python virtualenv (gitignored)
├── AGENTS.md                      # Instructions for AI agents
├── CLAUDE.md                      # Claude-specific instructions
├── Makefile                       # Build automation tasks
├── archetypes/
│   └── default.md                 # Template for new posts
├── content/
│   ├── posts/                     # Blog posts
│   │   └── drafts/                # In-progress drafts (gitignored)
│   └── search.md                  # Search page
├── hugo.toml                      # Hugo configuration
├── package.json                   # npm dependencies
├── public/                        # Built site (gitignored)
├── scripts/
│   ├── generate-post-image.py     # Automated hero image generation
│   ├── optimize-images.sh         # PNG/JPG → WebP conversion
│   └── recompress-images.sh       # Recompress existing WebPs
├── static/
│   └── images/
│       └── posts/                 # Post images (PNG originals + WebP)
└── themes/
    └── coreydaley-dev/            # Custom Hugo theme
        ├── layouts/               # Hugo templates
        └── static/                # CSS, JS, theme images
```

---

## Configuration

### Site Configuration (`hugo.toml`)

Main site settings including base URL, title, author info, social links, Google Analytics, pagination, and taxonomy configuration.

### Prettier (`.prettierrc`)

Configured for Hugo templates via `prettier-plugin-go-template`. Handles Go template syntax, consistent indentation, and line wrapping.

### EditorConfig (`.editorconfig`)

- UTF-8 encoding, LF line endings
- 2-space indentation for HTML, JS, YAML, TOML
- 4-space indentation for CSS
- Trim trailing whitespace

---

## Deployment

The site deploys automatically to GitHub Pages via GitHub Actions on every push to `main`.

### Deployment Workflow

1. Push changes to `main`
2. GitHub Actions triggers (`.github/workflows/hugo.yml`)
3. Workflow installs Hugo v0.155.1 extended, Dart Sass, Node.js, and Pagefind
4. Builds with `hugo --minify`
5. Indexes content with `npx pagefind --site "public"`
6. Deploys to GitHub Pages
7. Site is live at `https://coreydaley.github.io`

---

## AI Agent Guidelines

This project welcomes AI-assisted development. When working as an AI agent:

1. **Read AGENTS.md first** — contains complete conventions for frontmatter, images, categories, voice, and file headers
2. **Set proper author attribution** — format: `"Agent Name (Model Version)"`
3. **Add file comment headers** — include Created/Modified metadata in HTML, CSS, JS, TOML files; never in Markdown
4. **Use double quotes in TOML** — single quotes cause parse errors
5. **Exactly 3 categories per post** — Title Case, broader than tags
6. **Run `hugo --minify` to verify** changes don't break the build

See [AGENTS.md](AGENTS.md) for complete instructions.

---

## Troubleshooting

### Hugo Version Mismatch

```bash
hugo version
# Should report v0.155.1+extended
```

### Image Script Fails

```bash
# Verify venv and dependencies
.venv/bin/python3 -c "import anthropic, openai, requests; print('OK')"

# Verify API keys are set in .env
cat .env
```

### Prettier Not Working

```bash
npm install
npm list prettier-plugin-go-template
```

### Search Not Working Locally

Pagefind indexes are built during CI. To test search locally:

```bash
hugo --minify
npx pagefind --source "public"
hugo server --disableFastRender
```

### Browser Cache Issues

Hard refresh: `Cmd+Shift+R` (Mac) / `Ctrl+Shift+R` (Windows/Linux)

---

## License

### Code License

The code in this repository (themes, templates, scripts, configuration files) is open source under the [MIT License](LICENSE).

### Content License

Blog content (posts, images in `/content/` and `/static/images/`) is licensed under [CC BY-NC-ND 4.0](LICENSE-CONTENT).

[![CC BY-NC-ND 4.0](https://licensebuttons.net/l/by-nc-nd/4.0/88x31.png)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

---

## Acknowledgments

- Built with [Hugo](https://gohugo.io/)
- Search powered by [Pagefind](https://pagefind.app/)
- Hosted on [GitHub Pages](https://pages.github.com/)
- Formatted with [Prettier](https://prettier.io/)
- Git hooks managed by [pre-commit](https://pre-commit.com/)
- AI-assisted development with [Claude Code](https://claude.ai/code)
- Hero images generated with [DALL-E 3](https://openai.com/dall-e-3) via the OpenAI API

---

> **Note**: Content on this site (text and images) may be AI-generated and is clearly disclosed as such.
