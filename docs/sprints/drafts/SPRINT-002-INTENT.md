# Sprint 002 Intent: Related Posts

## Seed

> Let's build a feature into this blog that shows up to 3 recommended blog posts at the bottom of each blog post, it should use the categories and tags that overlap between two posts to determine the recommended posts. Determine whether it would be better to do this at build time or if we should have an index that gets built in json and then the blog posts get loaded dynamically when someone views the page and reads all the way to the bottom, something like, "if you enjoyed this post you might also enjoy ..."

## Context

- **SPRINT-001 completed**: all 23+ posts are proper Hugo leaf bundles at `content/posts/YYYY/MM/slug/index.md`. The architecture is clean and stable.
- **No in-progress sprints**. Clean slate.
- Hugo v0.155.1 extended has native Related Pages API (`where .Site.RegularPages.Related .`) that computes tag/category overlap scores at build time. This is a near-perfect match for the feature request.
- The existing `post-list.html` partial already handles thumbnail resolution for both legacy absolute paths and bundle-relative resources — a lighter `related-posts.html` partial can reuse that image-resolution pattern.
- CSS lives in a single file: `themes/coreydaley-dev/assets/css/style.css`. New styles for the related posts grid should be appended there.

## Recent Sprint Context

**SPRINT-001** (completed 2026-03-07): Migrated all posts to Hugo leaf bundles organized by `content/posts/YYYY/MM/slug/index.md`. Updated 4 theme templates for dual-support (absolute + relative image paths). Updated `optimize-images.sh` and `generate-post-image.py` for bundle-aware operation. Removed `static/images/posts/`. No deferred items.

## Relevant Codebase Areas

| File | Role |
|------|------|
| `themes/coreydaley-dev/layouts/_default/single.html` | Injection point — add related posts partial in post footer |
| `themes/coreydaley-dev/layouts/partials/post-list.html` | Reference implementation for image resolution + post card rendering |
| `themes/coreydaley-dev/assets/css/style.css` | Single CSS file; append related posts grid styles |
| `hugo.toml` | Add `[related]` config block to tune scoring weights |
| `themes/coreydaley-dev/layouts/partials/` | New `related-posts.html` partial goes here |

## Constraints

- Must follow project conventions in CLAUDE.md and AGENTS.md
- No JavaScript unless build-time approach is provably insufficient
- Reuse existing image-resolution pattern from `post-list.html`
- New partial lives in `themes/coreydaley-dev/layouts/partials/` (theme-owned)
- CSS additions append to existing `style.css` — no new files
- Must not affect Pagefind indexing (avoid `data-pagefind-body` on the recommendations section)
- Must degrade gracefully: if fewer than 3 related posts exist, show only what's available; if 0, show nothing

## Success Criteria

- Every single blog post shows up to 3 related post cards immediately after the post content (before the prev/next navigation)
- Related posts are scored by tag + category overlap — more shared taxonomy = higher ranked
- The section has a clear heading: "If you enjoyed this post, you might also enjoy..."
- Each recommendation shows: post thumbnail (if available), title (linked), short description, and tags
- The section is visually consistent with the existing blog design
- Zero JavaScript required

## Verification Strategy

- **Spec**: Hugo Related Pages documentation defines the scoring behavior
- **Build verification**: `hugo server -D` — spot-check 3+ posts and confirm related posts appear, are relevant, and vary per post
- **Edge cases**:
  - Post with 0 overlapping posts → section hidden entirely
  - Post with 1-2 overlapping posts → section shows only those
  - Post with no tags or categories → still works (no panic)
  - The current post itself must not appear in its own recommendations
- **Testing approach**: Manual visual inspection during dev server; grep `public/` to confirm no `data-pagefind-body` on related section

## Uncertainty Assessment

- **Correctness uncertainty**: Low — Hugo Related Pages is well-documented, deterministic, tested at build time
- **Scope uncertainty**: Low — well-defined feature with clear boundaries
- **Architecture uncertainty**: Low — follows existing partial + CSS pattern

## Approaches Considered

| Approach | Pros | Cons | Verdict |
|---|---|---|---|
| **Hugo native Related API (build-time)** | Zero JS; perfect SEO; native taxonomy scoring; near-zero complexity; instant page loads; no fetch latency | Recommendations fixed at build time; can't detect "scrolled to bottom" | **Selected** — the scroll-detection benefit doesn't justify the added complexity; Hugo's Related API does exactly what was asked |
| **JSON index + client-side fetch** | Can lazy-load on scroll; dynamic per session | Requires JS; adds fetch + parse latency; worse SEO; must build/maintain index generation; overkill for a personal blog with <100 posts | Rejected — unnecessary complexity |
| **Pagefind search API (client-side)** | Reuses existing Pagefind index | Pagefind is a keyword search engine, not a similarity ranker; would require heuristics to approximate tag/category scoring; still requires JS | Rejected — wrong tool for the job |

## Open Questions

1. Should the related posts section include date metadata on each card, or just title + image + description?
2. Should the heading text be exactly "If you enjoyed this post, you might also enjoy..." or is there a preferred phrasing?
3. Hugo's Related config has a `threshold` (0-100) — should we prefer precision (fewer but more closely related) or recall (always show 3 even if overlap is loose)?
