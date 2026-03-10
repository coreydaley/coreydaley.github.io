+++
author = "Claude Code (Claude Sonnet 4.6)"
date = "2026-03-10T15:40:00-04:00"
draft = false
title = "The Blog That Builds Itself: AI Automation Behind the Scenes"
description = "This blog runs on a custom automation pipeline where AI agents compete, critique, and synthesize every post. Here's how the /create-blog-post command, a DALL-E 3 image generation script, pre-commit image enforcement, and WebP optimization all compose into a content system that behaves like production software."
summary = """What happens when you stop treating AI as a writing assistant and start treating it as a co-publisher? This blog has accumulated a full automation stack: a /create-blog-post command that pits Claude and Codex against each other in a competitive draft workflow, a Python script that generates hero images using DALL-E 3 and Claude vision, pre-commit hooks that block commits with unoptimized images, and a Bash script that handles WebP conversion and thumbnail generation automatically.

The design principle behind all of it: treat each stage as a contract, not a prompt. The meta-detail: this post was written by the same pipeline it describes.

What would your content workflow look like if you designed it the same way you'd design a software system — and which parts would you never automate at all?

Read more at https://coreydaley.dev/posts/2026/03/building-a-blog-automation-pipeline-with-ai/"""
tags = ["automation", "ai", "claude-code", "codex", "blog-workflow", "dall-e", "pre-commit", "hugo", "webp", "workflow"]
categories = ["AI", "Automation", "Web Development"]
image = "building-a-blog-automation-pipeline-with-ai.webp"
aliases = ["/posts/building-a-blog-automation-pipeline-with-ai/"]
+++

{{< figure-float src="building-a-blog-automation-pipeline-with-ai.webp" alt="Blue robots write on papers moving along an orange conveyor belt with monitors behind." >}}
This post is a live output of the pipeline it describes: one command triggered two competing AI drafts, mutual critique, synthesis, editorial review, and hero image generation — automatically. The only thing I did manually was review the result. That's the whole point.

## Contracts, Not Prompts

The organizing principle behind this automation stack: each stage should produce a concrete artifact with a clear schema, not just "some text." That shift — from prompt-to-output to input-contract-to-output-contract — is what makes AI stages composable and the whole thing maintainable.

In practice that means deterministic file paths, strict TOML frontmatter, named handoff files between phases, and a fixed leaf bundle target. Once each step has a contract, AI outputs become testable inputs for the next step — and failures are localized instead of cascading.

The payoff is real: publishing a post now takes minutes of human review rather than hours of mechanical setup, with substantially more consistent quality than writing everything from scratch each time.

## The /create-blog-post Command

The most complex piece is a slash command at `.claude/commands/create-blog-post.md`. It runs five stages:

**Create** — Claude reads `CLAUDE.md`, reviews recent posts to calibrate voice, and writes a complete draft with TOML frontmatter to `content/posts/drafts/$SLUG-claude-draft.md`.

**Challenge** — Codex is invoked via `codex exec` with two tasks: write an independent competing draft on the same topic, then critique Claude's draft. Neither agent sees the other's work until both are done. Claude writes its own critique of the Codex draft after reading it.

**Synthesize** — Both drafts, both critiques, merge notes. The synthesized draft takes the best angle, structure, and examples from each source while documenting which critiques were accepted and which were rejected, and why.

**Editorial Review** — The synthesized draft goes back to Codex as a professional editor: pacing, structure, voice seams from the merge, specific lines to cut or rewrite.

**Ship** — Claude applies the editorial feedback, writes the final post to the leaf bundle (`content/posts/YYYY/MM/$SLUG/index.md`), and immediately runs the image generation script.

The competitive structure is deliberate. Claude and Codex take different angles by default. Running them independently and synthesizing produces something neither would write alone. The critique phase surfaces those differences before they reach the reader.

## When Stages Fail

These stages do fail, and that's worth naming before getting into the mechanics. A model occasionally returns malformed frontmatter; Hugo refuses to build and catches it immediately before pushing. DALL-E sometimes produces an image that misses the visual concept; re-running the image script after removing the `image =` frontmatter field regenerates it. A critique phase can over-correct the voice; the synthesis step exists precisely to evaluate critiques against each other rather than accepting all feedback uncritically.

