<!--
Created by: AI Agent
Date: 2026-02-06T22:56:44-05:00
-->

# Coreydaley Dev Theme

A playful, eye-catching Hugo theme for technical blogs about software engineering and AI development. Features a cartoony design with vibrant colors, smooth animations, and a LinkedIn-inspired layout.

## Features

- **Distinctive Design**: Playful futurism aesthetic with cartoon-style elements
- **LinkedIn-Inspired Layout**: Round avatar overlaid on cover image with fixed sidebar navigation
- **Fully Responsive**: Beautiful on all devices from mobile to desktop
- **Social Integration**: Easy configuration for GitHub, LinkedIn, Twitter, and email
- **Rich Animations**: Smooth transitions, hover effects, and micro-interactions
- **Code-Friendly**: Syntax highlighting ready with Fira Code font
- **SEO Ready**: Semantic HTML and meta tag support

## Installation

1. Navigate to your Hugo site's directory:
```bash
cd your-hugo-site
```

2. Add the theme as a Git submodule or copy it directly:
```bash
# Using Git submodule
git submodule add https://github.com/yourusername/coreydaley-dev-theme.git themes/coreydaley-dev

# Or copy the theme directory
cp -r /path/to/coreydaley-dev themes/
```

3. Update your `hugo.toml`:
```toml
theme = 'coreydaley-dev'
```

## Configuration

### Required Parameters

Add these to your `hugo.toml`:

```toml
baseURL = 'https://yoursite.com/'
languageCode = 'en-us'
title = 'Your Name'
theme = 'coreydaley-dev'

[params]
  # Header Images
  avatar = '/images/avatar.jpg'
  coverImage = '/images/cover.jpg'

  # Site Description
  description = 'Your site description'
  tagline = 'Your tagline'

  # About Section
  about = 'Brief description about you'

[params.social]
  github = 'https://github.com/yourusername'
  linkedin = 'https://linkedin.com/in/yourusername'
  twitter = 'https://twitter.com/yourusername'
  email = 'your@email.com'
```

### Image Setup

1. Create an `images` directory in your site's `static` folder
2. Add your avatar image (recommended: 400x400px, square)
3. Add your cover image (recommended: 1200x400px, wide format)

### Google Analytics (Optional)

```toml
[params]
  googleAnalytics = 'G-XXXXXXXXXX'
```

## Creating Content

Create a new post:

```bash
hugo new posts/my-first-post.md
```

Post frontmatter example:

```toml
+++
title = 'My First Post'
date = 2024-12-04T22:18:12-05:00
draft = false
description = 'A brief description of your post'
tags = ['Hugo', 'Web Development', 'AI']
+++

Your content here...
```

## Customization

### Colors

Edit `themes/coreydaley-dev/static/css/style.css` and modify the CSS variables in the `:root` selector:

```css
:root {
    --primary: #6366f1;
    --accent-pink: #ec4899;
    --accent-cyan: #06b6d4;
    /* ... more colors */
}
```

### Fonts

The theme uses:
- **Display**: Fredoka (headings, titles)
- **Body**: DM Sans (content)
- **Code**: Fira Code (code blocks)

Change fonts by updating the Google Fonts link in `layouts/_default/baseof.html` and the CSS variables.

## Browser Support

- Chrome/Edge (latest)
- Firefox (latest)
- Safari (latest)
- Mobile browsers (iOS Safari, Chrome Mobile)

## License

MIT License - feel free to use and modify!

## Credits

Created with passion for the developer community. Built with Hugo and designed to stand out from generic blog themes.
