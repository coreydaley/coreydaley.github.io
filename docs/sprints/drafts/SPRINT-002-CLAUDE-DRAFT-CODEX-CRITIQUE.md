# Codex Critique: `SPRINT-002-CLAUDE-DRAFT.md`

## What’s Strong

- Correct architectural decision: build-time Hugo Related Pages over client-side JSON/JS.
- Good file targeting: `hugo.toml`, `single.html`, new partial, and `style.css` are the right surfaces.
- Clear verification mindset with explicit edge-case checks.
- Practical rollback path documented.

## High-Impact Issues (Needs Correction)

### 1) Placement contradicts both intent and Pagefind constraint

Draft says to include the partial in `single.html` "before `share-buttons.html`" inside the `{{ if eq .Section "posts" }}` block.

In the real template, that block is inside:

- `<div data-pagefind-body class="post-content"> ... {{ partial "share-buttons.html" . }} </div>`

So this placement would put recommendations inside `data-pagefind-body`, which conflicts with the sprint constraint and will pollute indexed body text.

Required correction:

- Inject the related partial in `<footer class="post-footer">`, before `.post-navigation`.

### 2) Scoring spec drifts from stated requirement

Intent requests recommendations determined by tag/category overlap. The draft adds a `date` index with weight `10`.

Problem:

- Recency bias can reorder equally relevant taxonomy matches and introduces a second ranking axis not requested.

Required correction:

- Keep `[related.indices]` to `categories` + `tags` only for this sprint.

### 3) No explicit self-exclusion in partial logic

Draft relies on an assumption that Hugo excludes current page in related results.

Risk:

- If behavior changes or edge cases differ, the current post can leak into its own list.

Required correction:

- Add explicit exclusion in template (`where` filter against current page permalink or unique identity).

### 4) Proposed heading text is not exact match

Intent success criteria specifies heading:

- `If you enjoyed this post, you might also enjoy...`

Draft sample uses typographic ellipsis (`…`) instead of three periods (`...`).

Required correction:

- Use exact string from intent to avoid acceptance ambiguity.

## Medium-Impact Issues

### 5) Card content misses one required field

Intent success criteria requires each recommendation to show tags. Draft defers tags on cards and defines them as deferred work.

Required correction:

- Include tags in card metadata in the base sprint scope.

### 6) CSS direction is visually off-pattern for this theme

Draft CSS uses muted/dark fallback values and `--accent-color`, which is not an existing theme token in `style.css`.

Risk:

- Inconsistent appearance vs current design system (`--primary`, `--accent-pink`, dashed separators, rounded card language).

Required correction:

- Reuse existing variables and card conventions already present in theme CSS.

### 7) Overconfident statement about Hugo behavior

Risk table says "Hugo explicitly excludes the current page" as a certainty.

Required correction:

- Treat as implementation assumption and still enforce self-exclusion defensively in template code.

## Low-Impact Issues

### 8) AGENTS.md update is unnecessary scope expansion

Draft adds DoD/documentation tasks to update `AGENTS.md` about related config.

Concern:

- Not required by sprint intent and adds non-functional overhead.

Recommendation:

- Keep documentation updates optional unless the team specifically wants this convention captured.

### 9) "Phase 4 interview" reference appears copied from another workflow

Open question mentions confirming threshold after "Phase 4 interview," but no interview phase exists in this sprint plan.

Recommendation:

- Replace with "after verification spot-check" language.

## Suggested Edits to Claude Draft (Quick Patch List)

1. Move partial injection point from post-content block to post footer before navigation.
2. Remove `date` from `[related.indices]`; keep categories/tags only.
3. Add explicit current-post exclusion in partial query pipeline.
4. Change heading to exact required text with `...`.
5. Add tags to each related card to meet success criteria.
6. Align CSS tokens and visual treatment to existing theme variables.
7. Replace "Phase 4 interview" wording with verification-based tuning.
