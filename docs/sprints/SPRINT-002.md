# Sprint 002: Related Posts

## Overview

This sprint adds a "If you enjoyed this post, you might also enjoy..." section to the bottom of every blog post, showing up to 3 related post cards scored by tag and category overlap. Recommendations are computed at Hugo build time using Hugo's native Related Pages API — zero JavaScript required.

Hugo's `.Site.RegularPages.Related .` function scores pages by shared taxonomy. We configure the scoring weights in `hugo.toml` (categories weighted higher than tags), create a `related-posts.html` partial that renders the top 3 results as cards with thumbnail + title + description + tags, and inject the partial into `single.html` in the post footer — after share buttons, before prev/next navigation.

The build-time approach was selected over client-side JSON/fetch because the blog is a Hugo static site, the taxonomy overlap model fits perfectly into Hugo's Related API, and no JavaScript is required. The "scroll to bottom" lazy-loading alternative was evaluated and rejected: the complexity cost is not justified for a personal blog with ~25 posts.

## Use Cases

1. **Reader finishes an AI post**: Sees 3 related cards with overlapping categories/tags — discovers relevant content without returning to the post list.
2. **Reader lands via search on an older post**: Related posts surface newer content the reader might have missed.
3. **Post has no overlapping taxonomy**: Section is hidden entirely — no empty containers or placeholder text.
4. **Post has 1–2 related posts**: Section shows exactly those — no padding with unrelated content.
5. **Related post has no image**: Card renders cleanly with title + description + tags only — no broken image containers.

## Architecture

```
hugo.toml
  └── [related] config
        categories: weight 100
        tags:       weight 80
        threshold:  20 (prefer recall — always try to show 3)
        toLower:    true
        includeNewer: true

single.html (modified)
  └── <footer class="post-footer">
        {{ partial "share-buttons.html" . }}   ← existing
        {{ partial "related-posts.html" . }}    ← NEW (after share buttons)
        <div class="post-navigation">           ← existing
          Prev / Next
        </div>

related-posts.html (new partial)
  └── .Site.RegularPages.Related .
        | where "Section" "posts"
        | where "Permalink" "ne" .Permalink   ← explicit self-exclusion
        | first 3
      → Renders each as a card:
          thumbnail (bundle-relative or absolute legacy path)
          linked title
          truncated description
          tags list

style.css (appended)
  └── .related-posts, .related-posts-grid, .related-post-card
        desktop: 3-column grid
        mobile (<768px): 1-column stacked
```

### Hugo Related Config (`hugo.toml`)

```toml
[related]
  includeNewer = true
  threshold = 20
  toLower = true

  [[related.indices]]
    name = "categories"
    weight = 100

  [[related.indices]]
    name = "tags"
    weight = 80
```

Notes:
- `categories` (weight 100): broader topical grouping — primary scoring signal
- `tags` (weight 80): specific, higher-cardinality — secondary signal
- No `date` index: recency bias not requested and could override genuine taxonomy matches
- `threshold = 20`: low threshold; prefer showing 3 loosely related posts over showing nothing
- `includeNewer = true`: newer posts can recommend older ones and vice versa

### Partial: `related-posts.html`

```gotemplate
{{/* Created by: Claude Code (Claude Sonnet 4.6) | Date: 2026-03-10T00:00:00-04:00 */}}
{{/* related-posts.html
  Shows up to 3 related posts scored by category + tag overlap.
  Rendered outside data-pagefind-body — these are navigation links, not post content.
*/}}
{{- $related := where (.Site.RegularPages.Related .) "Section" "posts" -}}
{{- $related = where $related "Permalink" "ne" .Permalink | first 3 -}}
{{- if $related -}}
  <section class="related-posts">
    <h2 class="related-posts-heading">If you enjoyed this post, you might also enjoy...</h2>
    <div class="related-posts-grid">
      {{- range $related -}}
        <article class="related-post-card">
          {{- $imgParam := .Params.image -}}
          {{- if $imgParam -}}
            {{- $img := "" -}}
            {{- if hasPrefix $imgParam "/" -}}
              {{- $img = $imgParam | replaceRE `\.(png|jpe?g)$` ".webp" -}}
            {{- else -}}
              {{- with .Resources.GetMatch (printf "thumbs/%s" $imgParam) -}}
                {{- $img = .RelPermalink -}}
              {{- else -}}
                {{- with .Resources.GetMatch $imgParam -}}{{- $img = .RelPermalink -}}{{- end -}}
              {{- end -}}
            {{- end -}}
            {{- if $img -}}
              <a href="{{ .RelPermalink }}" class="related-post-image-link" tabindex="-1" aria-hidden="true">
                <img src="{{ $img }}" alt="{{ .Title }}" width="400" height="225" loading="lazy" />
              </a>
            {{- end -}}
          {{- end -}}
          <div class="related-post-body">
            <h3 class="related-post-title">
              <a href="{{ .RelPermalink }}">{{ .Title }}</a>
            </h3>
            {{- if .Description -}}
              <p class="related-post-excerpt">{{ .Description | truncate 120 }}</p>
            {{- end -}}
            {{- if .Params.tags -}}
              <div class="related-post-tags">
                {{- range $index, $tag := sort .Params.tags -}}
                  {{- if $index }}, {{ end -}}
                  <a href="{{ "/tags/" | relURL }}{{ $tag | urlize }}" class="taxonomy-link">{{ $tag }}</a>
                {{- end -}}
              </div>
            {{- end -}}
          </div>
        </article>
      {{- end -}}
    </div>
  </section>
{{- end -}}
```

