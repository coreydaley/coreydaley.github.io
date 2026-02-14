#!/usr/bin/env bash

# Created by: Claude Code (Claude Sonnet 4.5)
# Date: 2026-02-13T21:30:00-05:00
#
# Script to resize images in static/images to a maximum width of 512px
# Maintains aspect ratio by automatically adjusting height

set -e

# Configuration
MAX_WIDTH=512
IMAGE_DIR="static/images"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check for available image processing tools
USE_TOOL=""
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

# Change to project root
cd "$PROJECT_ROOT"

# Check if images directory exists
if [ ! -d "$IMAGE_DIR" ]; then
    echo -e "${RED}Error: Directory $IMAGE_DIR does not exist.${NC}"
    exit 1
fi

echo -e "${BLUE}==================================${NC}"
echo -e "${BLUE}Image Resize Script${NC}"
echo -e "${BLUE}==================================${NC}"
echo ""
echo -e "Tool: ${GREEN}${USE_TOOL}${NC}"
echo -e "Maximum width: ${GREEN}${MAX_WIDTH}px${NC}"
echo -e "Image directory: ${GREEN}${IMAGE_DIR}${NC}"
echo ""

# Counter for statistics
total_images=0
resized_images=0
skipped_images=0
failed_images=0

# Find all image files (jpg, jpeg, png, gif, webp)
while IFS= read -r -d '' image_file; do
    total_images=$((total_images + 1))

    # Get relative path for display
    relative_path="${image_file#$PROJECT_ROOT/}"

    # Get image width based on tool
    if [ "$USE_TOOL" = "sips" ]; then
        width=$(sips -g pixelWidth "$image_file" 2>/dev/null | grep pixelWidth | awk '{print $2}')
    else
        width=$($IDENTIFY_CMD -format "%w" "$image_file" 2>/dev/null || echo "0")
    fi

    # Check if we got a valid width
    if [ -z "$width" ] || [ "$width" = "0" ]; then
        echo -e "${RED}✗${NC} Failed to read: $relative_path"
        failed_images=$((failed_images + 1))
        continue
    fi

    # Check if image needs resizing
    if [ "$width" -gt "$MAX_WIDTH" ]; then
        echo -e "${YELLOW}↻${NC} Resizing: $relative_path (${width}px → ${MAX_WIDTH}px)"

        # Create backup
        backup_file="${image_file}.backup"
        cp "$image_file" "$backup_file"

        # Resize image based on tool (maintains aspect ratio)
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
            # Get new dimensions based on tool
            if [ "$USE_TOOL" = "sips" ]; then
                new_width=$(sips -g pixelWidth "$image_file" 2>/dev/null | grep pixelWidth | awk '{print $2}')
                new_height=$(sips -g pixelHeight "$image_file" 2>/dev/null | grep pixelHeight | awk '{print $2}')
            else
                new_width=$($IDENTIFY_CMD -format "%w" "$image_file" 2>/dev/null || echo "0")
                new_height=$($IDENTIFY_CMD -format "%h" "$image_file" 2>/dev/null || echo "0")
            fi

            echo -e "${GREEN}✓${NC} Resized to: ${new_width}x${new_height}px"

            # Remove backup after successful resize
            rm "$backup_file"

            resized_images=$((resized_images + 1))
        else
            echo -e "${RED}✗${NC} Failed to resize: $relative_path"
            # Restore from backup
            mv "$backup_file" "$image_file"
            failed_images=$((failed_images + 1))
        fi
    else
        echo -e "${GREEN}✓${NC} Already optimal: $relative_path (${width}px)"
        skipped_images=$((skipped_images + 1))
    fi

done < <(find "$IMAGE_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" \) -print0)

# Print summary
echo ""
echo -e "${BLUE}==================================${NC}"
echo -e "${BLUE}Summary${NC}"
echo -e "${BLUE}==================================${NC}"
echo -e "Total images found:    ${total_images}"
echo -e "Resized:              ${GREEN}${resized_images}${NC}"
echo -e "Already optimal:      ${GREEN}${skipped_images}${NC}"
if [ "$failed_images" -gt 0 ]; then
    echo -e "Failed:               ${RED}${failed_images}${NC}"
fi
echo ""

if [ "$resized_images" -gt 0 ]; then
    echo -e "${GREEN}✓ Image resize completed successfully!${NC}"
else
    echo -e "${BLUE}All images are already optimized.${NC}"
fi
