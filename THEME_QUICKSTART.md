<!--
Created by: AI Agent
Date: 2026-02-06T22:56:44-05:00
-->

# Quick Start: Switch to Coreydaley Dev Theme

Your new custom Hugo theme is ready! Here's how to activate it:

## Step 1: Update hugo.toml

Update your `hugo.toml` file to use the new theme:

```toml
baseURL = 'https://coreydaley.com/'
languageCode = 'en-us'
title = 'Corey Daley'
theme = 'coreydaley-dev'

[params]
  # Add your images to static/images/ directory
  avatar = '/images/avatar.jpg'
  coverImage = '/images/cover.jpg'

  description = 'Technical blog about software engineering and AI development'
  tagline = 'Software Engineer | AI Enthusiast | Builder'

  about = 'Passionate software engineer exploring AI, automation, and developer tools. Writing about what I learn along the way.'

  # Keep your existing Google Analytics ID
  googleAnalytics = 'YOUR-EXISTING-ID'

[params.social]
  github = 'https://github.com/coreydaley'
  linkedin = 'https://linkedin.com/in/coreydaley'
  twitter = 'https://twitter.com/coreydaley'
  email = 'your@email.com'
```

## Step 2: Add Your Images

Create these images in `static/images/`:

1. **avatar.jpg** (400x400px recommended)
   - Your profile photo
   - Will be displayed as a circle
   - Use a clear, friendly photo

2. **cover.jpg** (1200x400px recommended)
   - Background header image
   - Wide landscape format
   - Or use a solid gradient (the theme applies an overlay)

**Quick option**: If you don't have images yet, the theme will fall back to gradients.

## Step 3: Test Locally

```bash
hugo server -D
```

Visit http://localhost:1313 to see your new theme in action!

## Step 4: Customize (Optional)

**Colors**: Edit `themes/coreydaley-dev/static/css/style.css` and change the `:root` variables

**Social Links**: Add or remove any social links in the `[params.social]` section

**About Text**: Update the `about` parameter to describe yourself

## Step 5: Deploy

When you're happy with the result:

```bash
hugo --minify
git add .
git commit -m "Switch to custom coreydaley-dev theme"
git push
```

Your GitHub Actions workflow will automatically deploy the changes.

## 📚 Documentation

- **SETUP.md**: Detailed setup instructions
- **README.md**: Full theme documentation
- **THEME_OVERVIEW.md**: Design philosophy and features

## 🎨 What You Get

✅ Eye-catching, playful design
✅ LinkedIn-inspired layout
✅ Smooth animations and hover effects
✅ Fully responsive
✅ Social media integration
✅ Code syntax highlighting ready
✅ SEO optimized

## 🐛 Troubleshooting

**Theme not showing?**
- Make sure `theme = 'coreydaley-dev'` is set in hugo.toml
- Run `hugo server --noHTTPCache` to clear cache

**Images not appearing?**
- Check images are in `static/images/`
- Verify paths start with `/` in hugo.toml

**Styling looks broken?**
- Clear browser cache
- Check browser console for errors
- Ensure CSS file exists at `themes/coreydaley-dev/static/css/style.css`

---

Enjoy your new theme! 🚀
