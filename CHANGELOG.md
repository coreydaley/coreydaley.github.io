# Changelog

All notable changes to this project are documented here.

## [Unreleased]

## [2026.03] — 2026-03-07

### Changed
- Migrated all blog posts from flat `content/posts/*.md` files to Hugo leaf bundles at `content/posts/YYYY/MM/slug/index.md`
- Co-located post images and thumbnails inside each bundle directory; removed `static/images/posts/`
- Updated shortcodes (`figure-float`, `figure-block`) and theme partials to resolve images as Hugo page resources
- Updated `scripts/generate-post-image.py` to write images to the post's bundle directory
- Updated `scripts/optimize-images.sh` to scan `content/posts/` bundles in addition to `static/images/posts/`
- Updated `AGENTS.md` content conventions for leaf bundle structure
- Updated `.claude/commands/create-blog-post.md` workflow for leaf bundle structure

### Added
- `aliases` frontmatter on all posts for redirect compatibility with old flat URL structure
- `docs/sprints/` directory with SPRINT-001 planning artifacts and ledger
- Automated hero image generation pipeline (`scripts/generate-post-image.py`)
- `.env.example` with API key template

## [2026.02] — 2026-02-01

### Added
- Initial site launch with Hugo v0.155.1 extended and custom `coreydaley-dev` theme
- Client-side search powered by Pagefind
- GitHub Actions CI/CD deploying to GitHub Pages
- Pre-commit hooks for image size validation
- Prettier + `prettier-plugin-go-template` for template formatting
- Google Analytics integration
- First batch of blog posts on AI-assisted development topics
