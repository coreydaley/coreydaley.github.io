.PHONY: help build serve clean purgecss pagefind build-search build-purge build-all install dev restore clean-all optimize-images recompress-images format pre-commit

# Default target
help:
	@echo "Available commands:"
	@echo "  make install      - Install npm dependencies"
	@echo "  make pre-commit   - Install pre-commit hooks"
	@echo "  make dev          - Start Hugo development server with drafts"
	@echo "  make serve        - Start Hugo development server"
	@echo "  make build        - Build Hugo site to public/"
	@echo "  make pagefind     - Run Pagefind to index site for search"
	@echo "  make purgecss     - Run PurgeCSS to remove unused CSS"
	@echo "  make build-search - Build Hugo site and run Pagefind"
	@echo "  make build-purge  - Build Hugo site and run PurgeCSS"
	@echo "  make build-all    - Build, Pagefind, and PurgeCSS (production)"
	@echo "  make restore      - Restore original CSS from backup"
	@echo "  make optimize-images - Resize and convert images in static/images/ to WebP"
	@echo "  make recompress-images - Re-encode existing WebP files with best settings (one-time)"
	@echo "  make format       - Format templates, CSS, and JS with Prettier"
	@echo "  make clean        - Clean generated files"
	@echo "  make clean-all    - Clean all generated files including backups"

# Install dependencies
install:
	@echo "Installing npm dependencies..."
	npm install
	@echo "Dependencies installed!"

# Install pre-commit hooks
pre-commit:
	@echo "Installing pre-commit hooks..."
	pre-commit install
	@echo "Pre-commit hooks installed!"

# Start development server with drafts
dev:
	@echo "Starting Hugo development server with drafts..."
	hugo server -D

# Start development server
serve:
	@echo "Starting Hugo development server..."
	hugo server

# Build Hugo site
build:
	@echo "Building Hugo site..."
	hugo --minify
	@echo "Site built to public/"

# Run Pagefind to index site for search
pagefind:
	@echo "Running Pagefind to index site..."
	@if [ ! -d "public" ]; then \
		echo "Error: public/ directory not found. Run 'make build' first."; \
		exit 1; \
	fi
	npx pagefind --site "public"
	@echo "Pagefind indexing complete!"

# Run PurgeCSS to remove unused CSS
purgecss:
	@echo "Running PurgeCSS to remove unused CSS..."
	@if [ ! -d "public" ]; then \
		echo "Error: public/ directory not found. Run 'make build' first."; \
		exit 1; \
	fi
	@# Create backup of original CSS
	@if [ -f "themes/coreydaley-dev/assets/css/style.css" ]; then \
		cp themes/coreydaley-dev/assets/css/style.css themes/coreydaley-dev/assets/css/style.css.backup; \
		echo "Backup created: style.css.backup"; \
	fi
	@# Run PurgeCSS
	npx purgecss --config purgecss.config.js --output themes/coreydaley-dev/assets/css/
	@echo "PurgeCSS complete! Original CSS backed up to style.css.backup"
	@# Show size comparison
	@echo ""
	@echo "Size comparison:"
	@if [ -f "themes/coreydaley-dev/assets/css/style.css.backup" ]; then \
		du -h themes/coreydaley-dev/assets/css/style.css.backup | awk '{print "  Original: " $$1}'; \
	fi
	@du -h themes/coreydaley-dev/assets/css/style.css | awk '{print "  Purged:   " $$1}'

# Build and index with Pagefind
build-search: build pagefind
	@echo ""
	@echo "Build and Pagefind indexing complete!"
	@echo "Run 'make serve' to preview the site with search."

# Build and purge in one command
build-purge: build purgecss
	@echo ""
	@echo "Build and PurgeCSS complete!"
	@echo "Run 'make serve' to preview the optimized site."

# Full production build: Hugo -> Pagefind -> PurgeCSS
build-all: build pagefind purgecss
	@echo ""
	@echo "==================================="
	@echo "Production build complete!"
	@echo "==================================="
	@echo "✓ Hugo site built"
	@echo "✓ Pagefind search indexed"
	@echo "✓ CSS optimized with PurgeCSS"
	@echo ""
	@echo "Run 'make serve' to preview the production-ready site."

# Restore original CSS from backup
restore:
	@if [ -f "themes/coreydaley-dev/assets/css/style.css.backup" ]; then \
		cp themes/coreydaley-dev/assets/css/style.css.backup themes/coreydaley-dev/assets/css/style.css; \
		echo "CSS restored from backup"; \
	else \
		echo "No backup file found"; \
	fi

# Resize images to max 512px width and convert to WebP
optimize-images:
	@./scripts/optimize-images.sh

# Re-encode all existing WebP files with best compression settings (one-time operation).
# Not run automatically — use this explicitly when you want to squeeze existing images.
# Run `git add static/images` afterward to stage the results.
recompress-images:
	@./scripts/recompress-images.sh

# Format Hugo templates, CSS, and JS with Prettier
format:
	@echo "Formatting Hugo templates, CSS, and JS with Prettier..."
	npx prettier --write "themes/coreydaley-dev/layouts/**/*.html"
	npx prettier --write "themes/coreydaley-dev/assets/css/**/*.css"
	npx prettier --write "themes/coreydaley-dev/assets/js/**/*.js"
	@echo "Formatting complete!"

# Clean generated files
clean:
	@echo "Cleaning generated files..."
	rm -rf public/
	rm -rf resources/
	@echo "Clean complete!"

# Clean including backup files
clean-all: clean
	@echo "Removing CSS backups..."
	rm -f themes/coreydaley-dev/assets/css/*.backup
	@echo "All clean!"
