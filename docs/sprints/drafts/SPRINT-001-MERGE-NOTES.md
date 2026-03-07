# Sprint 001 Merge Notes

## Claude Draft Strengths
- Clear "flat-file problem" framing with concrete examples
- Correct redirect strategy (Hugo aliases, GitHub Pages compatible)
- Detailed phase-by-phase plan with file-level specificity
- Comprehensive risk table
- Good use-case coverage (human and AI agent workflows)

## Codex Draft Strengths
- Explicit dual-support strategy (absolute + relative) for backward compatibility during migration
- Cleaner scope delineation ("Out of Scope" section)
- Raised thumbnail strategy ambiguity early and proposed resolution
- Good execution order emphasis: templates before content migration

## Valid Critiques Accepted

1. **Shortcode file paths** — Both shortcodes are at `layouts/shortcodes/`, NOT inside the theme. Claude draft listed wrong paths. Fixed in final sprint.

2. **Drop `[permalinks]` override** — Hugo's default URL derivation from directory structure (`content/posts/YYYY/MM/slug/index.md` → `/posts/YYYY/MM/slug/`) is already correct behavior. Adding a `[permalinks]` rule is redundant AND creates drift risk if frontmatter date doesn't match folder path. Removing it simplifies the plan.

3. **`generate-post-image.py` slug regression** — After migration, `post_path.stem` returns `"index"` for all posts. Must change to `post_path.parent.name`. Output directory must also change from `static/images/posts/` to the bundle directory. Explicit task added.

4. **Migrate WebPs only, update src to `.webp`** — Many posts already use `.png` in `src=` shortcode attributes. The deploy strips PNGs. Migration must update all `src=` values to `.webp` (they'll resolve from the bundle). PNGs can optionally be kept locally but must not be the src value.

5. **Theme impact understated (two files, not one)** — Both `baseof.html` (og:image via `absURL`) and `post-list.html` (thumb regex derivation) break for relative `image` values. Both need explicit dual-support logic. Added to Phase 2 scope.

6. **Backward compatibility is critical** — During incremental migration, old-style absolute paths must still work. All theme changes must be dual-support (absolute path → existing behavior; relative path → resolve as page resource).

## Critiques Rejected

- **"Shortcode changes may be unnecessary"**: HTML relative URLs do resolve in browsers, but using `.Page.Resources.GetMatch` in shortcodes provides Hugo canonical permalink resolution. This is more robust (works with potential future Hugo fingerprinting/processing) and makes the intent explicit. The update is kept but noted as explicitness, not correctness.

## Interview Refinements Applied
- User selected relative image paths → all shortcode and frontmatter changes use filename-only references
- User selected keep thumbs/ dirs via shell script → no switch to Hugo image processing
- User selected copy images into each post → no shared image bucket

## Final Decisions

1. **No `[permalinks]` change to `hugo.toml`** — directory structure drives URLs
2. **Shortcodes updated at `layouts/shortcodes/` (not theme)**
3. **Dual-support in all 4 theme files**: `baseof.html`, `post-list.html`, `figure-float.html`, `figure-block.html`
4. **Migration updates all `src=` to `.webp`** — no PNG references in migrated posts
5. **`generate-post-image.py`**: derive slug from `parent.name`, write to bundle dir
6. **`optimize-images.sh`**: scan `content/posts/` bundle dirs in addition to `static/images/`
7. **Pilot post first**: migrate one simple post, verify all 4 surface areas (og:image, post list thumbnail, shortcode images, redirect), then batch the rest
