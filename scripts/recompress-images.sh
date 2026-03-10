#!/usr/bin/env bash

#
# Re-encodes all existing WebP images with maximum compression settings,
# replacing each file only if the re-encoded output is actually smaller.
#
# This is a one-time operation — not part of the pre-commit hook. Run it
# explicitly when you want to squeeze existing images, then stage and commit:
#
#   make recompress-images
#   git add static/images
#   git commit
#
# Because cwebp -m 6 finds micro-optimizations each pass, running this
# repeatedly produces diminishing returns (bytes → zero). After one or two
# runs the files are stable enough to commit without the hook flagging them.
#
# Requires cwebp (preferred) or ImageMagick:
#   macOS:  brew install webp   or   brew install imagemagick
#   Ubuntu: sudo apt-get install webp

set -e

WEBP_QUALITY=82
IMAGE_DIR="static/images"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Tool detection
WEBP_TOOL=""
if command -v cwebp &> /dev/null; then
    WEBP_TOOL="cwebp"
elif command -v magick &> /dev/null; then
    WEBP_TOOL="magick"
elif command -v convert &> /dev/null; then
    WEBP_TOOL="imagemagick"
fi

if [ -z "$WEBP_TOOL" ]; then
    echo -e "${RED}Error: No WebP tool found.${NC}"
    echo "Install one of: brew install webp  |  brew install imagemagick"
    exit 1
fi

cd "$PROJECT_ROOT"

echo -e "${BLUE}=================================${NC}"
echo -e "${BLUE}WebP Recompression (one-time)${NC}"
echo -e "${BLUE}=================================${NC}"
echo ""
echo -e "WebP tool:    ${GREEN}${WEBP_TOOL}${NC}"
echo -e "Quality:      ${GREEN}${WEBP_QUALITY}${NC}"
echo -e "Method:       ${GREEN}6 (max effort)${NC}"
echo -e "Metadata:     ${GREEN}stripped${NC}"
echo ""

total=0
replaced=0
skipped=0
failed=0
total_saved=0

is_reserved_icon() {
    local name
    name=$(basename "$1")
    [[ "$name" == favicon* ]] || [[ "$name" == apple-touch-icon* ]] || [[ "$name" == android-chrome* ]]
}

while IFS= read -r -d '' webp_file; do
    is_reserved_icon "$webp_file" && continue
    total=$((total + 1))
    relative="${webp_file#$PROJECT_ROOT/}"
    tmp_file="${webp_file%.webp}.recompress.webp"

    ok=1
    if [ "$WEBP_TOOL" = "cwebp" ]; then
        cwebp -q "$WEBP_QUALITY" -m 6 -metadata none "$webp_file" -o "$tmp_file" 2>/dev/null && ok=0
    elif [ "$WEBP_TOOL" = "magick" ]; then
        magick "$webp_file" -quality "$WEBP_QUALITY" -strip -define webp:method=6 "$tmp_file" 2>/dev/null && ok=0
    else
        convert "$webp_file" -quality "$WEBP_QUALITY" -strip -define webp:method=6 "$tmp_file" 2>/dev/null && ok=0
    fi

    if [ $ok -ne 0 ] || [ ! -f "$tmp_file" ]; then
        rm -f "$tmp_file"
        echo -e "${RED}✗${NC} Failed: $relative"
        failed=$((failed + 1))
        continue
    fi

    orig=$(wc -c < "$webp_file")
    new=$(wc -c < "$tmp_file")

    if [ "$new" -lt "$orig" ]; then
        saved=$((orig - new))
        total_saved=$((total_saved + saved))
        mv "$tmp_file" "$webp_file"
        echo -e "${CYAN}↓${NC} $relative — ${orig}B → ${new}B (saved ${saved}B)"
        replaced=$((replaced + 1))
    else
        rm -f "$tmp_file"
        echo -e "${GREEN}~${NC} $relative — already optimal"
        skipped=$((skipped + 1))
    fi
done < <(find "$IMAGE_DIR" -type f -iname "*.webp" -print0)

echo ""
echo -e "${BLUE}=================================${NC}"
echo -e "${BLUE}Summary${NC}"
echo -e "${BLUE}=================================${NC}"
echo -e "Total WebP files: ${total}"
echo -e "Replaced:         ${GREEN}${replaced}${NC}"
echo -e "Already optimal:  ${GREEN}${skipped}${NC}"
if [ "$failed" -gt 0 ]; then
    echo -e "Failed:           ${RED}${failed}${NC}"
fi
if [ "$total_saved" -gt 0 ]; then
    echo -e "Total saved:      ${GREEN}${total_saved}B${NC}"
fi
echo ""

if [ "$replaced" -gt 0 ]; then
    echo -e "${YELLOW}Next steps:${NC}"
    echo -e "  git add static/images"
    echo -e "  git commit"
else
    echo -e "${BLUE}All WebP files are already at optimal compression.${NC}"
fi
