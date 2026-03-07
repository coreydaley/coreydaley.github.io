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

4. **Write the final post** to `content/posts/$SLUG.md`:
   - Incorporate the best angle, structure, examples, and phrasing from both drafts
   - Apply all valid critiques
   - Set `draft = false`
   - Follow all AGENTS.md conventions precisely (frontmatter, closing question, etc.)
   - Do NOT include an `image` field unless you already have a `.webp` available

5. **Show the user** the final post and ask for approval before considering the task complete.

---

## Phase 5: Image Prompt

**Goal**: Give the user a ready-to-paste prompt for generating a hero image for the post.

Based on the final post at `content/posts/$SLUG.md`, craft an image generation prompt that:

- Captures the **central visual metaphor** of the post (not just the title — think about what *concept* would make a compelling image)
- Specifies a **consistent art style**: flat vector illustration, dark navy/charcoal background, electric blue and warm amber accents, no text or words in the image, modern SaaS marketing aesthetic
- Describes the **mood and composition** clearly enough that any image AI can execute it
- Targets a **landscape aspect ratio** (~16:9 or 3:2) suitable for a blog hero image

Output the prompt in a clearly labeled block so the user can copy it directly. Example structure:

```
## Image Generation Prompt

[Your prompt here]

**Style notes:** Flat vector illustration, dark navy background, electric blue + amber accents, no text, landscape 16:9.
```

After outputting the prompt, remind the user to run `./scripts/optimize-images.sh` on any downloaded image before referencing it in the post.

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
└── $SLUG.md   ← final post
```

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
- [ ] Final post written to `content/posts/$SLUG.md` with `draft = false`
- [ ] User shown the final post and approved
- [ ] Image generation prompt output to user
