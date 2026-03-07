---
description: Create a blog post draft by writing a Claude draft, spawning a Codex competing draft, then synthesizing both into a final post following project conventions.
---

# Create Blog Post: Competitive Draft Workflow

You are orchestrating a 4-phase workflow to produce a high-quality blog post through competitive ideation and synthesis with Codex.

## Topic

$ARGUMENTS

## Workflow Overview

1. **Orient** - Research the topic and review project conventions
2. **Draft** - Write your Claude draft
3. **Compete** - Codex creates an independent draft and critiques yours
4. **Synthesize** - Compare and merge both drafts into the final post
5. **Image Prompt** - Generate an image generation prompt based on the final post

Use TodoWrite to track progress through each phase.

---

## Phase 1: Orient

**Goal**: Understand the topic deeply and internalize the project's content conventions.

### Steps:

1. Read `AGENTS.md` to internalize frontmatter requirements, image workflow, category rules, and tone conventions.
2. Read 2-3 recent posts from `content/posts/` to calibrate voice, tone, structure, and length.
3. Research the topic using available tools (WebSearch if helpful).
4. Derive a URL-safe slug from the topic (lowercase, hyphenated, e.g. `my-post-topic`). Store this as `SLUG`.
5. Determine the current year and month (e.g. `2026/03`). Store this as `YYYY/MM`. The final post path will be `content/posts/YYYY/MM/$SLUG/index.md`.

### Deliverable:

Write a brief **Orientation Summary** covering:
- Core argument or angle for the post
- Target audience
- 3-5 key points to cover
- Proposed slug, title, tags, and 3 categories

---

## Phase 2: Draft (Claude)

**Goal**: Write a complete, publication-ready draft following all project conventions.

### Write to: `content/posts/drafts/$SLUG-claude-draft.md`

Create the drafts directory if needed:
```bash
mkdir -p content/posts/drafts
```

> **Note:** Drafts are flat `.md` files for iteration convenience. Only the final synthesized post becomes a leaf bundle.

The draft must include:

- **Full TOML frontmatter** (`+++` delimiters, double quotes, all required fields):
  ```toml
  +++
  author = "Claude Code (Claude Sonnet 4.6)"
  date = "YYYY-MM-DDTHH:MM:SS-05:00"
  draft = true
  title = "..."
  description = "..."
  summary = "..."
  tags = ["...", "..."]
  categories = ["...", "...", "..."]
  +++
  ```
  - `description`: SEO-friendly, ~75 words
  - `summary`: Conversational LinkedIn summary, ~150 words, ends with a question or CTA
  - `tags`: lowercase, hyphenated, specific
  - `categories`: exactly 3, Title Case
  - No `image` field in the draft (images are added after the image optimization workflow)

- **Body**:
  - Engaging introduction that hooks the reader
  - Well-structured sections with headers
  - Concrete examples, analogies, or code snippets where appropriate
  - 800–1500 words (conversational but substantive)
  - Closing italicized question directly related to the post content

---

## Phase 3: Compete (Codex)

**Goal**: Get Codex's independent take and critique of your draft.

### Execute Codex:

```bash
codex exec "Please read content/posts/drafts/$SLUG-claude-draft.md. This is a Claude-written draft for a personal tech blog. Also read AGENTS.md for the project content conventions. Then: (1) Write your own independent draft to content/posts/drafts/$SLUG-codex-draft.md — same topic, same TOML frontmatter format with double-quote strings, but your own angle, structure, and voice. Only AFTER your draft is complete, (2) read Claude's draft again and write a critique to content/posts/drafts/$SLUG-claude-draft-codex-critique.md — what works, what's weak, what's missing, what you'd change."
```

### Wait for Codex to complete.

Codex will produce:
- `content/posts/drafts/$SLUG-codex-draft.md` — Independent draft
- `content/posts/drafts/$SLUG-claude-draft-codex-critique.md` — Critique of your draft

### Read both files once Codex finishes.

---

## Phase 4: Synthesize

**Goal**: Merge the best of both drafts into the final blog post.

### Synthesis process:

1. **Evaluate Codex's critique** of your draft:
   - Which criticisms are valid?
   - What did Codex catch that you missed?
   - What will you defend?

2. **Compare the two drafts**:
   - Angle/framing differences
   - Structural differences
   - Examples or analogies unique to each
   - Tone and voice differences

3. **Write merge notes** to `content/posts/drafts/$SLUG-merge-notes.md`:
   ```markdown
   # Merge Notes: [Post Title]

   ## Claude Draft Strengths
   - ...

   ## Codex Draft Strengths
   - ...

   ## Valid Critiques Accepted
   - ...

   ## Critiques Rejected (with reasoning)
   - ...

   ## Final Decisions
   - ...
   ```

