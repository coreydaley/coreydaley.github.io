# Example Site Images

To use this example site, you'll need to add the following images to this directory:

## Required Images

### `avatar.jpg`
- **Purpose**: Profile picture displayed in the header
- **Recommended Size**: 400x400px (square)
- **Format**: JPG or PNG
- **Description**: Your profile photo or logo

### `cover.jpg`
- **Purpose**: Cover image displayed behind the avatar in the header
- **Recommended Size**: 1200x400px (wide/landscape)
- **Format**: JPG or PNG
- **Description**: A banner or background image that represents your blog

## Quick Start

If you don't have images ready, you can:

1. Use placeholder images from services like:
   - [Lorem Picsum](https://picsum.photos/) - `https://picsum.photos/400` for avatar, `https://picsum.photos/1200/400` for cover
   - [Unsplash](https://unsplash.com/)
   - [Pexels](https://pexels.com/)

2. Create simple colored backgrounds using design tools
3. Use AI image generators

## Adding Images

Simply place your images in this directory:

```
static/images/
├── avatar.jpg
└── cover.jpg
```

Then reference them in your `hugo.toml`:

```toml
[params]
  avatar = '/images/avatar.jpg'
  coverImage = '/images/cover.jpg'
```
