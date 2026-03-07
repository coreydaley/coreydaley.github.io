# Codex Critique: `SPRINT-001-CLAUDE-DRAFT.md`

## What’s Strong

- **Clear problem statement + motivating examples**: the “flat-file problem” framing and the concrete use cases make the why immediately obvious.
- **Correct redirect strategy**: using Hugo `aliases` is the right GitHub Pages-compatible mechanism.
- **Bundle-relative authoring direction**: moving post image references from `/images/posts/...` to `filename.webp` is aligned with the “co-located assets” goal.
- **Pragmatic phased plan**: sequencing (templates → pilot → bulk migrate → scripts → docs) is the right order to reduce risk.

## Key Mismatches vs This Repo (needs correction)

### 1) Shortcode file locations

The draft references:
- `themes/coreydaley-dev/layouts/shortcodes/figure-float.html`
- `themes/coreydaley-dev/layouts/shortcodes/figure-block.html`

In this repo, both shortcodes currently live at:
- `layouts/shortcodes/figure-float.html`
- `layouts/shortcodes/figure-block.html`

So Phase 2 file paths should be updated, or we risk editing the wrong place.

### 2) Shortcode changes may be unnecessary (relative URLs already work)

If we migrate to leaf bundles and change post Markdown to:
- `{{< figure-float src="hero.webp" ... >}}`

…then the rendered HTML `src="hero.webp"` and `srcset="hero.webp"` will naturally resolve relative to the page URL (`/posts/YYYY/MM/slug/`), without needing `.Page.Resources.GetMatch`.

Resource-resolution inside the shortcode is still fine (and can make things more explicit), but it’s not strictly required for basic correctness. If we do add logic, we should confirm it doesn’t break current absolute `/images/...` usage.

### 3) Theme image assumptions are a bigger issue than the draft calls out

The current theme does more than just og:image:

- `themes/coreydaley-dev/layouts/_default/baseof.html` sets `og:image` / `twitter:image` via `.Params.image | absURL`, which will break if `image = "hero.webp"` (it becomes `https://.../hero.webp` at the site root).
- `themes/coreydaley-dev/layouts/partials/post-list.html` assumes thumbnails live under `/images/posts/thumbs/` and derives thumb paths by regex-replacing that prefix. That will break for bundle URLs.

So the “one-line update” is understated: we need explicit theme support for bundle-relative `image` values and a new thumbnail strategy for the post list.

### 4) `generate-post-image.py` will break once posts are `index.md`

The script currently uses:
- `slug = post_path.stem`

After migration, `post_path` becomes `.../slug/index.md`, so `stem` becomes `"index"`, which would:
- Name images `index.png` / `index.webp`
- Insert `image = "/images/posts/index.webp"` and a shortcode pointing to `index.webp`

The script will need to derive the slug from the parent directory name (and write into the bundle directory, not `static/images/posts/`).

### 5) PNG originals likely aren’t available to “move”

Many posts reference PNGs in `src="...png"`, but the repo’s `static/images/posts/` currently contains only WebPs (originals are preserved locally but stripped from deploy, and may not be committed at all).

So the migration plan should assume:
- We move WebPs into bundles (source of truth), and
- We update Markdown to reference `.webp` in `src` (not `.png`), to avoid relying on non-deployed originals.

## Potentially Risky / Questionable Choice

### Adding `[permalinks]` may be redundant (and can create drift)

If we’re already organizing content as:
`content/posts/YYYY/MM/slug/index.md`

…then Hugo’s default section pathing already yields `/posts/YYYY/MM/slug/`.

Adding:
```toml
[permalinks]
  posts = "/posts/:year/:month/:slug/"
```

…can be redundant and introduces a subtle failure mode: if the `date` frontmatter doesn’t match the folder `YYYY/MM`, the URL and filesystem organization can diverge. Unless we have a strong reason to decouple URL from folder structure, I’d prefer **no permalink override** for Sprint 001.

## Missing Items to Add (to make the sprint “complete”)

- **Post listing thumbnail plan**: either (a) bundle `thumbs/` convention + theme logic to find it, or (b) Hugo image processing in templates.
- **Meta image resolution logic**: update `themes/coreydaley-dev/layouts/_default/baseof.html` to resolve bundle-relative `.Params.image` to a resource permalink before calling `absURL`.
- **Backward compatibility strategy**: ensure old posts (if migrated incrementally) still render correctly during the transition.
- **A concrete pilot checklist**: migrate 1 post, verify redirect + list thumbnail + og:image + Pagefind output, then proceed.

## Suggested Edits to Claude Draft (high impact)

- Fix shortcode file paths to `layouts/shortcodes/...`.
- Expand “theme changes” to include `post-list.html` thumbnail handling, not just og:image.
- Update `generate-post-image.py` notes to address the `index.md` slug issue explicitly.
- Replace “move PNG originals” language with “move WebPs; update `src` to `.webp`”.
- Consider dropping `[permalinks]` unless we explicitly want URL-from-date rather than URL-from-path.

