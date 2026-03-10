# Sprint 002: Related Posts

## Overview

This sprint adds a "If you enjoyed this post, you might also enjoy..." section to the bottom of every blog post, showing up to 3 recommended posts scored by tag and category overlap. Recommendations are computed at Hugo build time using Hugo's native Related Pages API — zero JavaScript required.

Hugo's `.Site.RegularPages.Related .` function is already built into v0.155.1 and scores pages by shared taxonomy. We configure the scoring weights in `hugo.toml` (categories weighted higher than tags, since categories are broader signals), then create a lightweight `related-posts.html` partial that renders the top 3 results. The partial is included in `single.html` after the post content and before the prev/next navigation.

This is a pure build-time feature: no JSON index, no client-side fetch, no JavaScript. The blog is a Hugo static site and this approach leverages the platform's strengths. The "scroll to bottom" lazy-loading alternative was evaluated and rejected — it adds complexity without meaningful user benefit for a personal blog.

## Use Cases

1. **Reader finishes an AI post**: Sees 3 related posts with category "AI" and overlapping tags — discovers related content without going back to the post list.
2. **Reader lands on an older post via search**: Related posts surface newer relevant content the reader might have missed.
3. **Post has no overlapping taxonomy**: Section is hidden entirely — no empty containers or placeholder text.
4. **Post has only 1-2 related posts**: Section shows exactly those — no padding with unrelated posts.

## Architecture

```
hugo.toml
  └── [related] config: categories (weight 100) + tags (weight 80) + date (weight 10)
      Threshold: 20 (prefer recall — show something rather than nothing)

single.html (modified)
  └── After {{ .Content }}, inside {{ if eq .Section "posts" }}
      └── {{ partial "related-posts.html" . }}
          └── .Site.RegularPages.Related . | first 3
              └── Renders each as a compact card: thumbnail + title + description

style.css (appended)
  └── .related-posts section styles (grid, card, responsive)
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

  [[related.indices]]
    name = "date"
    weight = 10
```

Notes:
- `includeNewer = true`: newer posts can be recommended from older ones
- `threshold = 20`: low threshold; prefer showing 3 posts over showing none
- `toLower = true`: normalizes tag/category case for matching
- Date as a tertiary tie-breaker (prefer recency when scores are equal)

### Partial: `related-posts.html`

```gotemplate
{{/* related-posts.html
  Shows up to 3 related posts scored by category + tag overlap.
  Must not be wrapped in data-pagefind-body — these are navigation links, not post content.
*/}}
{{- $related := where (.Site.RegularPages.Related .) "Section" "posts" | first 3 -}}
{{- if $related -}}
  <section class="related-posts">
    <h2 class="related-posts-heading">If you enjoyed this post, you might also enjoy…</h2>
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
          </div>
        </article>
      {{- end -}}
    </div>
  </section>
{{- end -}}
```

### CSS additions (`style.css`)

Append to end of file:

```css
/* Related Posts */
.related-posts {
  margin-top: 3rem;
  padding-top: 2rem;
  border-top: 1px solid var(--border-color, #2a2a3a);
}

.related-posts-heading {
  font-size: 1.1rem;
  font-weight: 600;
  margin-bottom: 1.5rem;
  color: var(--text-muted, #9999bb);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.related-posts-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1.5rem;
}

.related-post-card {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.related-post-image-link {
  display: block;
  border-radius: 6px;
  overflow: hidden;
  aspect-ratio: 16/9;
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
  flex: 1;
}

.related-post-title {
  font-size: 0.95rem;
  font-weight: 600;
  line-height: 1.35;
  margin-bottom: 0.4rem;
}

.related-post-title a {
  color: inherit;
  text-decoration: none;
}

.related-post-title a:hover {
  color: var(--accent-color, #5b8ee8);
}

.related-post-excerpt {
  font-size: 0.8rem;
  color: var(--text-muted, #9999bb);
  line-height: 1.5;
  margin: 0;
}

/* Related posts responsive */
@media (max-width: 768px) {
  .related-posts-grid {
    grid-template-columns: 1fr;
    gap: 1.25rem;
  }

  .related-post-card {
    flex-direction: row;
    gap: 0.75rem;
  }

  .related-post-image-link {
    flex-shrink: 0;
    width: 100px;
    aspect-ratio: 4/3;
  }
}
```

## Implementation Plan

### P0: Must Ship

**Files:**
- `hugo.toml` — add `[related]` config block
- `themes/coreydaley-dev/layouts/partials/related-posts.html` — create new partial
- `themes/coreydaley-dev/layouts/_default/single.html` — include partial
- `themes/coreydaley-dev/assets/css/style.css` — append responsive grid CSS

