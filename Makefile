# Created by: Claude Code (Claude Sonnet 4.5)
# Date: 2026-02-08T14:30:00-05:00

.PHONY: help build serve clean purgecss pagefind build-search build-purge build-all install dev restore clean-all

# Default target
help:
	@echo "Available commands:"
	@echo "  make install      - Install npm dependencies"
	@echo "  make dev          - Start Hugo development server with drafts"
	@echo "  make serve        - Start Hugo development server"
	@echo "  make build        - Build Hugo site to public/"
	@echo "  make pagefind     - Run Pagefind to index site for search"
	@echo "  make purgecss     - Run PurgeCSS to remove unused CSS"
	@echo "  make build-search - Build Hugo site and run Pagefind"
	@echo "  make build-purge  - Build Hugo site and run PurgeCSS"
	@echo "  make build-all    - Build, Pagefind, and PurgeCSS (production)"
	@echo "  make restore      - Restore original CSS from backup"
	@echo "  make clean        - Clean generated files"
	@echo "  make clean-all    - Clean all generated files including backups"

# Install dependencies
install:
	@echo "Installing npm dependencies..."
	npm install
	@echo "Dependencies installed!"

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
	npx pagefind --source "public"
	@echo "Pagefind indexing complete!"

# Run PurgeCSS to remove unused CSS
purgecss:
	@echo "Running PurgeCSS to remove unused CSS..."
	@if [ ! -d "public" ]; then \
		echo "Error: public/ directory not found. Run 'make build' first."; \
		exit 1; \
	fi
	@# Create backup of original CSS
	@if [ -f "themes/coreydaley-dev/static/css/style.css" ]; then \
		cp themes/coreydaley-dev/static/css/style.css themes/coreydaley-dev/static/css/style.css.backup; \
		echo "Backup created: style.css.backup"; \
	fi
	@# Run PurgeCSS
	npx purgecss --config purgecss.config.js --output themes/coreydaley-dev/static/css/
	@echo "PurgeCSS complete! Original CSS backed up to style.css.backup"
	@# Show size comparison
	@echo ""
	@echo "Size comparison:"
	@if [ -f "themes/coreydaley-dev/static/css/style.css.backup" ]; then \
		du -h themes/coreydaley-dev/static/css/style.css.backup | awk '{print "  Original: " $$1}'; \
	fi
	@du -h themes/coreydaley-dev/static/css/style.css | awk '{print "  Purged:   " $$1}'

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
	@if [ -f "themes/coreydaley-dev/static/css/style.css.backup" ]; then \
		cp themes/coreydaley-dev/static/css/style.css.backup themes/coreydaley-dev/static/css/style.css; \
		echo "CSS restored from backup"; \
	else \
		echo "No backup file found"; \
	fi

# Clean generated files
clean:
	@echo "Cleaning generated files..."
	rm -rf public/
	rm -rf resources/
	@echo "Clean complete!"

# Clean including backup files
clean-all: clean
	@echo "Removing CSS backups..."
	rm -f themes/coreydaley-dev/static/css/*.backup
	@echo "All clean!"
