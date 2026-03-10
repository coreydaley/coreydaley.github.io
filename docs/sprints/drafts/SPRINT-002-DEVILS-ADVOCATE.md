# Devil's Advocate Review: `docs/sprints/SPRINT-002.md`

This plan is coherent, but it is not approval-ready if the bar is “no surprises after implementation starts.” It assumes clean taxonomy data, stable template behavior, and low regression risk without proving any of those assumptions. As written, it can pass its own Definition of Done and still ship low-quality recommendations, accessibility regressions, and search/index contamination.

## 1) Flawed assumptions

- **Assumption: “taxonomy overlap means relevance.”** The plan treats Hugo Related scoring as sufficient relevance logic and explicitly optimizes for recall (`threshold = 20`) to “always try to show 3” ([Overview], [Architecture], [Hugo Related Config]). This assumes tags/categories are consistent and semantically clean. On personal blogs, taxonomy drift is common; this will surface false positives as “related.”

- **Assumption: low threshold is safe.** `threshold = 20` is justified as “prefer showing 3 loosely related posts over showing nothing” ([Hugo Related Config]). That is a product choice disguised as implementation detail. Showing weak matches can reduce trust faster than showing nothing.

- **Assumption: no recency signal is harmless.** The plan excludes a `date` index because “recency bias not requested” ([Hugo Related Config]). That assumes readers do not benefit from freshness and that old content won’t dominate recommendations by taxonomy density.

- **Assumption: section filter is enough isolation.** `where "Section" "posts"` is treated as complete guardrail ([Architecture], [Partial: `related-posts.html`]). That assumes all intended content lives in exactly one section and no future content reorganization will silently break recall.

- **Assumption: image path handling is future-proof.** The partial mixes legacy absolute-path handling and bundle-resource lookup, with extension rewriting for legacy paths (`replaceRE`) ([Partial: `related-posts.html`]). This assumes naming and conversion conventions never drift and that non-webp legacy assets always have webp twins.

- **Assumption: accessibility is “good enough” with current markup.** The image link is focus-disabled and aria-hidden while title link remains focusable ([Partial: `related-posts.html`]). That assumes keyboard/screen-reader behavior remains coherent and that duplicate-link simplification won’t create discoverability issues.

## 2) Scope risks

- **Quality tuning is underestimated.** The plan budgets implementation work, not tuning work, yet recommendation quality depends heavily on taxonomy cleanup and threshold/weights calibration ([Implementation Plan P0], [Deferred: Taxonomy cleanup audit], [Risks & Mitigations]). This can balloon quickly after first real-content review.

- **Hidden dependency on taxonomy hygiene is deferred, not solved.** The plan explicitly defers taxonomy cleanup while relying on taxonomy overlap for core feature quality ([Deferred], [Overview]). That is a direct dependency pushed out of scope.

- **Cross-template coupling risk is understated.** Touching `hugo.toml`, `single.html`, a new partial, and global `style.css` looks small, but failures will appear across all post pages and responsive states ([Files Summary], [Implementation Plan P0/P1]). Global CSS side effects are likely because styles are appended to shared stylesheet.

- **Edge-case matrix is larger than test plan.** P0 asks for spot-checking “5+ posts” and a handful of edge cases ([Implementation Plan P0]). That is too small for combinatorics: no-tags source post, no-description target post, mixed legacy/bundle images, multilingual/tag casing anomalies, and near-threshold match churn.

- **Search integration dependency is treated as one assertion.** The plan says keep related section outside `data-pagefind-body` and verify via dev tools ([Implementation Plan P0], [Definition of Done], [Risks & Mitigations]). That checks DOM placement, not index behavior. Hidden dependency: Pagefind still crawls links and can be affected by structural changes.

## 3) Design weaknesses

- **Single global scoring model for all content types is rigid.** One `[related]` config applies everywhere without per-section or per-taxonomy nuance ([Hugo Related Config]). This is easy now, but hard to evolve when content diversity increases.

- **“Always try to show 3” prioritizes layout over relevance.** Architecture optimizes for filled cards instead of confidence ([Architecture], [Hugo Related Config]). That is the wrong default for a trust-based recommendation block.

- **Card content strategy can amplify weak metadata.** Cards rely on title + truncated description + tags ([Architecture], [Partial]). If descriptions are inconsistent quality/length, UI will highlight editorial debt rather than relatedness.

- **Legacy path support in core rendering path adds long-term complexity.** The partial permanently embeds compatibility logic (`hasPrefix "/"` branch + resource lookup fallback) ([Partial]). This creates technical debt in the primary template instead of a migration boundary.

- **No deterministic ranking tie-break policy is documented.** The plan does not define behavior when multiple posts have equal related scores ([Overview], [Architecture], [Definition of Done]). Result ordering may appear random across content changes, producing unstable UX.

## 4) Gaps in Definition of Done

- **No relevance acceptance criteria.** DoD confirms presence/placement/count, not recommendation quality thresholds ([Definition of Done]). A technically correct but semantically poor set can still pass.

- **No explicit accessibility criteria.** DoD omits keyboard navigation, heading hierarchy checks, alt text quality rules, and screen-reader behavior for linked cards ([Definition of Done], [Partial]).

- **No regression criteria for cumulative layout shift/perf.** DoD doesn’t require measuring impact of added card grid/images on LCP/CLS or page weight ([Definition of Done], [CSS additions]).

- **No determinism check across builds.** DoD doesn’t require stable related ordering for unchanged content ([Definition of Done]). Non-deterministic recommendations can pass unnoticed.

- **No negative tests for malformed frontmatter.** DoD lacks checks for missing/non-string `image`, empty `tags`, missing `description`, and atypical taxonomy casing despite `toLower = true` dependence ([Definition of Done], [Hugo Related Config], [Implementation Plan edge cases]).

- **No rollback validation criteria.** Rollback is described procedurally, but DoD has no requirement to verify rollback completeness or residual CSS/template artifacts ([Observability & Rollback], [Definition of Done]).

## 5) Most likely failure mode

The sprint most likely fails as a **“green build, bad recommendations” launch**.

Specific path:
- Feature ships quickly because implementation is straightforward (`[related]` config + partial + CSS) ([Implementation Plan P0], [Files Summary]).
- Manual checks on 5 posts pass basic rendering and placement ([Implementation Plan P0], [Definition of Done]).
- Real readers hit posts with sparse/noisy taxonomy; low threshold and no recency signal produce weak or stale matches ([Hugo Related Config], [Deferred taxonomy cleanup]).
- Trust drops because the widget confidently recommends off-target content; users ignore the module, and it becomes dead weight.

Secondary likely failure: **silent accessibility/UX debt**.
- Card image links are not keyboard-focusable while headings are; mobile row layout changes visual affordance; no a11y acceptance criteria exists ([Partial], [CSS additions], [Definition of Done]).
- This passes current DoD but creates avoidable usability regressions.

If approval requires confidence, this plan needs stricter quality gates than “appears in correct location with up to 3 cards.” Right now it optimizes shipping certainty, not outcome certainty.
