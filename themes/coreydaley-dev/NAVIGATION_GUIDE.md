# Header Navigation Guide

The header now includes a navigation menu in the top right corner that automatically displays links to your pages.

## Navigation Menu Features

- **Fixed Position**: Always visible in the top right of the header
- **Automatic**: Detects all pages and adds them to the menu
- **Home Link**: Always includes a "Home" link
- **Responsive**: Adapts to mobile screens

## Creating Pages for Navigation

### 1. Create a Page

Create a new page in your `content` directory:

```bash
hugo new about.md
# or
hugo new projects.md
```

### 2. Configure the Page

Edit the page's frontmatter:

```toml
+++
title = 'About'
date = 2024-01-01T00:00:00Z
draft = false
type = 'page'
+++

# About Me

Your content here...
```

**Important:** Set `type = 'page'` in the frontmatter so the page appears in navigation.

### 3. Pages Automatically Appear

The page will automatically appear in the header navigation once:
- `draft = false`
- `type = 'page'`
- The file is saved

## Example Pages

### About Page

**File:** `content/about.md`

```toml
+++
title = 'About'
date = 2024-01-01T00:00:00Z
draft = false
type = 'page'
+++

# About Me

I'm a software engineer passionate about AI and development...
```

### Projects Page

**File:** `content/projects.md`

```toml
+++
title = 'Projects'
date = 2024-01-01T00:00:00Z
draft = false
type = 'page'
+++

# My Projects

Here are some projects I've been working on...
```

### Contact Page

**File:** `content/contact.md`

```toml
+++
title = 'Contact'
date = 2024-01-01T00:00:00Z
draft = false
type = 'page'
+++

# Get in Touch

Feel free to reach out...
```

## Navigation Order

Pages appear in the navigation in the order they are discovered by Hugo. To control the order, you can add a `weight` parameter:

```toml
+++
title = 'About'
date = 2024-01-01T00:00:00Z
draft = false
type = 'page'
weight = 1
+++
```

Lower weights appear first (1, 2, 3...).

## Excluding Pages from Navigation

To create a page that doesn't appear in navigation, simply don't set `type = 'page'`:

```toml
+++
title = 'Hidden Page'
date = 2024-01-01T00:00:00Z
draft = false
+++
```

Or keep it as draft:

```toml
+++
title = 'Work in Progress'
date = 2024-01-01T00:00:00Z
draft = true
type = 'page'
+++
```

## Navigation Styling

The navigation menu has:
- Semi-transparent white background with blur effect
- Smooth hover animations
- Rounded corners
- Responsive layout for mobile

On mobile devices:
- Navigation moves to the top of the header
- Links stack horizontally with wrapping
- Centered alignment

## Testing

1. Create a page:
   ```bash
   hugo new about.md
   ```

2. Edit the frontmatter:
   ```toml
   draft = false
   type = 'page'
   ```

3. Run the development server:
   ```bash
   hugo server -D
   ```

4. Visit your site and check the header navigation

The link should appear automatically in the top right corner!
