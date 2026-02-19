#!/usr/bin/env bash

# Created by: Claude Code (Claude Sonnet 4.5)
# Date: 2026-02-13T21:30:00-05:00
# Last Modified By: Claude Code (Claude Sonnet 4.6)
# Last Modified: 2026-02-19T00:00:00-05:00
# Renamed from: resize-images.sh
#
# Resizes images in static/images to a maximum width of 512px and converts
# PNG/JPG images to WebP format. WebP files are ~30-50% smaller than PNG,
# reducing repository size and eliminating the need for CI-side conversion.
#
# Requires one of the following for WebP conversion:
#   macOS:   brew install imagemagick   (or: brew install webp for cwebp)
#   Ubuntu:  sudo apt-get install imagemagick  (or: webp for cwebp)

set -e

# Configuration
MAX_WIDTH=512
WEBP_QUALITY=85
IMAGE_DIR="static/images"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# --- Tool detection ---

# Resize tool
USE_TOOL=""
MAGICK_CMD=""
IDENTIFY_CMD=""
if command -v magick &> /dev/null; then
    USE_TOOL="magick"
    MAGICK_CMD="magick"
    IDENTIFY_CMD="magick identify"
elif command -v convert &> /dev/null; then
    USE_TOOL="imagemagick"
    MAGICK_CMD="convert"
    IDENTIFY_CMD="identify"
elif command -v sips &> /dev/null; then
    USE_TOOL="sips"
else
    echo -e "${RED}Error: No image processing tool found.${NC}"
    echo ""
    echo "Please install one of the following:"
    echo "  macOS:   brew install imagemagick  (or use built-in sips)"
    echo "  Ubuntu:  sudo apt-get install imagemagick"
    echo "  Fedora:  sudo dnf install imagemagick"
    exit 1
fi

# WebP conversion tool (separate from resize tool — sips cannot output WebP)
WEBP_TOOL=""
if command -v cwebp &> /dev/null; then
    WEBP_TOOL="cwebp"
elif [ "$USE_TOOL" = "magick" ]; then
    WEBP_TOOL="magick"
elif [ "$USE_TOOL" = "imagemagick" ]; then
    WEBP_TOOL="imagemagick"
fi

# --- Setup ---

cd "$PROJECT_ROOT"

if [ ! -d "$IMAGE_DIR" ]; then
    echo -e "${RED}Error: Directory $IMAGE_DIR does not exist.${NC}"
    exit 1
fi

echo -e "${BLUE}==================================${NC}"
echo -e "${BLUE}Image Resize & WebP Conversion${NC}"
echo -e "${BLUE}==================================${NC}"
echo ""
echo -e "Resize tool:     ${GREEN}${USE_TOOL}${NC}"
if [ -n "$WEBP_TOOL" ]; then
    echo -e "WebP tool:       ${GREEN}${WEBP_TOOL}${NC}"
else
    echo -e "WebP tool:       ${YELLOW}none${NC}"
fi
echo -e "Maximum width:   ${GREEN}${MAX_WIDTH}px${NC}"
echo -e "WebP quality:    ${GREEN}${WEBP_QUALITY}${NC}"
echo -e "Image directory: ${GREEN}${IMAGE_DIR}${NC}"
echo ""

# --- Counters ---
total_images=0
resized_images=0
skipped_images=0
converted_images=0
failed_images=0

# --- Helpers ---

# Returns 0 (true) if the file is a favicon/manifest icon that must not be converted to WebP
is_reserved_icon() {
    local name
    name=$(basename "$1")
    [[ "$name" == favicon* ]] || [[ "$name" == apple-touch-icon* ]] || [[ "$name" == android-chrome* ]]
}

# Converts a PNG/JPG to WebP and removes the original on success.
# Usage: convert_to_webp <input_file>
# Returns 0 on success, 1 on failure.
convert_to_webp() {
    local input="$1"
    local output="${input%.*}.webp"
    local success=1

    if [ "$WEBP_TOOL" = "cwebp" ]; then
        cwebp -q "$WEBP_QUALITY" "$input" -o "$output" 2>/dev/null && success=0
    elif [ "$WEBP_TOOL" = "magick" ]; then
        magick "$input" -quality "$WEBP_QUALITY" "$output" 2>/dev/null && success=0
    elif [ "$WEBP_TOOL" = "imagemagick" ]; then
        convert "$input" -quality "$WEBP_QUALITY" "$output" 2>/dev/null && success=0
    fi

    if [ $success -eq 0 ] && [ -f "$output" ]; then
        rm "$input"
        return 0
    else
        [ -f "$output" ] && rm -f "$output"  # clean up partial output
        return 1
    fi
}

# --- Main loop ---

