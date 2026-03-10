# Claude Critique: `SPRINT-002-CODEX-DRAFT.md`

## What Codex Got Right

- **Placement**: Correctly identifies the injection point as `<footer class="post-footer">` before `.post-navigation` — keeping the related section outside `data-pagefind-body`. This is the most critical architectural decision and Codex nailed it.
- **Explicit self-exclusion**: Calling this out as a required defensive step (not an assumption) is correct.
- **Verification scope**: Includes checking that existing post list thumbnail/social image behavior is unaffected — important regression test my draft didn't call out.
- **Tags in cards**: Codex includes tags in the card definition, which provides richer context when users are evaluating recommendations. Worth including per the original success criteria.
- **`where "Section" "posts"` filter in query**: Smart addition — ensures the Related API doesn't pull in non-post content even if taxonomy happens to overlap.

## What Codex Missed or Underspecified

### 1. No CSS code provided

Codex describes CSS behavior (3-column desktop, 2-column tablet, 1-column mobile) but provides zero actual CSS. This is fine for a planning document, but the Implementation Plan's Phase 4 should reference the existing CSS variable set explicitly:
- Use `--text-primary`, `--text-secondary`, `--text-muted`, `--border-color`, `--primary`, `--bg-card` (not invented tokens)
- The theme does NOT use `--accent-color` or `--bg-card-hover` consistently — using undefined vars silently falls back to browser defaults

### 2. No Hugo template code

Codex describes the template logic but doesn't write it. My draft provides a concrete partial implementation. Having actual code (even if the executor modifies it) removes ambiguity and accelerates implementation.

### 3. No `includeNewer` config decision

Hugo's `[related]` config has an `includeNewer` flag. Should newer posts recommend older ones? Should older posts be able to recommend newer ones? Codex's config is silent on this — the executor will have to guess. `includeNewer = true` is the right choice for this blog (older posts deserve traffic from newer ones).

### 4. Open question about date in cards is noise

Codex leaves "whether to include post date in cards" as an open question. This adds vagueness. The intent is clear: show relevant content, help the reader discover more. Date on a recommendation card is low-value visual clutter for this use case.

### 5. 2-column tablet breakpoint: nice-to-have overhead

The 3-column → 2-column → 1-column responsive cascade adds a tablet media query that isn't strictly necessary for a personal blog sidebar layout (where the main content column is already constrained by the sidebar). The simpler 3-column → 1-column pattern is sufficient and reduces CSS complexity.

### 6. No Observability & Rollback section

Codex's plan has no rollback strategy. Rollback is trivial for this sprint (one-line revert in `single.html`) but should be documented per the sprint planning convention.

### 7. No Documentation section

Codex's plan omits the Documentation tasks section entirely. The sprint planning format requires this.

## Verdicts

| Point | Verdict |
|---|---|
| Placement in post footer | Accept from Codex (my draft was wrong) |
| Explicit self-exclusion via `where` filter | Accept from Codex |
| Section-filter in Related query | Accept from Codex |
| Tags on cards | Accept — richer context, aligns with intent success criteria |
| Verify existing behavior unaffected | Accept from Codex |
| Remove date from `[related.indices]` | Accept (already agreed to in Codex's critique of my draft) |
| 2-column tablet breakpoint | Reject — premature complexity |
| Open question about date on cards | Reject — decided: no date |
| CSS code omitted | My draft wins (concrete CSS) |
| Hugo template code omitted | My draft wins (concrete partial markup) |
| Missing `includeNewer` decision | My draft wins (explicit `includeNewer = true`) |
| AGENTS.md update from my draft | Reject both — low-value overhead |
