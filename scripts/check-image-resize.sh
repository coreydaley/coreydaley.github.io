#!/bin/bash
# Created by: Claude Code (Claude Sonnet 4.5)
# Date: 2026-02-14T12:30:00-05:00

echo "Running make resize-images..."
make resize-images

# Check if there are any unstaged changes after running make resize-images
if ! git diff --quiet; then
    echo ""
    echo "❌ ERROR: make resize-images produced changes that are not staged."
    echo ""
    echo "Modified files:"
    git status --short
    echo ""
    echo "Please review and stage these changes, then commit again."
    exit 1
fi

echo "✅ No image resizing needed - proceeding with commit"
exit 0