### CSS additions (`style.css`)

Append to end of `themes/coreydaley-dev/assets/css/style.css`:

```css
/* =========================================
   Related Posts
   ========================================= */
.related-posts {
  margin-top: 2.5rem;
  padding-top: 2rem;
  border-top: 1px solid var(--border-color);
}

.related-posts-heading {
  font-family: var(--font-display);
  font-size: 1rem;
  font-weight: 600;
  color: var(--text-secondary);
  text-transform: uppercase;
  letter-spacing: 0.06em;
  margin-bottom: 1.5rem;
}

.related-posts-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1.5rem;
}

.related-post-card {
  display: flex;
  flex-direction: column;
  gap: 0.6rem;
  background: var(--bg-card);
  border-radius: 8px;
  overflow: hidden;
  border: 1px solid var(--border-color);
  transition: box-shadow 0.2s ease;
}

.related-post-card:hover {
  box-shadow: var(--shadow-md);
}

.related-post-image-link {
  display: block;
  aspect-ratio: 16 / 9;
  overflow: hidden;
}

.related-post-image-link img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: opacity 0.2s ease;
}

.related-post-image-link:hover img {
  opacity: 0.85;
}

.related-post-body {
  padding: 0.75rem;
  display: flex;
  flex-direction: column;
  gap: 0.4rem;
  flex: 1;
}

.related-post-title {
  font-size: 0.9rem;
  font-weight: 600;
  line-height: 1.35;
  margin: 0;
}

.related-post-title a {
  color: var(--text-primary);
  text-decoration: none;
}

.related-post-title a:hover {
  color: var(--primary);
}

.related-post-excerpt {
  font-size: 0.78rem;
  color: var(--text-muted);
  line-height: 1.5;
  margin: 0;
}

.related-post-tags {
  font-size: 0.72rem;
  color: var(--text-muted);
  margin-top: auto;
  padding-top: 0.4rem;
}

.related-post-tags .taxonomy-link {
  color: var(--text-muted);
}

.related-post-tags .taxonomy-link:hover {
  color: var(--primary);
}

@media (max-width: 768px) {
  .related-posts-grid {
    grid-template-columns: 1fr;
    gap: 1rem;
  }

  .related-post-card {
    flex-direction: row;
  }

  .related-post-image-link {
    flex-shrink: 0;
    width: 100px;
    aspect-ratio: 4 / 3;
  }
}
```

## Implementation Plan

### P0: Must Ship

**Files:**
- `hugo.toml` — add `[related]` config block
- `themes/coreydaley-dev/layouts/partials/related-posts.html` — create new partial
- `themes/coreydaley-dev/layouts/_default/single.html` — include partial in post footer
- `themes/coreydaley-dev/assets/css/style.css` — append related posts CSS

**Tasks:**
- [ ] Add `[related]` block to `hugo.toml` (categories weight 100, tags weight 80, threshold 20, toLower true, includeNewer true)
- [ ] Create `themes/coreydaley-dev/layouts/partials/related-posts.html` with Related API call, self-exclusion, section filter, image resolution, and tags
- [ ] Modify `themes/coreydaley-dev/layouts/_default/single.html`: inside `<footer class="post-footer">`, call `{{ partial "related-posts.html" . }}` after `{{ partial "share-buttons.html" . }}` and before the `.post-navigation` div
- [ ] Append related posts CSS to `themes/coreydaley-dev/assets/css/style.css` using correct theme CSS variables
- [ ] Run `hugo server -D` — spot-check 5+ posts with varying taxonomy density; verify related posts appear and are topically relevant
- [ ] Verify edge cases: 0 overlap (section hidden), 1–2 matches (shows only those), post without image (card renders cleanly), no tags/categories on source post (no crash)
- [ ] Confirm current post never appears in its own related list
- [ ] Confirm `data-pagefind-body` does NOT wrap the related section (inspect in browser dev tools)
- [ ] Spot-check a post with minimal frontmatter (no image, no description) — confirm card renders cleanly with no empty containers
- [ ] Spot-check at least 3 different source posts and confirm related recommendations are topically coherent (not just any 3 posts)
- [ ] Run `hugo --minify` — confirm no build errors or warnings

