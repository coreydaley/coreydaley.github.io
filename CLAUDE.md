# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Personal blog/portfolio site for Corey Daley, built with Hugo and the Ananke theme. Deployed to GitHub Pages at coreydaley.com via GitHub Actions on push to `main`.

## Development Commands

```bash
# Local development server with live reload
hugo server -D            # -D includes draft posts

# Build the site (output goes to /public)
hugo --minify

# Create a new post (creates as draft by default)
hugo new posts/my-post-title.md
```

Hugo v0.128.0+ (extended version) is required. The CI uses this exact version.

## Architecture

- **Site config**: `hugo.toml` — minimal config (baseURL, title, language, theme)
- **Theme**: Ananke (v2.11.2), installed as a Git submodule at `themes/ananke/`. Checkout requires `--recurse-submodules`
- **Content**: Markdown files in `content/posts/` with TOML frontmatter (`+++` delimiters)
- **Archetypes**: `archetypes/default.md` — template for new posts (sets `draft = true` by default)
- **Build output**: `public/` — generated static site, committed but also rebuilt in CI

## Content Frontmatter Format

Posts use TOML frontmatter:
```toml
+++
date = '2024-12-04T22:18:12-05:00'
draft = true
title = 'Post Title'
+++
```

Posts with `draft = true` are excluded from production builds. Remove or set to `false` to publish.

## Deployment

Automated via `.github/workflows/hugo.yml`: push to `main` triggers Hugo build and deploy to GitHub Pages. No manual build/deploy steps needed.
