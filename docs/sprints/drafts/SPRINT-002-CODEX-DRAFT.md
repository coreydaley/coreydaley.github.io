# Sprint 002 (Codex Draft): Related Posts via Hugo Taxonomy Similarity

## Sprint Goal

Add a post-footer recommendations section that shows up to 3 related posts on each blog post page, ranked by overlapping tags and categories, with zero JavaScript and no impact on Pagefind indexing.

## Decision: Build-Time vs Client-Side

Use Hugo's build-time Related Pages API.

Why this is the right choice for this repo:

- Directly matches the requested ranking model (tags + categories overlap).
- No client-side fetch/index plumbing, no scroll observers, no hydration edge cases.
- Better SEO and predictable HTML output on GitHub Pages.
- Lower maintenance for a static personal site with a modest post volume.

Client-side JSON/index loading is intentionally out of scope for this sprint.

## Scope

### In Scope

- Configure Hugo related-content weights in `hugo.toml`.
- Add a new `related-posts.html` partial under theme partials.
- Inject the related-posts section in single post layout before prev/next navigation.
- Add styling in `themes/coreydaley-dev/assets/css/style.css`.
- Graceful behavior for 0, 1, 2, or 3 matches.
- Keep section outside `data-pagefind-body` so recommendations are not indexed as body content.

### Out of Scope

- JavaScript lazy-loading or scroll-triggered fetching.
- Personalized/session-based recommendations.
- Cross-content-type recommendations (only `Section == "posts"`).

## Use Cases

1. A reader finishes a post and sees "If you enjoyed this post, you might also enjoy..." with 3 relevant cards.
2. A post with sparse taxonomy gets 1-2 recommendations instead of forced filler.
3. A post with no meaningful overlap shows no recommendation section.
4. A post without a featured image still renders a clean text-first recommendation card.

## Architecture

### Related Scoring Source

Hugo computes related pages at build time from configured indices.

Planned config in `hugo.toml`:

- `toLower = true` for stable taxonomy matching.
- Weighted indices for `categories` and `tags`.
- `threshold` tuned so weak/noisy matches are filtered.

Recommended initial weights:

- `categories`: `100` (broader topical grouping)
- `tags`: `80` (more specific, often higher-cardinality)

### Template Integration Point

`themes/coreydaley-dev/layouts/_default/single.html`

- Keep article body as-is.
- Insert related-posts partial in `<footer class="post-footer">` before `.post-navigation`.
- Guard to posts only (`.Section == "posts"`).

This keeps recommendations visually in the post footer while remaining outside the existing `data-pagefind-body` container.

### Rendering Strategy in Partial

`themes/coreydaley-dev/layouts/partials/related-posts.html`

The partial will:

1. Compute related pages from current page context.
2. Restrict to published posts and exclude current page explicitly.
3. Truncate to 3.
4. Resolve image/thumbnail using the same dual-path logic already used in `post-list.html`:
   - Legacy absolute `/images/posts/...`
   - Bundle-relative `image = "hero.webp"` with optional `thumbs/hero.webp`
5. Render each card with:
   - Thumbnail (when available)
   - Linked title
   - Description (fallback to truncated summary)
   - Tags list
6. Render nothing if there are zero results.

## Implementation Plan

### Phase 1: Hugo Related Config

Files:

- `hugo.toml`

Tasks:

- [ ] Add `[related]` block with `threshold`, `toLower`, and weighted indices.
- [ ] Keep config minimal and taxonomy-focused (`categories`, `tags` only).

### Phase 2: New Partial

Files:

- `themes/coreydaley-dev/layouts/partials/related-posts.html` (new)

Tasks:

- [ ] Implement related page query + filtering + top-3 selection.
- [ ] Exclude self robustly.
- [ ] Reuse proven thumbnail/image resolution pattern from `post-list.html`.
- [ ] Render heading exactly:
  - `If you enjoyed this post, you might also enjoy...`
- [ ] Render card metadata (title, description/summary, tags).
- [ ] Hide section entirely when no related posts are found.

### Phase 3: Inject Partial into Post Template

Files:

- `themes/coreydaley-dev/layouts/_default/single.html`

Tasks:

- [ ] Call partial only for post pages.
- [ ] Place it before `.post-navigation` in post footer.
- [ ] Confirm no `data-pagefind-body` attribute is added to related section.

### Phase 4: Styling

Files:

- `themes/coreydaley-dev/assets/css/style.css`

Tasks:

- [ ] Add a related-posts section style block consistent with existing card language (rounded corners, dashed separators, display font for headings, taxonomy styling compatibility).
- [ ] Build responsive grid:
  - Desktop: 3 columns when possible.
  - Tablet: 2 columns.
  - Mobile: 1 column.
- [ ] Ensure cards handle missing image gracefully.

### Phase 5: Verification

Tasks:

- [ ] Run `hugo server -D` and spot-check at least 5 posts with different taxonomy density.
- [ ] Validate edge cases:
  - 0 overlap: section hidden.
  - 1-2 overlap: show available count.
  - No tags/categories on source post: no crash, no malformed output.
  - Current page not present in recommendations.
- [ ] Run `hugo --minify`.
- [ ] Verify generated HTML in `public/` does not include `data-pagefind-body` on related section.
- [ ] Smoke-check that existing post list thumbnails and social image behavior remain unchanged.

## Files Summary

| File | Change Type | Purpose |
|---|---|---|
| `hugo.toml` | Modify | Add related-content scoring config |
| `themes/coreydaley-dev/layouts/partials/related-posts.html` | Create | Render related post cards |
| `themes/coreydaley-dev/layouts/_default/single.html` | Modify | Inject related posts section before post navigation |
| `themes/coreydaley-dev/assets/css/style.css` | Modify | Style related-posts section and responsive layout |

## Definition of Done

- Every blog post page can show up to 3 related post cards directly before prev/next navigation.
- Ranking is based on shared tags/categories via Hugo Related Pages configuration.
- Section heading is exactly: "If you enjoyed this post, you might also enjoy..."
- Each card includes title, description/summary, tags, and thumbnail when available.
- Section is hidden when no related posts are found.
- No JavaScript is introduced.
- Build and dev server run cleanly.
- No Pagefind indexing regression caused by related-posts markup placement.

## Risks and Mitigations

- Risk: Overly strict `threshold` yields no recommendations on many posts.
  - Mitigation: start with conservative threshold; tune after spot checks.
- Risk: Overly loose threshold yields weak recommendations.
  - Mitigation: prioritize categories in weighting; validate with real post samples.
- Risk: Image logic drift between list cards and related cards.
  - Mitigation: copy the existing dual-path resolution approach from `post-list.html` exactly.
- Risk: Taxonomy inconsistencies in content reduce quality.
  - Mitigation: capture taxonomy cleanup as follow-up if needed (outside this sprint).

## Security Considerations

- Pure build-time rendering from trusted frontmatter and Hugo content objects.
- No runtime API calls, no client-side injection surface, no new third-party dependencies.
- No change to analytics or tracking boundaries.

## Open Questions to Resolve During Implementation

1. Initial `threshold` value in `[related]` after first verification pass.
2. Whether to show categories in cards or keep metadata to tags only for visual simplicity.
3. Whether to include post date in cards if visual density still feels balanced.
