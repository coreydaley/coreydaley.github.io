# coreydaley-dev Theme

A playful, eye-catching Hugo theme for technical blogs about software engineering and AI development. Features a cartoony design with vibrant colors, smooth animations, and a LinkedIn-inspired layout.

## Features

### Design & Layout

- **Distinctive Design**: Playful futurism aesthetic with cartoon-style elements and vibrant colors
- **LinkedIn-Inspired Header**: Round avatar overlaid on cover image with gradient overlay
- **Responsive Sidebar**: Desktop sidebar navigation with categories and tag cloud
- **Mobile-First Design**: Hamburger menu with full navigation on mobile devices
- **Sticky Header**: Header scrolls with page and becomes compact when scrolling
- **Card-Based Layout**: Clean card design for posts with rounded corners and shadows

### Content Features

- **Post Listings**: Beautiful post cards with optional images, descriptions, tags, and categories
- **Tag Cloud**: Dynamic tag sizing based on post count in sidebar
- **Category Navigation**: Organized category browsing in sidebar and mobile menu
- **Search Functionality**: Full-text search powered by Pagefind (client-side, no server required)
- **Pagination**: Customizable posts per page with elegant pagination controls
- **Social Sharing**: OpenGraph and Twitter Card meta tags for beautiful social media previews

### Customization

- **Special Date Avatars**: Automatic avatar swapping for holidays (Halloween, Christmas, etc.)
- **Custom Partials**: Easy customization via `additional-head.html` and `additional-footer.html`
- **Social Media Links**: Configurable social media links in header and footer (GitHub, LinkedIn, Twitter/X, Facebook, Instagram, Mastodon, Bluesky, YouTube, Reddit, Stack Overflow, Email)
- **Google Analytics**: Built-in Google Analytics 4 support

### Developer Experience

- **Code-Friendly**: Syntax highlighting ready with Fira Code font
- **Fast Loading**: Minified CSS with fingerprinting and integrity hashes
- **SEO Optimized**: Semantic HTML, meta tags, structured data, and sitemap support
- **Modern Fonts**: Google Fonts integration with Fredoka (display), DM Sans (body), and Fira Code (code)
- **Smooth Animations**: Hover effects, transitions, and micro-interactions throughout

## Installation

1. Navigate to your Hugo site's directory:

```bash
cd your-hugo-site
```

2. Add the theme as a Git submodule or copy it directly:

```bash
# Using Git submodule
git submodule add https://github.com/coreydaley/coreydaley-dev-theme.git themes/coreydaley-dev

# Or copy the theme directory
cp -r /path/to/coreydaley-dev themes/
```

3. Update your `hugo.toml`:

```toml
theme = 'coreydaley-dev'
```

## Configuration

### Complete Configuration Reference

Below is a complete `hugo.toml` configuration with all supported theme options:

```toml
baseURL = 'https://yoursite.com/'
languageCode = 'en-us'
title = 'Your Name'
theme = 'coreydaley-dev'

# Pagination settings
[pagination]
  pagerSize = 5  # Number of posts per page (default: 10)

# Markdown rendering settings
[markup]
  [markup.goldmark]
    [markup.goldmark.renderer]
      unsafe = true  # Required for HTML in markdown content

[params]
  # Header Images (REQUIRED)
  avatar = '/images/avatar.jpg'        # Path to avatar image (400x400px recommended)
  coverImage = '/images/cover.jpg'     # Path to cover image (1200x400px recommended)

  # Site Metadata (REQUIRED)
  description = 'Your site description'  # Used for SEO meta tags
  tagline = 'Your tagline'              # Displayed below site title in header

  # Special Date Avatar Swapping (OPTIONAL)
  # Automatically changes avatar on holidays and special dates
  # See "Special Date Avatar Swapping" section below for details
  enableCheckSpecialDate = false  # Set to true to enable (default: false)

[params.social]
  # Social media links (all optional)
  # Only configured links will be displayed in header and footer
  github = 'https://github.com/yourusername'
  linkedin = 'https://linkedin.com/in/yourusername'
  twitter = 'https://twitter.com/yourusername'          # or X.com URL
  facebook = 'https://facebook.com/yourusername'
  instagram = 'https://instagram.com/yourusername'
  mastodon = 'https://mastodon.social/@yourusername'    # Include full URL
  bluesky = 'https://bsky.app/profile/yourusername.bsky.social'
  youtube = 'https://youtube.com/@yourusername'
  reddit = 'https://reddit.com/u/yourusername'
  stackoverflow = 'https://stackoverflow.com/users/yourid/yourname'
  email = 'your@email.com'

[params.tracking]
  # Analytics (optional)
  googleAnalytics = 'G-XXXXXXXXXX'  # Google Analytics 4 tracking ID
```

