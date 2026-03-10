# Sprint 002 Merge Notes

## Claude Draft Strengths
- Concrete Hugo template code and CSS for the related-posts partial
- `includeNewer = true` config explicitly decided
- Clean card design: title + thumbnail + description
- Good rollback plan
- Correct threshold (20) from interview

## Claude Draft Weaknesses (from Codex critique)
- **CRITICAL**: Injection point was wrong — placed inside `data-pagefind-body`, which would pollute Pagefind indexing. Must be in `<footer class="post-footer">` before `.post-navigation`.
- Date index (`weight = 10`) adds recency bias not requested by the seed
- No explicit self-exclusion — relied on Hugo behavior assumption
- CSS variables used (`--accent-color`, `--border-color`) don't all exist in theme; `--border-color` exists but `--accent-color` does not
- Heading text used typographic ellipsis `…` instead of `...`

## Codex Draft Strengths
- Correct placement: in post footer before navigation
- Explicit self-exclusion in template query
- `where "Section" "posts"` filter prevents cross-content-type bleed
- Tags on cards adds context and aligns with stated success criteria
- Regression verification: existing thumbnail/og:image behavior stays unaffected

## Codex Draft Weaknesses (from Claude critique)
- No concrete CSS code
- No actual Hugo template markup
- Missing `includeNewer` decision
- 2-column tablet breakpoint is over-engineered
- No rollback or observability section

## Valid Critiques Accepted
- Placement: move to `<footer class="post-footer">` before `.post-navigation` ✅
- Remove `date` from `[related.indices]` ✅
- Add explicit self-exclusion via `where "Permalink" "ne" .Permalink` ✅
- Change heading to `...` (three periods) ✅
- Include tags on each card ✅ (richer context, aligns with intent)
- Align CSS to real theme tokens: `--primary`, `--text-primary`, `--text-secondary`, `--text-muted`, `--border-color`, `--bg-card` ✅

## Critiques Rejected (with reasoning)
- Tags on cards → Actually accepted (reversed earlier decision — valid per success criteria)
- 2-column tablet breakpoint → Rejected; sidebar layout already constrains content; 3-col → 1-col is sufficient
- AGENTS.md update → Rejected; low-value for a feature config change
- Date on cards → Rejected; clutter, not requested

## Interview Refinements Applied
- `threshold = 20` (recall preferred)
- Placement: after share buttons, before prev/next navigation

## Final Decisions
- Injection point: `<footer class="post-footer">`, after share-buttons partial, before `.post-navigation`
- `[related]` config: categories (100) + tags (80) only; threshold 20; toLower true; includeNewer true
- Partial: Hugo template with explicit self-exclusion, section filter, thumbnail resolution from post-list.html pattern, tags on cards
- CSS: 3-column desktop → 1-column mobile; real theme variables only
- No JavaScript, no JSON index
