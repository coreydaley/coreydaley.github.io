+++
title = 'About This Theme'
draft = false
+++

# About coreydaley-dev Theme

**coreydaley-dev** is a clean, modern Hugo theme designed for developers and technical bloggers who want a professional online presence without the bloat.

## Features

### Design & Layout

- **Clean, distraction-free reading experience** - Focus on your content with a minimalist design
- **Responsive layout** - Looks great on desktop, tablet, and mobile devices
- **Customizable header and sidebar** - Easy navigation and branding
- **Avatar and cover image support** - Personalize your site with custom imagery
- **Special date avatars** - Optional automatic avatar changes for holidays (Halloween, Christmas, etc.)

### Content Management

- **Post pagination** - Clean browsing experience for blog archives
- **Tag and category support** - Organize your content effectively
- **Draft management** - Preview posts before publishing
- **Markdown support** - Write in the format you love
- **Code syntax highlighting** - Perfect for technical content

### Search & Discovery

- **Integrated search** - Powered by Pagefind for fast, client-side search
- **SEO optimized** - Meta descriptions, summaries, and proper markup
- **RSS feed support** - Let readers subscribe to your content

### Social & Analytics

- **Social media integration** - Connect your GitHub, LinkedIn, Twitter, Mastodon, Bluesky, and more
- **Google Analytics ready** - Track your site's performance
- **Email contact** - Direct contact option for readers

## Configuration

The theme is highly configurable through `hugo.toml`:

```toml
[params]
  avatar = '/images/avatar.jpg'
  coverImage = '/images/cover.jpg'
  description = 'A blog about some really cool stuff'
  tagline = 'Your Awesome Tagline'
  enableCheckSpecialDate = false

[params.social]
  github = 'https://github.com/yourusername'
  linkedin = 'https://linkedin.com/in/yourusername'
  # ... and many more
```

## Getting Started

1. **Install the theme** in your Hugo site's `themes/` directory
2. **Add your images** to `static/images/` (avatar and cover)
3. **Configure** your site in `hugo.toml`
4. **Create content** with `hugo new posts/my-post.md`
5. **Run** with `hugo server -D`

## Technology Stack

- **Hugo** - Fast static site generator
- **Pagefind** - Client-side search
- **Responsive CSS** - Mobile-first design
- **Markdown** - Simple content authoring

## License

This theme is open source and available under the MIT License.

## About the Author

Created by Corey Daley for developers who want a straightforward, beautiful blog without unnecessary complexity.

## Support

- **Issues & Questions** - [GitHub Issues](https://github.com/coreydaley/coreydaley-dev-theme/issues)
- **Source Code** - [GitHub Repository](https://github.com/coreydaley/coreydaley-dev-theme)
- **Documentation** - Check the README.md files in the theme repository

---

_This About page is part of the example site. Customize it to tell your own story!_