Reliability here comes from recoverable stages, not from pretending generation is always correct. Each failure is small, local, and fixable in minutes.

## Automated Hero Image Generation

`scripts/generate-post-image.py` takes a path to a post's `index.md` and handles the full image lifecycle automatically:

```bash
python3 scripts/generate-post-image.py content/posts/2026/03/my-post/index.md
```

The key step is concept derivation. Claude reads the post and produces a concrete, literal description — specific objects, people, actions — before anything touches DALL-E. Abstract metaphor language produces unpredictable images; literal scene descriptions produce consistent ones.

```python
def generate_image_concept(post_content: str) -> str:
    client = anthropic.Anthropic()
    response = client.messages.create(
        model="claude-sonnet-4-6",
        max_tokens=300,
        messages=[{
            "role": "user",
            "content": (
                "You are art-directing a hero image for a tech blog post. "
                "Read the post and write a 2-3 sentence image description capturing "
                "the central visual metaphor. Be concrete and literal — describe "
                "specific objects, people, and actions to depict. "
                "Do NOT include style or color instructions. "
                "Return ONLY the image description, no preamble.\n\n"
                f"Post (excerpt):\n{post_content[:4000]}"
            ),
        }],
    )
    return response.content[0].text.strip()
```

The concept goes to DALL-E 3 with a fixed style prompt — flat vector illustration, dark navy background, electric blue and amber accents, no text. After the PNG downloads into the post's bundle directory, `optimize-images.sh` converts it to WebP and generates a 400px thumbnail. Finally, Claude vision reads the actual generated WebP and writes accurate alt text based on what's literally depicted, not on the filename or post title.

## The Pre-Commit Gate

`scripts/optimize-images.sh` handles WebP conversion and thumbnail generation across all post bundles. It's idempotent — it skips files where WebP already exists and isn't oversized. The pre-commit hook is where optimization becomes mandatory.

`.pre-commit-config.yaml` registers a local hook that runs `make optimize-images` before every commit:

```bash
make optimize-images

if ! git diff --quiet; then
    echo "❌ ERROR: make optimize-images produced changes that are not staged."
    echo "Please review and stage these changes, then commit again."
    exit 1
fi
```

If you try to commit a PNG that hasn't been converted, or a WebP wider than 1600px, the hook blocks the commit, optimizes the image, and asks you to stage the result before retrying. This substantially reduces the chance of shipping unoptimized assets — though only if `pre-commit` is installed and the tooling is present. It's a guardrail, not a guarantee.

## The Human Stays at the Highest-Leverage Layer

The pipeline removes mechanical work. Human review still owns the things automation can't:

- Whether the argument is worth publishing
- Whether the structure earns the reader's time
- Whether claims are scoped and responsible
- Whether the final voice sounds right

That last point matters more than it looks. In synthesizing this post, the editorial review suggested cutting the entire "meta-opening" — the detail that the post was written by its own pipeline. That's the most interesting thing about the post. The suggestion got rejected. That judgment call couldn't have come from automation.

AI is good at throughput and transformation. Humans are better at knowing which parts of a draft are worth defending.

## What It Cost to Build

Honest accounting: the pre-commit hook took an afternoon. The image script took a day including iteration on the concept prompt. The `create-blog-post` command took longer — the multi-agent critique workflow required real design thinking about what each phase should produce and where the handoff contracts needed to be explicit.

Total one-time investment: roughly 20 hours. Marginal cost per post: minutes of human review. Main gain: consistent mechanics regardless of how much time is available, and a quality ceiling that doesn't depend on being well-rested.

## How the Pieces Compose

The full workflow for a new post:

1. Run `/create-blog-post <topic>` — drafts, critique, synthesis, editorial review, leaf bundle, hero image are all automatic
2. Review — read the post, check the image, adjust what needs it
3. `git add` the bundle files
4. `git commit` — pre-commit hook confirms all images are optimized
5. Push to `main` — GitHub Actions builds with Hugo, runs Pagefind, deploys

The only mandatory step is review. The automation handles everything else.

*If your writing workflow had the rigor of your release pipeline — which step would you automate first, and which would you keep human?*

