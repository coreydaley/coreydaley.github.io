# Sprint 001 Intent: Co-located Page Bundles with Year/Month Organization

## Seed

The current blog post and image organization makes it increasingly hard to find anything,
add images for specific posts, or know what images/content belong to which post.
Reorganize so there is clear correlation between posts and their embedded images.
Add year/month-based organization. URL paths may change but old paths must redirect
via Hugo-native means (no .htaccess; hosted on GitHub Pages).

## Context

### Current State
- 20 posts in flat `content/posts/*.md` with no date-based directory hierarchy
- Images in flat `static/images/posts/` — naming is inconsistent relative to post slugs
  (e.g., `attractor-dot-pipeline-orchestration.md` uses `software-factory.webp`,
  `dot-graph.webp`, `attractor-screenshot-create.webp`, `attractor-screenshot-run.webp`,
  `digraph-dot-graph.webp`)
- `static/images/posts/thumbs/` holds compressed thumb variants
- `scripts/optimize-images.sh` converts PNG/JPG to WebP and creates thumbs/ variants,
  operates on `static/images/posts/`
- `scripts/generate-post-image.py` generates hero images, saves to `static/images/posts/`
- All posts dated between 2026-02 and 2026-03

### Pain Points
1. No visual or filesystem link between a post file and its images
2. Adding multiple images to a post means finding files scattered across a flat pool
3. AI agents have no reliable way to infer which images belong to which post
4. As post count grows, flat directories will become unmanageable

### Hugo Capabilities Relevant Here
- **Leaf bundles**: A directory `content/posts/YYYY/MM/slug/index.md` with images
  alongside is a "leaf bundle" — Hugo serves the post at `/posts/YYYY/MM/slug/` and
  all co-located files are page resources accessible via `.Resources`
- **`aliases` frontmatter**: Hugo generates a static HTML redirect page at each alias
  path (meta-refresh + `<link rel="canonical">`). Works on GitHub Pages. Example:
  `aliases = ["/posts/my-old-slug/"]` in TOML frontmatter.
- **`permalink` config**: `hugo.toml` can configure URL patterns like
  `/:year/:month/:slug/` via `[permalinks]` section

## Relevant Codebase Areas

| Area | Files |
|------|-------|
| Post content | `content/posts/*.md` (20 files) |
| Post images | `static/images/posts/*.{png,webp}` + `thumbs/` subdirs |
| Image scripts | `scripts/optimize-images.sh`, `scripts/generate-post-image.py` |
| Hugo config | `hugo.toml` |
| CI/CD | `.github/workflows/hugo.yml` |
| Project conventions | `AGENTS.md` (via `CLAUDE.md`) |
| Theme layouts | `themes/coreydaley-dev/layouts/` |

## Constraints

- Must follow project conventions in AGENTS.md
- GitHub Pages: no server-side redirects; must use Hugo `aliases`
- Hugo version pinned at v0.155.1 extended (CI + local must match)
- Existing post URLs must redirect to new URLs (aliases on each post)
- `image` frontmatter paths are used for og:image — must remain valid WebP paths
- Image optimization pipeline (`scripts/optimize-images.sh`) must continue to work
- No breaking changes to CI workflow behavior

## Success Criteria

1. Every post lives at `content/posts/YYYY/MM/slug/index.md`
2. Post-specific images live in the same directory as the `index.md`
3. Old `/posts/slug/` URLs redirect to `/posts/YYYY/MM/slug/` via Hugo aliases
4. Scripts updated to operate on bundle directories (or document how to use them)
5. AGENTS.md updated with new conventions for creating posts and adding images
6. Hugo build succeeds with no errors
7. Pagefind re-index still works (CI unchanged)

## Verification Strategy

- `hugo server -D` builds and serves without errors
- Navigating to old URLs redirects to new URLs
- All existing images load correctly at new bundle-relative or absolute paths
- `scripts/optimize-images.sh` runs successfully on a new post bundle
- CI `hugo --minify` build passes

## Uncertainty Assessment

- **Correctness uncertainty: Medium** — Hugo leaf bundle image referencing works two
  ways (page-resource relative paths vs absolute static paths); need to decide which
  and update all existing `figure-float`/`figure-block` shortcode calls accordingly
- **Scope uncertainty: Medium** — 20 posts × multiple images each = moderate migration
  effort; the attractor post alone references 5 images
- **Architecture uncertainty: Low** — Hugo leaf bundles and aliases are well-documented
  stable features

## Open Questions

1. Should images in bundles be referenced with relative paths (Hugo page resources)
   or continue using absolute `/images/posts/...` paths? Relative is cleaner but
   requires changing all shortcode calls; absolute works but loses the co-location
   benefit.
2. Should `static/images/posts/` be deprecated entirely, or should post-agnostic/
   shared images (favicons, cover, avatars) stay there?
3. Should the `thumbs/` subdir convention be preserved inside bundles, or should
   Hugo's built-in image processing replace the shell script?
4. For the hero image generator script, should it auto-detect the bundle directory
   from the post slug and date, or stay manual?