while IFS= read -r -d '' image_file; do
    total_images=$((total_images + 1))
    relative_path="${image_file#$PROJECT_ROOT/}"
    ext_lower=$(echo "${image_file##*.}" | tr '[:upper:]' '[:lower:]')

    # Get image width
    if [ "$USE_TOOL" = "sips" ]; then
        width=$(sips -g pixelWidth "$image_file" 2>/dev/null | grep pixelWidth | awk '{print $2}')
    else
        width=$($IDENTIFY_CMD -format "%w" "$image_file" 2>/dev/null || echo "0")
    fi

    if [ -z "$width" ] || [ "$width" = "0" ]; then
        echo -e "${RED}✗${NC} Failed to read: $relative_path"
        failed_images=$((failed_images + 1))
        continue
    fi

    # --- Resize if needed ---
    if [ "$width" -gt "$MAX_WIDTH" ]; then
        echo -e "${YELLOW}↻${NC} Resizing: $relative_path (${width}px → ${MAX_WIDTH}px)"

        backup_file="${image_file}.backup"
        cp "$image_file" "$backup_file"

        resize_success=0
        if [ "$USE_TOOL" = "sips" ]; then
            sips -Z "$MAX_WIDTH" "$image_file" &>/dev/null
            resize_success=$?
        elif [ "$USE_TOOL" = "magick" ]; then
            magick "$image_file" -resize "${MAX_WIDTH}x>" "$image_file" 2>/dev/null
            resize_success=$?
        else
            convert "$image_file" -resize "${MAX_WIDTH}x>" "$image_file" 2>/dev/null
            resize_success=$?
        fi

        if [ $resize_success -eq 0 ]; then
            if [ "$USE_TOOL" = "sips" ]; then
                new_width=$(sips -g pixelWidth "$image_file" 2>/dev/null | grep pixelWidth | awk '{print $2}')
                new_height=$(sips -g pixelHeight "$image_file" 2>/dev/null | grep pixelHeight | awk '{print $2}')
            else
                new_width=$($IDENTIFY_CMD -format "%w" "$image_file" 2>/dev/null || echo "?")
                new_height=$($IDENTIFY_CMD -format "%h" "$image_file" 2>/dev/null || echo "?")
            fi
            echo -e "   ${GREEN}✓${NC} Resized to: ${new_width}x${new_height}px"
            rm "$backup_file"
            resized_images=$((resized_images + 1))
        else
            echo -e "   ${RED}✗${NC} Resize failed — restoring original"
            mv "$backup_file" "$image_file"
            failed_images=$((failed_images + 1))
            continue
        fi
    else
        echo -e "${GREEN}✓${NC} Already optimal: $relative_path (${width}px)"
        skipped_images=$((skipped_images + 1))
    fi

    # --- Convert to WebP (skip .webp files and reserved browser icons) ---
    if [ "$ext_lower" != "webp" ] && ! is_reserved_icon "$image_file"; then
        if [ -n "$WEBP_TOOL" ]; then
            if convert_to_webp "$image_file"; then
                echo -e "   ${CYAN}⇢${NC} Converted to WebP: ${relative_path%.*}.webp"
                converted_images=$((converted_images + 1))
            else
                echo -e "   ${YELLOW}⚠${NC} WebP conversion failed — keeping original"
            fi
        fi
    fi

done < <(find "$IMAGE_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" \) -print0)

# --- Summary ---
echo ""
echo -e "${BLUE}==================================${NC}"
echo -e "${BLUE}Summary${NC}"
echo -e "${BLUE}==================================${NC}"
echo -e "Total images:         ${total_images}"
echo -e "Resized:              ${GREEN}${resized_images}${NC}"
echo -e "Already optimal:      ${GREEN}${skipped_images}${NC}"
echo -e "Converted to WebP:    ${GREEN}${converted_images}${NC}"
if [ "$failed_images" -gt 0 ]; then
    echo -e "Failed:               ${RED}${failed_images}${NC}"
fi
echo ""

if [ -z "$WEBP_TOOL" ]; then
    echo -e "${YELLOW}⚠ WebP conversion skipped — no conversion tool found.${NC}"
    echo -e "  To enable WebP conversion, install one of the following:"
    echo -e "    macOS:   ${CYAN}brew install imagemagick${NC}  or  ${CYAN}brew install webp${NC}"
    echo -e "    Ubuntu:  ${CYAN}sudo apt-get install imagemagick${NC}  or  ${CYAN}sudo apt-get install webp${NC}"
    echo ""
fi

if [ "$converted_images" -gt 0 ]; then
    echo -e "${YELLOW}Next steps after WebP conversion:${NC}"
    echo -e "  1. Update image references in post frontmatter from .png/.jpg to .webp"
    echo -e "  2. Update hugo.toml avatar/coverImage paths if converted"
    echo -e "  3. The CI WebP generation step can be removed from hugo.yml"
    echo ""
fi

if [ "$resized_images" -gt 0 ] || [ "$converted_images" -gt 0 ]; then
    echo -e "${GREEN}✓ Image processing completed successfully!${NC}"
else
    echo -e "${BLUE}All images are already optimized.${NC}"
fi
