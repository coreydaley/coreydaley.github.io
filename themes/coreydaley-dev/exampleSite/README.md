# Coreydaley-Dev Theme - Example Site

This is an example site demonstrating the Coreydaley-Dev Hugo theme.

## Quick Start

### 1. Navigate to the Example Site

```bash
cd themes/coreydaley-dev/exampleSite
```

### 2. Add Images

Place your avatar and cover images in `static/images/`:
- `avatar.jpg` (400x400px recommended)
- `cover.jpg` (1200x400px recommended)

See `static/images/README.md` for details and placeholder options.

### 3. Run Hugo

```bash
hugo server -D
```

Visit `http://localhost:1313` to see the theme in action!

## What's Included

### Configuration

- `hugo.toml` - Complete site configuration with all theme parameters
- Pagination settings
- Social media links
- Google Analytics setup (commented out)

### Content

Example blog posts demonstrating:
- **Welcome Post** - Theme introduction with features
- **Getting Started** - Hugo tutorial with code examples
- **Markdown Guide** - Comprehensive formatting reference
- **Search Page** - Pagefind-powered search functionality

### Structure

```
exampleSite/
├── hugo.toml           # Site configuration
├── content/
│   ├── posts/          # Example blog posts
│   └── search.md       # Search page
├── static/
│   └── images/         # Place your avatar and cover here
└── README.md           # This file
```

## Customization

### Site Settings

Edit `hugo.toml` to customize:

```toml
title = 'Your Name'
baseURL = 'https://yoursite.com/'

[params]
  description = 'Your site description'
  tagline = 'Your tagline'

[params.social]
  github = 'https://github.com/yourusername'
  linkedin = 'https://linkedin.com/in/yourusername'
  # ... more social links
```

### Content

- Add new posts: `hugo new posts/my-post.md`
- Edit existing posts in `content/posts/`
- Use TOML frontmatter with required fields:
  - `author` - Your name
  - `title` - Post title
  - `date` - ISO 8601 timestamp
  - `draft` - true/false
  - `description` - SEO summary (~75 words)
  - `summary` - LinkedIn-style summary (~150 words)
  - `tags` - Array of tags
  - `categories` - Array of categories

## Building for Production

```bash
hugo --minify
```

The built site will be in the `public/` directory.

## License

This theme is licensed under the MIT License. See the [LICENSE](../LICENSE) file for details.

## Support

For issues, questions, or contributions, visit the [theme repository](https://github.com/coreydaley/coreydaley-dev-theme).