### Required vs Optional Parameters

**Required:**

- `baseURL` - Your site's URL
- `title` - Site title (your name or site name)
- `theme = 'coreydaley-dev'`
- `params.avatar` - Path to avatar image
- `params.coverImage` - Path to cover image
- `params.description` - Site description
- `params.tagline` - Site tagline

**Optional:**

- `pagination.pagerSize` - Posts per page (default: 10)
- `params.enableCheckSpecialDate` - Special date avatars (default: false)
- `params.social.*` - Social media links (shown if configured)
- `params.tracking.googleAnalytics` - Google Analytics tracking

### Image Setup

1. Create an `images` directory in your site's `static` folder
2. Add your avatar image (recommended: 400x400px, square)
3. Add your cover image (recommended: 1200x400px, wide format)

**Example structure:**

```
static/
  images/
    avatar.jpg
    cover.jpg
    avatars/          # For special date avatars (optional)
      avatar-halloween.png
      avatar-christmas.png
```

### Special Date Avatar Swapping (Optional)

The theme can automatically change your avatar on special dates and holidays:

```toml
[params]
  # Enable special date avatar swapping (default: false)
  enableCheckSpecialDate = true
```

**Supported Holidays:**

- New Year's Day (January 1)
- Valentine's Day (February 14)
- St. Patrick's Day (March 17)
- Birthday (March 1 - customize in code)
- Cinco de Mayo (May 5)
- Memorial Day (Last Monday of May)
- Independence Day (July 4)
- Labor Day (First Monday of September)
- Halloween (October 31)
- Veterans Day (November 11)
- Thanksgiving (Fourth Thursday of November)
- Christmas (December 25)
- Friday the 13th

**How it works:**
Place special avatar images in `/static/images/avatars/` with names like:

- `avatar-new-years.png`
- `avatar-christmas.png`
- `avatar-halloween.png`
- etc.

Set `enableCheckSpecialDate = true` to enable this feature. When disabled (default), your default avatar will always be used.

## Layout & Navigation

### Desktop Layout

The theme uses a two-column layout on desktop:

- **Header**: Fixed header with avatar, site title, tagline, social links, and search
- **Sidebar**: Sticky sidebar with categories and tag cloud (visible on screens > 968px)
- **Content Area**: Main content area for posts and pages
- **Footer**: Footer with social links and copyright information

### Mobile Layout

On mobile devices (< 968px width):

- **Hamburger Menu**: Tap to open slide-in navigation drawer
- **Mobile Navigation**: Full-screen menu with categories, tags, and search
- **Responsive Content**: Single-column layout optimized for mobile viewing
- **Touch-Friendly**: Larger tap targets and spacing for mobile usability

### Responsive Breakpoints

- **> 1200px**: Full sidebar width (250px)
- **968px - 1200px**: Narrow sidebar (220px)
- **< 968px**: Mobile layout (sidebar hidden, hamburger menu shown)

## Creating Content

Create a new post:

```bash
hugo new posts/my-first-post.md
```

### Post Frontmatter

Posts support the following frontmatter parameters:

```toml
+++
# Required fields
title = 'My First Post'                    # Post title
date = 2024-12-04T22:18:12-05:00          # Publication date
draft = false                              # true = hidden, false = published

# Optional but recommended
description = 'A brief description'        # SEO meta description and post excerpt
tags = ['Hugo', 'Web Development', 'AI']  # Post tags (lowercase, hyphenated)
categories = ['Web Development']           # Post categories (Title Case)

# Optional
author = 'Your Name'                      # Post author
image = '/images/post-image.png'          # Social sharing image (og:image)
+++

Your content here...
```

**Frontmatter Field Details:**

- **title** (required) - The post title displayed on the page and in listings
- **date** (required) - Publication date in ISO 8601 format
- **draft** (required) - Set to `false` to publish, `true` to hide
- **description** (recommended) - Used for:
  - SEO meta description
  - Post excerpt in post listings
  - OpenGraph description for social sharing
- **tags** (recommended) - Array of tags (displayed in post and sidebar tag cloud)
- **categories** (recommended) - Array of categories (displayed in post and sidebar)
- **author** (optional) - Author name (not displayed by default, but available in templates)
- **image** (optional) - Path to image for social media sharing (og:image and twitter:image)

### Search Page

The theme includes a search page powered by Pagefind. To add search to your site:

