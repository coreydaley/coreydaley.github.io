# coreydaley.github.io

Personal blog and portfolio site built with Hugo and deployed to GitHub Pages.

## Project Overview

This is a static site built with Hugo v0.155.1 using the custom `coreydaley-dev` theme. The site features:

- 📝 Blog posts with categories and tags
- 🔍 Client-side search powered by Pagefind
- 🎨 Clean, responsive design with a fun cartoony aesthetic
- 🤖 AI-generated content (clearly disclosed)
- 📊 Google Analytics integration

## Prerequisites

Before working on this project, ensure you have the following installed:

- **Hugo Extended** v0.155.1 ([installation guide](https://gohugo.io/installation/))
- **Node.js** (for Prettier and Pagefind)
- **npm** (comes with Node.js)
- **Git** (for version control)

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/coreydaley/coreydaley.github.io.git
cd coreydaley.github.io
```

### 2. Install Dependencies

```bash
npm install
```

### 3. Start Development Server

```bash
hugo server -D
```

The site will be available at `http://localhost:1313`. The `-D` flag includes draft posts.

## Development Workflow

### Creating New Content

#### New Blog Post

```bash
hugo new posts/my-post-title.md
```

This creates a new post using the archetype template with proper frontmatter. Posts are created as drafts by default.

#### Post Frontmatter Structure

```toml
+++
author = 'AI Agent Name (Model Version)'
title = 'Post Title'
date = '2026-02-08T14:30:00-05:00'
draft = true
description = 'Brief description for SEO and previews'
tags = ['tag1', 'tag2', 'tag3']
categories = ['Category 1', 'Category 2']
+++
```

**Required Fields:**
- `author`: Attribution for AI or human author
- `title`: Post title
- `date`: ISO 8601 timestamp with timezone
- `draft`: Boolean (set to `false` to publish)
- `description`: SEO-friendly summary
- `tags`: Specific keywords (lowercase, hyphenated)
- `categories`: Broad topic groupings (Title Case, 1-3 per post)

### Building the Site

#### Development Build (with drafts)

```bash
hugo server -D
```

#### Production Build

```bash
hugo --minify
```

The built site will be in the `public/` directory.

### Code Formatting

#### Format All HTML Templates

```bash
npx prettier --write "themes/coreydaley-dev/layouts/**/*.html"
```

#### Check Formatting

```bash
npx prettier --check "themes/coreydaley-dev/layouts/**/*.html"
```

#### Format Other File Types

```bash
# JavaScript
npx prettier --write "themes/coreydaley-dev/static/js/**/*.js"

# CSS
npx prettier --write "themes/coreydaley-dev/static/css/**/*.css"

# Markdown
npx prettier --write "content/**/*.md"
```

### Testing

#### Test Build Locally

```bash
hugo --minify && echo "Build successful!"
```

#### Preview Production Build

```bash
hugo --minify
cd public
python3 -m http.server 8000
```

Visit `http://localhost:8000` to preview the production build.

## Project Structure

```
.
├── .editorconfig              # Editor configuration
├── .github/
│   └── workflows/
│       └── hugo.yml           # GitHub Actions CI/CD
├── .prettierrc                # Prettier configuration
├── AGENTS.md                  # Instructions for AI agents
├── CLAUDE.md                  # Claude-specific instructions
├── README.md                  # This file
├── archetypes/
│   └── default.md             # Template for new posts
├── content/
│   ├── posts/                 # Blog posts
│   ├── search.md              # Search page
│   └── about.md               # About page
├── hugo.toml                  # Hugo configuration
├── package.json               # npm dependencies
├── public/                    # Built site (gitignored)
└── themes/
    └── coreydaley-dev/        # Custom theme
        ├── layouts/           # Hugo templates
        ├── static/            # CSS, JS, images
        └── archetypes/        # Theme archetypes
```

## Configuration

### Site Configuration (`hugo.toml`)

Main site settings including:
- Base URL and site title
- Author information
- Social media links
- Google Analytics tracking
- Pagination settings
- Taxonomy configuration

### Prettier Configuration (`.prettierrc`)

Prettier is configured to format Hugo templates using the `prettier-plugin-go-template` plugin. Configuration includes:
- HTML template formatting with Go template syntax support
- Consistent indentation and line wrapping
- Automatic formatting on save (if editor supports it)

### Editor Configuration (`.editorconfig`)

EditorConfig maintains consistent coding styles:
- UTF-8 encoding
- LF line endings
- 2-space indentation for HTML, JS, YAML, TOML
- 4-space indentation for CSS
- Trim trailing whitespace

## Deployment

The site is automatically deployed to GitHub Pages via GitHub Actions when changes are pushed to the `main` branch.

### Deployment Workflow

1. Push changes to `main` branch
2. GitHub Actions workflow triggers (`.github/workflows/hugo.yml`)
3. Workflow:
   - Checks out code with submodules
   - Installs Hugo v0.155.1, Dart Sass, Node.js, and Pagefind
   - Builds site with `hugo --minify`
   - Indexes content with Pagefind for search
   - Deploys to GitHub Pages
4. Site is live at `https://coreydaley.github.io`

### Manual Deployment

If you need to deploy manually:

```bash
# Build the site
hugo --minify

# Index for search
npx pagefind --source "public"

# Push to gh-pages branch (if configured)
# Or commit public/ directory (if using different setup)
```

## AI Agent Guidelines

This project welcomes AI-assisted development. When working as an AI agent:

1. **Read AGENTS.md first** - Contains detailed instructions for AI agents
2. **Set proper author attribution** - Use format: `'Agent Name (Model Version)'`
3. **Add file headers** - Include creation/modification metadata in HTML, CSS, JS files
4. **Follow conventions** - TOML frontmatter, proper categories, tag cloud sizing
5. **Test builds** - Always run `hugo --quiet` to verify changes don't break the build

See [AGENTS.md](AGENTS.md) for complete AI agent instructions.

## Contributing

### Before Making Changes

1. Read through [AGENTS.md](AGENTS.md) for project conventions
2. Ensure Hugo v0.155.1 extended is installed
3. Run `npm install` to install formatting tools
4. Start dev server: `hugo server -D`

### Making Changes

1. Create a new branch for your changes
2. Make your modifications
3. Format code: `npx prettier --write "**/*.html"`
4. Test build: `hugo --minify`
5. Commit with descriptive messages
6. Push and create a pull request

### Code Style

- Follow the EditorConfig settings
- Run Prettier before committing
- Use semantic HTML
- Keep CSS organized by section
- Comment complex logic

## Troubleshooting

### Hugo Version Mismatch

If builds fail, ensure you're using Hugo v0.155.1 extended:

```bash
hugo version
```

### Prettier Not Working

If Prettier can't find the Go template parser:

```bash
# Reinstall dependencies
npm install

# Verify plugin is installed
npm list prettier-plugin-go-template
```

### Search Not Working

Pagefind indexes are built during CI/CD. To test search locally:

```bash
hugo --minify
npx pagefind --source "public"
hugo server --disableFastRender
```

### Browser Cache Issues

If CSS/JS changes don't appear:
- Hard refresh: `Cmd+Shift+R` (Mac) or `Ctrl+Shift+R` (Windows/Linux)
- Clear browser cache
- Restart Hugo dev server

## License

This project is open source and available under the MIT License.

## Acknowledgments

- Built with [Hugo](https://gohugo.io/)
- Search powered by [Pagefind](https://pagefind.app/)
- Hosted on [GitHub Pages](https://pages.github.com/)
- Formatted with [Prettier](https://prettier.io/)
- AI-assisted development with Claude Code

---

⚠️ **Note**: Content on this site (both text and images) may be generated by AI. Use at your own peril.
