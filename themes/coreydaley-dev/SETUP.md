# Setup Guide for Coreydaley Dev Theme

## Quick Start

To use this theme on your Hugo site, follow these steps:

### 1. Update hugo.toml

Replace or update your `hugo.toml` with the following configuration:

```toml
baseURL = 'https://coreydaley.com/'
languageCode = 'en-us'
title = 'Corey Daley'
theme = 'coreydaley-dev'

[params]
  # Header Images - Add these to your static/images/ directory
  avatar = '/images/avatar.jpg'
  coverImage = '/images/cover.jpg'

  # Site Description
  description = 'A technical blog about software engineering, AI development, and building innovative solutions'
  tagline = 'Software Engineer | AI Enthusiast | Problem Solver'

  # About Section - Appears in the sidebar
  about = 'Passionate about software engineering and AI. I write about development workflows, tools, and the future of coding with AI assistance.'

  # Google Analytics (keep your existing ID)
  googleAnalytics = 'G-YOUR-ID-HERE'

[params.social]
  github = 'https://github.com/coreydaley'
  linkedin = 'https://linkedin.com/in/coreydaley'
  twitter = 'https://twitter.com/coreydaley'
  email = 'hello@coreydaley.com'
```

### 2. Add Your Images

Create placeholder images or add your own:

1. **Avatar Image** (`static/images/avatar.jpg`):
   - Recommended size: 400x400px
   - Square format
   - Will be displayed as a circle

2. **Cover Image** (`static/images/cover.jpg`):
   - Recommended size: 1200x400px or larger
   - Wide/landscape format
   - Gradient overlay will be applied

**Tip**: If you don't have images yet, you can create gradients or use placeholder services:
- Avatar: `https://ui-avatars.com/api/?name=Corey+Daley&size=400&background=6366f1&color=fff&bold=true`
- Cover: A solid color or gradient will work beautifully

### 3. Test Locally

Run Hugo's development server:

```bash
hugo server -D
```

Visit `http://localhost:1313` to see your site with the new theme.

### 4. Customize Colors (Optional)

Edit `themes/coreydaley-dev/static/css/style.css` to change the color scheme:

```css
:root {
    /* Main brand colors */
    --primary: #6366f1;        /* Primary purple-blue */
    --accent-pink: #ec4899;    /* Pink accent */
    --accent-cyan: #06b6d4;    /* Cyan accent */
    --accent-yellow: #fbbf24;  /* Yellow accent */
    --accent-green: #10b981;   /* Green accent */
}
```

### 5. Migration Notes

**From Ananke Theme:**

- Post frontmatter format remains the same (TOML with `+++`)
- All existing posts will work without changes
- The theme reads standard Hugo parameters: `title`, `date`, `draft`, `tags`, `description`

**Content Structure:**

```
content/
  posts/
    my-post.md
    another-post.md
```

Posts should use this frontmatter:

```toml
+++
title = 'My Post Title'
date = 2024-12-04T22:18:12-05:00
draft = false
description = 'Brief description shown in post cards'
tags = ['Hugo', 'AI', 'Development']
+++
```

### 6. Social Links

Update the `[params.social]` section with your actual links. All fields are optional:

- Remove any you don't want to display
- Add your actual URLs
- The icons will automatically appear in the sidebar

### 7. Deploy

When ready, build and deploy:

```bash
hugo --minify
git add .
git commit -m "Update to coreydaley-dev theme"
git push
```

Your GitHub Actions workflow will handle the deployment.

## Troubleshooting

### Images Not Showing

- Ensure images are in `static/images/`
- Check file paths in `hugo.toml` start with `/`
- Verify image files exist and have correct permissions

### Fonts Not Loading

- Check your internet connection (fonts load from Google Fonts)
- Ensure the `<head>` section includes the font links

### Styling Issues

- Clear your browser cache
- Run `hugo server` without cache: `hugo server --noHTTPCache`
- Check browser console for errors

## Need Help?

- Check the theme's `README.md` for full documentation
- Review `exampleSite/hugo.toml` for a complete configuration example
- Open an issue on GitHub if you encounter problems

Enjoy your new playful, eye-catching blog theme!
