# Pagefind Search Setup

The theme now includes a search feature powered by Pagefind, a static search library.

## Installation

### 1. Install Pagefind

```bash
# Using npm
npm install -g pagefind

# Or using Homebrew (macOS)
brew install pagefind

# Or download from https://pagefind.app/
```

### 2. Build Your Site

```bash
hugo --minify
```

### 3. Index Your Site with Pagefind

After building your Hugo site, run Pagefind to create the search index:

```bash
pagefind --source public
```

This creates a `public/pagefind/` directory with the search index and UI assets.

**Important:** Pagefind indexes all HTML pages in the `public` directory by default. Both posts and pages will be indexed automatically as long as they have `draft = false` in their frontmatter.

## Deployment

### GitHub Actions

Add this step to your `.github/workflows/hugo.yml` after the Hugo build step:

```yaml
- name: Install Pagefind
  run: npm install -g pagefind

- name: Build search index
  run: pagefind --source public
```

### Manual Deployment

1. Build your site: `hugo --minify`
2. Index the site: `pagefind --source public`
3. Deploy the entire `public/` directory (including `public/pagefind/`)

## How It Works

1. **Search Form**: Located in the sidebar, submits to `/search` using GET method
2. **Search Page**: Located at `/search`, displays results using Pagefind UI
3. **Results Layout**: Custom JavaScript transforms Pagefind results to match your post card design
4. **Styling**: Custom CSS makes the search UI match your theme

## Features

- ✅ Client-side search (no server required)
- ✅ Fast, instant results
- ✅ Automatic indexing of all pages
- ✅ Custom result rendering matching post cards
- ✅ Responsive design
- ✅ Search query in URL (shareable searches)

## Customization

### Search Query Parameter

The search uses the query parameter `q`. For example:
- `/search?q=hugo`
- `/search?q=javascript+tutorial`

### Excluded Content

To exclude pages from search results, add this to the page's frontmatter:

```toml
+++
title = "Private Page"
pagefind = false
+++
```

### Search Options

Edit `themes/coreydaley-dev/layouts/_default/search.html` to customize:

```javascript
new PagefindUI({
    element: "#search",
    showSubResults: true,    // Show sub-results
    showImages: false,       // Hide images in results
    excerptLength: 150,      // Length of excerpt
    resetStyles: false       // Keep custom styles
});
```

## Testing Locally

1. Build and index:
   ```bash
   hugo --minify
   pagefind --source public
   ```

2. Serve the public directory:
   ```bash
   cd public
   python3 -m http.server 8000
   ```

3. Visit: `http://localhost:8000/search`

## Troubleshooting

### Posts not showing in search results

If your posts aren't appearing in search:

1. **Rebuild everything:**
   ```bash
   hugo --minify
   pagefind --source public
   ```

2. **Check post frontmatter:**
   - Make sure `draft = false` (not `draft = true`)
   - Posts should be in `content/posts/` directory

3. **Verify posts are built:**
   ```bash
   ls -la public/posts/
   ```
   You should see HTML files for each post.

4. **Check Pagefind indexing:**
   ```bash
   pagefind --source public --verbose
   ```
   This shows what Pagefind is indexing.

### "Pagefind not found" errors

Make sure the `public/pagefind/` directory exists after running `pagefind --source public`.

### Search not working after deployment

Ensure your deployment process includes the `pagefind/` directory. Check that these files exist:
- `/pagefind/pagefind.js`
- `/pagefind/pagefind-ui.js`
- `/pagefind/pagefind-ui.css`

### Results not styled correctly

Check browser console for JavaScript errors. The custom rendering depends on the Pagefind UI loading successfully.

## Learn More

- [Pagefind Documentation](https://pagefind.app/)
- [Pagefind GitHub](https://github.com/CloudCannon/pagefind)
