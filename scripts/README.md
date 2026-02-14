# Scripts

This directory contains utility scripts for the Hugo site.

## resize-images.sh

Automatically resizes all images in `static/images/` to a maximum width of 512px while maintaining aspect ratio.

### Features

- Automatically detects and uses available image processing tools:
  - ImageMagick (`magick` or `convert`)
  - macOS `sips` (built-in, no installation needed)
- Maintains aspect ratio when resizing
- Creates automatic backups before resizing
- Provides detailed output with color-coded status
- Shows summary statistics

### Usage

```bash
# Run from project root
./scripts/resize-images.sh
```

### Requirements

One of the following must be installed:
- **macOS**: `sips` (built-in, no installation needed)
- **ImageMagick**:
  - macOS: `brew install imagemagick`
  - Ubuntu/Debian: `sudo apt-get install imagemagick`
  - Fedora: `sudo dnf install imagemagick`

### Output

The script will:
- ✓ Show which images are already optimal (≤512px width)
- ↻ Indicate which images are being resized
- Display new dimensions after resizing
- Provide a summary of total, resized, and skipped images

### Example

```
==================================
Image Resize Script
==================================

Tool: sips
Maximum width: 512px
Image directory: static/images

✓ Already optimal: static/images/favicon-16x16.png (16px)
↻ Resizing: static/images/cover.png (1200px → 512px)
✓ Resized to: 512x170px

==================================
Summary
==================================
Total images found:    28
Resized:              22
Already optimal:      6

✓ Image resize completed successfully!
```

### Configuration

To change the maximum width, edit the `MAX_WIDTH` variable at the top of the script:

```bash
MAX_WIDTH=512  # Change this value as needed
```

### Supported Formats

- JPEG (`.jpg`, `.jpeg`)
- PNG (`.png`)
- GIF (`.gif`)
- WebP (`.webp`)
