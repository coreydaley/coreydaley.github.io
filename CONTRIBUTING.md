# Contributing

Thanks for your interest in contributing. This is a personal blog, so contributions are most welcome in the form of bug reports, theme improvements, and script enhancements. Blog content (posts, images) is not open for external contributions.

## What You Can Contribute

- Bug fixes in the Hugo theme (`themes/coreydaley-dev/`)
- Improvements to shortcodes (`layouts/shortcodes/`)
- Script improvements (`scripts/`)
- GitHub Actions workflow improvements
- Documentation fixes

## Local Setup

### Prerequisites

- **Hugo Extended** v0.155.1 — [installation guide](https://gohugo.io/installation/)
- **Node.js** + **npm**
- **Python 3**
- **pre-commit** — [installation guide](https://pre-commit.com/#install)

### Setup Steps

```bash
# 1. Fork and clone
git clone https://github.com/YOUR_USERNAME/coreydaley.github.io.git
cd coreydaley.github.io

# 2. Install Node dependencies
npm install

# 3. Install pre-commit hooks
pre-commit install

# 4. (Optional) Set up Python venv for image scripts
python3 -m venv .venv
.venv/bin/pip install anthropic openai requests

# 5. Start dev server
hugo server -D
```

The site runs at `http://localhost:1313`. The `-D` flag includes draft posts.

## Making Changes

### Branching

Create a branch from `main` with a descriptive name:

```bash
git checkout -b fix/shortcode-image-resolution
git checkout -b feat/rss-improvements
```

### Commit Style

This project uses [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <short summary>
```

Types: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`, `style`, `ci`

Examples:
- `fix(shortcodes): resolve image path for leaf bundle resources`
- `feat(theme): add dark mode toggle`
- `docs(readme): fix outdated hugo new command`

Always include a `Co-authored-by` trailer if AI-assisted:

```
Co-authored-by: Claude Sonnet 4.6 <noreply@anthropic.com>
```

### File Comment Headers

When **creating** a file, add a header in the language's native comment style:

```gotemplate
{{/* Created by: Your Name | Date: 2026-03-07T00:00:00-05:00 */}}
```

When **modifying** an existing file, preserve the `Created by` line and append:

```gotemplate
{{/* Created by: Original Author | Date: ... | Last Modified By: Your Name | Last Modified: 2026-03-07T00:00:00-05:00 */}}
```

Hugo layout files use `{{/* ... */}}`. CSS/JS use `/* ... */`. TOML/YAML use `# ...`. Never add comment blocks to Markdown files.

### Hugo Templates

- Test changes with `hugo --minify` — the build must pass cleanly
- Use Hugo page resources (bundle-relative) for image resolution, not absolute static paths
- Keep templates readable; avoid deeply nested conditionals

### Scripts

- Scripts must work when invoked from the repo root
- `generate-post-image.py` self-re-execs with `.venv/bin/python3` — preserve this pattern
- Do not hardcode absolute paths

### Images

Posts are Hugo leaf bundles. Images live alongside `index.md` in the bundle directory:

```
content/posts/YYYY/MM/slug/
├── index.md
├── hero.webp
└── thumbs/
    └── hero.webp
```

Run `./scripts/optimize-images.sh` after adding any PNG/JPG. Do not place post images in `static/images/posts/`.

## Pull Requests

1. Push your branch and open a PR against `main`
2. Fill in the PR template
3. Ensure `hugo --minify` passes and the pre-commit hook passes
4. A maintainer will review within a few days

## Code of Conduct

By participating you agree to the [Code of Conduct](CODE_OF_CONDUCT.md).