1. Copy the search page from the example site:

```bash
cp themes/coreydaley-dev/exampleSite/content/search.md content/
```

2. The search page will be available at `/search`

**search.md contents:**

```toml
+++
title = 'Search'
layout = 'search'
draft = false
+++
```

#### Indexing Your Site with Pagefind

Pagefind creates a search index from your built site. You need to run it **after** building your Hugo site.

**Installation:**

```bash
# Install pagefind globally via npm
npm install -g pagefind

# Or use npx to run without installing
npx pagefind --help
```

**Local Development:**

1. Build your Hugo site:

```bash
hugo --minify
```

2. Index the built site with pagefind:

```bash
npx pagefind --source "public"
```

3. Start Hugo server to preview the indexed search:

```bash
hugo server
```

**CI/CD:**

If you're using GitHub Actions or another CI/CD pipeline, pagefind is automatically run after the Hugo build. The search functionality will be indexed on every deployment. No additional configuration is needed for automated deployments.

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

### Custom Footer Content

The theme supports adding custom content to the footer without modifying theme files. This is useful for adding:

- Custom copyright notices
- Additional legal links (Privacy Policy, Terms of Service)
- Social media icons
- Analytics badges
- Custom HTML/scripts

**How to use:**

1. Create the file `layouts/partials/additional-footer.html` in your site's root (not in the theme directory)
2. Add your custom HTML content to this file
3. Your content will automatically appear at the bottom of the footer

**Example:**

Create `layouts/partials/additional-footer.html`:

```html
<p class="custom-footer-text">
  <a href="/privacy">Privacy Policy</a> |
  <a href="/terms">Terms of Service</a>
</p>
<p class="custom-copyright">
  All content © 2026 Your Name. Some rights reserved.
</p>
```

**Tips:**

- The partial is loaded at the end of the footer, after the license notice
- You can use any HTML, including custom CSS classes
- Hugo template syntax is supported (access `.Site.Params`, etc.)
- Leave the file empty or don't create it if you don't need custom footer content
- This approach keeps your customizations separate from the theme, making theme updates easier

### Custom Head Content

The theme supports adding custom content to the `<head>` section without modifying theme files. This is useful for adding:

- Custom meta tags
- Additional stylesheets
- Third-party scripts (analytics, fonts, etc.)
- Favicon links
- Web app manifest
- Custom Open Graph tags
- Verification tags (Google, Bing, Pinterest, etc.)

**How to use:**

1. Create the file `layouts/partials/additional-head.html` in your site's root (not in the theme directory)
2. Add your custom HTML content to this file
3. Your content will automatically appear at the end of the `<head>` section

**Example:**

Create `layouts/partials/additional-head.html`:

```html
<!-- Custom verification meta tags -->
<meta name="google-site-verification" content="your-verification-code" />
<meta name="p:domain_verify" content="pinterest-verification-code" />

<!-- Additional fonts -->
<link rel="preconnect" href="https://fonts.example.com" />
<link href="https://fonts.example.com/css?family=CustomFont" rel="stylesheet" />

<!-- Custom analytics or tracking -->
<script async src="https://analytics.example.com/script.js"></script>

<!-- PWA manifest -->
<link rel="manifest" href="/manifest.json" />
<meta name="theme-color" content="#2ca3e5" />
```

**Tips:**

- The partial is loaded at the end of the `<head>` section, after all theme defaults
- Perfect for adding third-party integrations without modifying theme files
- Hugo template syntax is supported (access `.Site.Params`, etc.)
- Leave the file empty or don't create it if you don't need custom head content
- This approach keeps your customizations separate from the theme, making theme updates easier

## Browser Support

- Chrome/Edge (latest)
- Firefox (latest)
- Safari (latest)
- Mobile browsers (iOS Safari, Chrome Mobile)

## Requirements

- **Hugo**: v0.155.2 or higher (extended version required)
- **Node.js & npm**: Required for Pagefind search indexing
- **Pagefind**: v1.0.0 or higher (for search functionality)

The extended version of Hugo is required for SCSS processing and advanced features. You can check your Hugo version with:

```bash
hugo version
```

If you need to install Hugo extended, visit: https://gohugo.io/installation/

## License

This theme is licensed under the [MIT License](LICENSE).

Copyright © 2026 Corey Daley

Permission is hereby granted, free of charge, to any person obtaining a copy of this theme and associated documentation files, to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software. See the [LICENSE](LICENSE) file for the full license text.

## Credits

Created with passion for the developer community. Built with Hugo and designed to stand out from generic blog themes.
