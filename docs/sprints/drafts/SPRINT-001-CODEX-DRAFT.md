# Sprint 001 (Codex Draft): Co-located Page Bundles with Year/Month Organization

## Sprint Goal

Reorganize blog posts and their images so each post is a Hugo **leaf bundle** at:

`content/posts/YYYY/MM/<slug>/index.md`

…with all post-specific images stored alongside `index.md`, while preserving old URLs via Hugo `aliases` redirects (GitHub Pages compatible).

## Why We’re Doing This

The current flat layout (`content/posts/*.md` + `static/images/posts/*`) is already painful at ~20 posts:

- There’s no reliable filesystem relationship between a post and its images.
- Agents can’t infer image ownership or safely add multiple images.
- Image naming is inconsistent, so discoverability and reuse are error-prone.

This sprint makes the content tree self-describing: “open the post folder, see the post + its assets.”

## Proposed Decisions (to resolve Sprint 001 Open Questions)

### 1) Image referencing approach (recommended)

Use **bundle-relative** `src` values for post-embedded images:

- In Markdown: `{{< figure-float src="hero.webp" alt="..." >}}`
- For additional images: `src="diagram.webp"`, `src="screenshot-run.webp"`, etc.

This keeps image references stable after migration and makes “co-located assets” actually usable.

### 2) `image` frontmatter (og:image / twitter:image)

Keep `image` as a **valid WebP URL** but allow bundle-local ergonomics:

- Authoring format (recommended): `image = "hero.webp"`
- Theme responsibility: resolve bundle resources to an absolute URL for meta tags and post listings.

This avoids hand-writing `/posts/YYYY/MM/slug/hero.webp` in every post and keeps authoring consistent with co-location.

### 3) Thumbnails

Keep the existing `thumbs/` convention but move it into each bundle:

- `content/posts/YYYY/MM/slug/thumbs/hero.webp`

Either generate thumbs via `scripts/optimize-images.sh` (updated) or via Hugo image processing in templates. Recommendation: prefer Hugo processing in templates if it’s reliable for WebP in our pinned Hugo version; otherwise keep the script as the source of truth.

## Scope (What Changes)

### Content migration

- Migrate all published posts from `content/posts/<slug>.md` to bundles.
- Add `aliases = ["/posts/<slug>/"]` in each migrated post’s frontmatter.
- Update all `figure-float` / `figure-block` usages to bundle-relative paths.
- Ensure all referenced `src` paths point to **WebP** (not PNG/JPG), since originals are intentionally not deployed.

### Image migration

- Move each post’s images from `static/images/posts/` into its bundle directory.
- Move or regenerate `thumbs/` into each bundle (depending on the chosen thumbnail strategy).
- Leave truly global images in `static/images/` (favicons, cover, avatars, etc.).

### Theme support (must happen early)

The current theme assumes `Params.image` lives under `/images/posts/` and derives thumbs from that. After migration, post listing and meta tags must support bundle-based images.

Required theme behaviors:

- If `.Params.image` is an absolute site path (starts with `/`), keep existing behavior.
- If `.Params.image` is bundle-relative (e.g., `"hero.webp"`), resolve it via `.Resources.GetMatch` and:
  - Use the resolved resource for `og:image` / `twitter:image`.
  - Use a thumb (existing `thumbs/` resource or a Hugo-generated resize) for the post list.

### Script support

Update scripts so the “happy path” matches the new structure:

- `scripts/generate-post-image.py` should generate the hero image into the target bundle directory and insert:
  - `image = "hero.webp"` (or equivalent)
  - `{{< figure-float src="hero.webp" ... >}}`
- `scripts/optimize-images.sh` should be able to optimize images inside `content/posts/**` bundles (and not just `static/images`).

## Execution Plan (Suggested Order)

1. **Theme: dual-support images**
   - Make meta tags (`themes/coreydaley-dev/layouts/_default/baseof.html`) and post listing thumbs (`themes/coreydaley-dev/layouts/partials/post-list.html`) work for both:
     - Old: `/images/posts/...`
     - New: bundle-relative `image = "hero.webp"`
2. **Scripts: bundle-aware**
   - Extend `optimize-images.sh` to process bundle images (and optionally create bundle `thumbs/`).
   - Update `generate-post-image.py` to target bundles and use bundle-relative references.
3. **Pilot migrate 1 post**
   - Choose a “simple” post with a single hero image.
   - Migrate content + image + aliases, verify redirects and thumbnails.
4. **Migrate remaining posts**
   - Batch migrate all posts and all referenced images.
   - Validate that no Markdown references point to `static/images/posts/`.
5. **Update conventions**
   - Update `AGENTS.md` to reflect the new post + image workflow.
   - Document “how to add images” in a bundle-first world (relative references, where thumbs live, and when to run optimization).
6. **Verification pass**
   - Local `hugo server -D` and `hugo --minify` succeed.
   - Pagefind indexing still works (CI behavior unchanged).

## Acceptance Criteria (Sprint 001 Success)

- Every post is a leaf bundle at `content/posts/YYYY/MM/<slug>/index.md`.
- Post-specific images live inside the same bundle directory.
- Old `/posts/<slug>/` redirects to `/posts/YYYY/MM/<slug>/` using Hugo `aliases`.
- `image` frontmatter remains valid for social previews and post listing thumbnails.
- `scripts/optimize-images.sh` still works (now includes bundle directories).
- Hugo build succeeds; Pagefind indexing continues to work without CI redesign.

## Verification Checklist

- `hugo server -D` runs without errors.
- Visit at least 3 old URLs (including the attractor post) and confirm redirect.
- Confirm every post renders all images (hero + embedded).
- Confirm post list shows thumbnails for migrated posts.
- `hugo --minify` produces a clean `public/` with expected post and image URLs.
- Run the image optimizer against a migrated bundle and verify it creates/updates WebPs and thumbs as intended.

## Risks & Mitigations

- **Theme coupling to `/images/posts/`**: mitigate by implementing dual support before content migration.
- **WebP-only deployment + PNG `src` references**: mitigate by converting all `src` references to `.webp` during migration.
- **Bundle resource URL assumptions**: mitigate with a pilot post migration and confirm URL output + meta tags.
- **Script complexity creep**: mitigate by keeping scripts backward-compatible and adding one clear “bundle mode” path.

## Out of Scope (for Sprint 001)

- Rewriting the entire image pipeline to only use Hugo image processing (unless it proves trivial).
- Changing CI behavior beyond what’s required to keep Pagefind indexing working.
- Reworking taxonomy structure, content voice, or theme styling unrelated to image/bundle support.