4. **Write the final post** as a leaf bundle at `content/posts/YYYY/MM/$SLUG/index.md`:
   - Create the bundle directory first: `mkdir -p content/posts/YYYY/MM/$SLUG`
   - Incorporate the best angle, structure, examples, and phrasing from both drafts
   - Apply all valid critiques
   - Set `draft = false`
   - Follow all AGENTS.md conventions precisely (frontmatter, closing question, etc.)
   - Add `aliases = ["/posts/$SLUG/"]` to the frontmatter for redirect compatibility
   - Do NOT include an `image` field yet (image is added in Phase 5)
   - **Set `date` to a few minutes before the current local time** — run `date '+%Y-%m-%dT%H:%M:%S%z'` and subtract ~5 minutes. Hugo will not serve a post whose timestamp is in the future, so a midnight or templated time will cause the post to be invisible during local preview.

5. **Proceed immediately to Phase 5** — do not pause for user approval. The image generation script runs automatically after the final post is written.

---

## Phase 5: Generate Hero Image

**Goal**: Automatically generate, optimize, and insert a hero image into the final post.

### Run the image generation script:

```bash
python3 scripts/generate-post-image.py content/posts/YYYY/MM/$SLUG/index.md
```

The script will:
1. Call the Claude API to derive a visual concept from the post content
2. Call DALL-E 3 (OpenAI API) to generate a 1792×1024 HD image
3. Download the PNG to the **post's bundle directory** (`content/posts/YYYY/MM/$SLUG/$SLUG.png`)
4. Optimize to WebP via `./scripts/optimize-images.sh` (creates `$SLUG.webp` and `thumbs/$SLUG.webp` in the bundle)
5. Call Claude vision to generate accurate alt text from the actual image
6. Insert the `figure-float` shortcode and `image` frontmatter field into `index.md`

### Requirements:
- `.env` file at the repo root with `ANTHROPIC_API_KEY` and `OPENAI_API_KEY` set (see `.env.example`)
- `.venv/` virtualenv present at the repo root (`python3 -m venv .venv && .venv/bin/pip install anthropic openai requests`)
- The script self-re-execs with `.venv/bin/python3` automatically — no manual activation needed

### After the script completes (success or fallback):

Output the following block exactly as shown so the user can copy/paste directly into LinkedIn, X, or other social media. No labels, no extra text — just the content:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
<full text of the `summary` frontmatter field, verbatim>

Read more at https://coreydaley.dev/posts/YYYY/MM/$SLUG/
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

> **Important:** Always use the canonical URL (`/posts/YYYY/MM/$SLUG/`) for social sharing, not the short alias (`/posts/$SLUG/`). LinkedIn and other social scrapers do not follow `<meta http-equiv=refresh>` redirects, so sharing the alias URL results in no preview image.

### If the script fails (missing API keys or network error):

Fall back to manual: output an image generation prompt based on the post's central visual metaphor, using the blog's established style (dark navy background, electric blue + amber accents, flat vector illustration, no text, landscape 16:9). Remind the user to place the downloaded image in `content/posts/YYYY/MM/$SLUG/`, run `./scripts/optimize-images.sh` from the repo root, then manually insert the shortcode (`{{< figure-float src="hero.webp" alt="..." >}}`) and `image = "hero.webp"` frontmatter field in `index.md`.

---

## File Structure

After this workflow completes, you'll have:

```
content/posts/
├── drafts/
│   ├── $SLUG-claude-draft.md
│   ├── $SLUG-codex-draft.md
│   ├── $SLUG-claude-draft-codex-critique.md
│   └── $SLUG-merge-notes.md
└── YYYY/
    └── MM/
        └── $SLUG/               ← leaf bundle (Hugo page bundle)
            ├── index.md         ← final post (image field + shortcode inserted)
            ├── $SLUG.png        ← original PNG (preserved locally, stripped by CI)
            ├── $SLUG.webp       ← optimized WebP (used in post body + og:image)
            └── thumbs/
                └── $SLUG.webp   ← thumbnail used in post list
```

> All post images live **inside the leaf bundle directory**, not in `static/images/posts/`.
> The `image` frontmatter field and shortcode `src` use the **filename only** (e.g. `"hero.webp"`), not a path.

---

## Output Checklist

- [ ] AGENTS.md read and conventions internalized
- [ ] Recent posts reviewed for tone/voice calibration
- [ ] Orientation summary written (slug, angle, key points, categories)
- [ ] Claude draft written to `content/posts/drafts/$SLUG-claude-draft.md`
- [ ] Codex executed and completed
- [ ] Codex draft received (`$SLUG-codex-draft.md`)
- [ ] Codex critique received (`$SLUG-claude-draft-codex-critique.md`)
- [ ] Merge notes written (`$SLUG-merge-notes.md`)
- [ ] Final post written to `content/posts/YYYY/MM/$SLUG/index.md` with `draft = false`
- [ ] `aliases = ["/posts/$SLUG/"]` added to frontmatter
- [ ] Hero image generated and inserted via `generate-post-image.py content/posts/YYYY/MM/$SLUG/index.md`
- [ ] Post URL and social caption output for copy/paste