**Tasks:**
- [ ] Add `[related]` config to `hugo.toml` (categories weight 100, tags weight 80, date weight 10, threshold 20, toLower true, includeNewer true)
- [ ] Create `themes/coreydaley-dev/layouts/partials/related-posts.html` with Related API call + card grid markup
- [ ] Include `{{ partial "related-posts.html" . }}` in `single.html` inside the `{{ if eq .Section "posts" }}` block, before `{{ partial "share-buttons.html" . }}`
- [ ] Append related posts CSS to `themes/coreydaley-dev/assets/css/style.css`
- [ ] Run `hugo server -D` and spot-check 5+ posts: verify related posts appear, are relevant, and current post never appears in its own list
- [ ] Verify edge cases: post with 0 shared taxonomy (confirm section hidden), post with 1-2 matches (confirm only those shown)
- [ ] Verify `data-pagefind-body` does NOT wrap the related posts section (confirm in browser dev tools)
- [ ] Run `hugo --minify` — confirm no build errors

### P1: Ship If Capacity Allows

- [ ] Spot-check that related posts look reasonable across 3+ different posts (not just always pulling the same 3 for everything)
- [ ] Verify mobile layout (single-column stacked cards) renders cleanly

### Deferred

- **Date display on cards** — not in scope; the card shows title + excerpt; date adds noise for a "you might like" context
- **"Read more" link** — title is already a link; a separate CTA is redundant at this card size
- **Tags display on cards** — adds visual complexity; the heading already signals "related by taxonomy"
- **Pagefind-aware exclusion of recommendations from search** — already handled by NOT wrapping in `data-pagefind-body`
- **A/B testing threshold values** — premature for a personal blog at this scale

## Files Summary

| File | Action | Purpose |
|------|--------|---------|
| `hugo.toml` | Modify | Add `[related]` config with weights |
| `themes/coreydaley-dev/layouts/partials/related-posts.html` | Create | Related posts partial — card grid |
| `themes/coreydaley-dev/layouts/_default/single.html` | Modify | Include related-posts partial in post footer |
| `themes/coreydaley-dev/assets/css/style.css` | Modify | Append related posts grid + responsive CSS |

## Definition of Done

- [ ] `[related]` config exists in `hugo.toml` with categories, tags, and date indices
- [ ] `related-posts.html` partial exists in `themes/coreydaley-dev/layouts/partials/`
- [ ] Related posts section appears on all single post pages in the `posts` section
- [ ] Up to 3 posts are shown; fewer if fewer qualify; section hidden if 0 qualify
- [ ] The current post never appears in its own related list
- [ ] Each card: title (linked) + thumbnail image (if post has one) + truncated description
- [ ] `data-pagefind-body` does NOT wrap the related posts section
- [ ] Section renders on both desktop (3-column grid) and mobile (stacked cards or row layout)
- [ ] `hugo --minify` completes without errors
- [ ] `hugo server -D` live preview correct
- [ ] AGENTS.md updated to note that `[related]` config drives recommendations

## Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Hugo Related API includes current post in results | Low | High | Hugo explicitly excludes the current page; verify in dev |
| `threshold = 20` is too low, shows unrelated posts | Medium | Medium | Spot-check results; bump threshold to 50 if needed |
| `threshold = 20` is too high, shows 0 posts for most posts | Low | Medium | Start at 20; the blog has rich tag overlap between posts |
| CSS variable names don't match theme | Low | Medium | Read existing variables from style.css before committing |
| Pagefind indexes related post content via partial | Low | Medium | Partial renders outside `data-pagefind-body` by design; verify after build |

## Security Considerations

- No new inputs, APIs, or trust boundaries
- No user data, no JavaScript, no server-side processing
- Hugo Related API reads only build-time frontmatter — no injection risk
- Image `src` values come from `.RelPermalink` (Hugo-generated absolute paths) — no user-supplied data rendered into HTML

## Observability & Rollback

- **Post-ship verification**: `hugo server -D`, view any 5 posts, confirm "If you enjoyed this post..." section appears with 1-3 related post cards; verify the section is absent if 0 related posts exist
- **Build output check**: `grep -r "related-posts" public/posts/` — should appear in all published post HTML files
- **Rollback**: Remove the `{{ partial "related-posts.html" . }}` line from `single.html` and remove the `[related]` block from `hugo.toml`. CSS can stay (orphaned styles have zero user-facing impact). One-commit revert.

## Documentation

- [ ] Update AGENTS.md with a note that `[related]` config in `hugo.toml` drives the scoring weights for the related posts feature

## Dependencies

- Sprint 001 (completed) — leaf bundle architecture is a prerequisite for the `.Resources.GetMatch` calls in the related posts partial

## Open Questions

1. **Threshold**: Start at 20 (prefer recall) or 50 (prefer precision)? Will confirm after Phase 4 interview.
2. **Heading text**: "If you enjoyed this post, you might also enjoy…" — subject to user preference.
3. **Placement**: Before or after `share-buttons`? Logically "before" feels right (recommendations → share → nav); will confirm in interview.
