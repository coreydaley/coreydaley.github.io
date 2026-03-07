# Security Review: SPRINT-001

## Attack Surface

### New inputs / APIs / trust boundaries introduced
- **None.** This sprint moves static files and updates Hugo templates. No new network
  endpoints, APIs, or user-input paths are created.
- Hugo `aliases` generate static HTML with `<meta http-equiv="refresh">`. No JavaScript,
  no server-side logic, no new injection surface.

## Data Handling

- No sensitive data, secrets, or PII is touched.
- The `.env` file (API keys for `generate-post-image.py`) is already gitignored.
  Script changes don't alter where the file is read from.
- Images are public static assets. Moving them between directories doesn't change their
  public accessibility.

## Injection and Parsing Risks

### Template changes (LOW)
The dual-support logic in `baseof.html`, `post-list.html`, `figure-float.html`, and
`figure-block.html` uses Hugo template functions:
- `hasPrefix $image "/"` — string comparison, no user input
- `.Resources.GetMatch $src` — Hugo internal resource lookup, not a filesystem path
  traversal; Hugo restricts resources to the bundle directory
- `absURL`, `RelPermalink` — Hugo built-ins with no injection surface

**Finding: LOW** — No injection risk. Hugo template engine sanitizes all output
through its HTML-aware escaping. The resource lookup is scoped to the page bundle.

### `optimize-images.sh` changes (LOW)
The script uses shell commands (`find`, `cwebp`, `magick`, `sips`) on file paths
within the project directory. The path expansion adds `content/posts/**` scanning.

Potential concern: if a filename contains shell metacharacters, it could cause issues.
However, Hugo already restricts content slugs to URL-safe characters, and the script
uses `find ... -print0` with `read -r -d ''` (null-delimited) which is injection-safe.

**Finding: LOW** — The null-delimiter pattern already in use prevents injection via
unusual filenames.

### `generate-post-image.py` changes (LOW)
The script changes derive the slug from `post_path.parent.name` (directory name, not
user input) and write the image to the bundle directory. No new network calls or
subprocess executions are introduced beyond what already exists.

**Finding: LOW** — No new injection surface; the change is a path derivation update.

## Authentication / Authorization

Not applicable. This is a static site with no auth flows.

## Dependency Risks

No new libraries, packages, or external services are introduced by this sprint. All
changes are to Hugo template files, a bash script, and a Python script — using only
existing dependencies.

## Threat Model

**Adversarial scenario** (given GitHub Pages hosting, public static site):

1. **Content injection via image filenames**: An attacker who could commit to the repo
   and name an image file with HTML-like content (e.g., `<script>alert(1)</script>.webp`)
   could theoretically inject content if the filename were rendered unescaped. Hugo's
   `Resources.GetMatch` returns the permalink (URL-encoded), and all template output
   uses Hugo's contextual escaping. **Risk: None** under normal contributor access controls.

2. **Alias redirect abuse**: Alias pages use `<meta http-equiv="refresh">` to redirect.
   These are fixed at build time with hardcoded target URLs from frontmatter. No
   user-controlled redirect target exists. **Risk: None**.

3. **Social preview image spoofing**: The `image` frontmatter is now a relative filename.
   A contributor could point it to any page resource in the bundle. Since all resources
   are committed files in the content directory, this is equivalent to any contributor
   adding an image to the repo. **Risk: None** beyond existing contributor trust model.

## Findings Summary

| Area | Severity | Finding | Action |
|------|----------|---------|--------|
| Template dual-support logic | Low | No injection surface; Hugo escaping handles all output | None required |
| optimize-images.sh scan expansion | Low | Null-delimiter pattern already prevents filename injection | None required |
| generate-post-image.py path change | Low | No new subprocess or network calls | None required |
| Alias redirect pages | Low | Static HTML, hardcoded targets, no user input | None required |
| Page resource path traversal | Low | Hugo restricts `.Resources` to bundle scope | None required |

## Conclusion

**No Critical or High security findings.** This sprint is a pure content/infrastructure
reorganization of a static site with no user-facing input, authentication, or external
service integrations. All changes are contained within Hugo's safe template system and
existing build scripts that already use injection-safe patterns.

No modifications to `SPRINT-001.md` are required for security reasons.