### P1: Ship If Capacity Allows

- [ ] Verify mobile layout renders correctly (stacked card with image + body side-by-side)
- [ ] Spot-check that 3 different posts pull distinctly different recommendation sets (not always the same 3)
- [ ] Verify regression: existing post list thumbnails and og:image still correct after changes to `single.html`

### Deferred

- **Date display on cards** — not requested; adds visual noise for a discovery widget
- **2-column tablet breakpoint** — over-engineered for this sidebar layout; can be added later if needed
- **"Read more" CTA per card** — title is already a link; redundant
- **Taxonomy cleanup audit** — if recommendations seem low-quality, a pass through tag consistency would improve results; separate sprint

## Files Summary

| File | Action | Purpose |
|------|--------|---------|
| `hugo.toml` | Modify | Add `[related]` scoring config |
| `themes/coreydaley-dev/layouts/partials/related-posts.html` | Create | Related posts card grid partial |
| `themes/coreydaley-dev/layouts/_default/single.html` | Modify | Inject related-posts partial in post footer |
| `themes/coreydaley-dev/assets/css/style.css` | Modify | Append related posts grid + responsive CSS |

## Definition of Done

- [ ] `[related]` config exists in `hugo.toml` with `categories` and `tags` indices
- [ ] `related-posts.html` partial exists in `themes/coreydaley-dev/layouts/partials/`
- [ ] Related posts section appears on all single post pages in the `posts` section
- [ ] Section appears after the share buttons and before the prev/next navigation
- [ ] Up to 3 related posts shown; fewer if fewer qualify; section hidden if 0 qualify
- [ ] The current post never appears in its own related list (explicit `where "Permalink" "ne" .Permalink`)
- [ ] Each card shows: title (linked), thumbnail (if post has one), truncated description, tags
- [ ] Posts without images render a clean card (no broken image containers)
- [ ] Related post card titles are keyboard-focusable (verify tab navigation reaches linked titles)
- [ ] Spot-check topical coherence on 3+ different source posts — recommendations are meaningfully related, not arbitrary
- [ ] `data-pagefind-body` does NOT wrap the related posts section
- [ ] Section heading is exactly: `If you enjoyed this post, you might also enjoy...`
- [ ] Desktop: 3-column grid; mobile: 1-column stacked
- [ ] CSS uses only existing theme variables (`--primary`, `--text-primary`, `--text-muted`, `--border-color`, `--bg-card`, etc.)
- [ ] `hugo --minify` completes without errors
- [ ] `hugo server -D` live preview works correctly

## Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Placement inside `data-pagefind-body` pollutes Pagefind | Low | High | Inject in `<footer>`, not in `<div data-pagefind-body>`; verify via dev tools |
| `threshold = 20` yields semantically unrelated results | Medium | Medium | Spot-check 5+ posts; bump to 40-60 if needed |
| CSS variables drift (using token that doesn't exist) | Low | Medium | Reference CSS variable list from `:root` block before writing; verified correct names |
| Hugo excludes current page from Related — assumption wrong | Low | Low | Explicit self-exclusion via `where "Permalink" "ne" .Permalink` |
| Related API pulls non-post pages (static pages) | Low | Low | `where "Section" "posts"` filter prevents this |
| Recommendations look semantically weak after launch | Medium | Low | Bump threshold from 20 to 40-60 in `hugo.toml` — one-line config change; re-build and re-check |

## Security Considerations

- No new inputs, APIs, or trust boundaries
- Pure build-time rendering from trusted Hugo frontmatter — no user-supplied data in HTML
- Image `src` values come from `.RelPermalink` (Hugo-generated absolute paths) — no injection surface
- No JavaScript, no client-side fetch, no third-party dependencies added
- No analytics or tracking boundary changes

## Observability & Rollback

- **Post-ship verification**: `hugo server -D`, open 5 different posts, confirm "If you enjoyed this post..." section appears with 1-3 cards; check section absent when 0 related posts; inspect dev tools to confirm section is outside `data-pagefind-body`
- **Build check**: `grep -rn "related-posts" public/posts/ | wc -l` — count should be non-zero
- **Rollback**: Remove the `{{ partial "related-posts.html" . }}` line from `single.html` and remove the `[related]` block from `hugo.toml`. CSS additions are harmless orphaned styles with zero user-facing impact if partial is removed. One-commit revert.

## Documentation

- [ ] Update AGENTS.md to note that `[related]` config in `hugo.toml` controls scoring weights — low priority, can be done post-ship

## Dependencies

- Sprint 001 (completed) — leaf bundle architecture enables `.Resources.GetMatch` thumbnail resolution in the related posts partial

## Open Questions

None — all resolved via interview and competitive drafting.
