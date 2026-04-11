+++
author = "Claude Code (Claude Sonnet 4.6)"
date = "2026-04-11T14:50:00-0400"
draft = false
title = "From Config Hub to Competing Voices: How agent-config Became My AI Collaboration Stack"
description = "The agent-config repository started as a multi-agent configuration hub for Claude, Codex, Copilot, and Gemini. It's now a Claude-specific personal workflow system — but Codex didn't disappear. It got repurposed as a competitive collaborator whose job is to challenge, critique, and improve every output Claude produces. Here's what that evolution looks like in practice."
summary = """I started agent-config as a shared configuration hub: one repository to rule Claude, Codex, Copilot, and Gemini. That lasted about two iterations before the cracks showed. Forcing every AI agent to share the same configuration format was the wrong abstraction — different tools, different philosophies, different file formats. The solution wasn't more uniformity. It was a different model of collaboration entirely.

Today agent-config is Claude-specific, but Codex is still central to how I work. The difference: Codex is no longer a configuration *target*. It's a competitive *collaborator*. Sprint plans, blog posts, security audits — every significant output runs through a workflow where Claude and Codex produce independent drafts, critique each other's work, and force synthesis from the tension. Two AI voices with different instincts produce better output than either would alone — just like a team of people with different backgrounds does.

Is your multi-agent workflow built for sharing configuration, or for generating the productive disagreement that makes output actually better?

Read more at https://coreydaley.dev/posts/2026/04/agent-config-from-sharing-to-competing-voices/"""
tags = ["ai", "agent-config", "claude-code", "codex", "multi-agent", "workflow", "automation", "competitive-drafts"]
categories = ["AI", "Automation", "Tools"]
image = "agent-config-from-sharing-to-competing-voices.webp"
aliases = ["/posts/agent-config-from-sharing-to-competing-voices/"]
+++

{{< figure-float src="agent-config-from-sharing-to-competing-voices.webp" alt="Person typing at a dual-monitor desk setup displaying colorful code, viewed from behind." >}}
The first instinct in a multi-agent setup is almost always the same: normalize everything.

Put all the instructions in one repository. Create a clean installation story. Make Claude, Codex, Copilot, and Gemini feel like interchangeable clients attached to one source of truth. It is a deeply satisfying engineering move because it smells like platform work — you reduce duplication, hide implementation differences, and tell yourself you now have a system rather than a pile of tool-specific hacks.

I understand the appeal because that was the original shape of [agent-config](https://github.com/coreydaley/agent-config). And it was wrong in the most instructive way possible.

## The False Center of Gravity

Cross-tool configuration feels central because it is visible. You can point at directories, symlinks, Makefiles, and conversion pipelines. You can explain the architecture in five minutes and it sounds coherent.

What you cannot do is wish away the fact that these tools are not the same product wearing different skins. Claude uses Markdown slash commands; Gemini uses TOML. Symlinking the same file into both tools just breaks one of them. So [v2 built a conversion pipeline](https://coreydaley.dev/posts/2026/03/agent-config-v2-failing-forward-with-ai/) — generate agents, convert formats, then symlink.

That fixed the representation mismatch. But fixing it exposed the deeper issue: I had been optimizing the tidiest problem, not the most valuable one. The repo stopped trying to be a universal config layer and became a sharply opinionated system for Claude Code. Narrower on the surface. Considerably more ambitious underneath.

## The Better Question

Once I stopped asking "How do I configure every agent from one repo?" I could ask a better question:

**How should different agents participate in the same piece of work?**

That is a workflow design question, not a portability question. And it changes everything.

In the earlier model, Codex was one more endpoint to keep in sync. In the current model, Codex is useful precisely because it is *not* Claude. It does not need to inherit the same role, the same posture, or even the same sequence in the workflow. Its job is not configuration compatibility. Its job is to add pressure.

The value of multiple models is not that they can follow the same instructions consistently. It is that they arrive at the same problem with different instincts — and those differences, surfaced early enough, improve the output in ways neither model would reach alone.

## Independence Before Synthesis

The most important design choice in these workflows is simple: independence before synthesis.

If Claude writes a draft and Codex just improves it, you get a refinement loop. The second model orbits the first model's choices — structure, assumptions, framing. The differences that matter never surface.

If both models see the same inputs and produce their own first-pass output without seeing each other's work, you get competing interpretations of the same problem. One draft might optimize for narrative clarity; the other for operational detail. One might surface rollback risks; the other might keep a firmer grip on scope. Those are not bugs in the process. They are the reason to run it.

The synthesis step becomes real work instead of ceremonial merging. You are adjudicating between competing judgments — deciding which structure is clearer, which risks matter, which suggestions were overcorrections. That is meaningfully different from polishing a single draft.

## The Compete Phase in Practice

The `/sprint-plan` command makes this concrete. After Claude writes a draft plan, **Phase 5 — Compete** invokes Codex independently via `codex exec`. Codex sees the intent document but not Claude's draft. It produces its own plan. Then both critiques run in parallel: Codex critiques Claude's draft while Claude critiques Codex's simultaneously.

The differences that surface are real. On a recent sprint planning session, Claude's draft organized tasks around build pipeline stages and added an extensive observability section. Codex's draft organized the same work around failure modes — what breaks if each stage fails — and flagged two rollback gaps Claude had quietly omitted. The synthesis kept Claude's stage-based structure and Codex's rollback additions, and explicitly rejected Codex's suggestion to add an E2E test matrix as scope creep.

That resolution was documented with reasoning. The sprint plan is harder to fool because two agents had to independently agree it was right — and the merge notes show exactly where they disagreed and why.

Beyond sprint planning, the same pattern runs through `/create-blog-post` (Claude and Codex produce competing drafts, cross-critique, then synthesize) and the dual-agent audit workflows (`audit-security`, `audit-architecture`, `audit-accessibility`, `audit-design`), where independent reviews with no cross-contamination go through a devil's advocate pass before producing a final report.

## Productive Friction Is a Feature

Human organizations have institutionalized this pattern for as long as people have worked together: design reviews, RFC comments, security sign-off, editorial passes. These are structures where distinct perspectives surface early enough to influence the outcome — not because everyone agrees, but because structured disagreement is how mistakes get caught before they are expensive.

Multi-agent workflows do the same thing with a property human teams cannot replicate: the disagreement is cheap to generate and impossible to take personally. Codex does not defer to Claude's framing out of social pressure. Claude does not accept Codex's critique out of politeness. The synthesis can make genuinely analytical decisions about which approach is stronger, with every rejected critique documented.

The key is resisting the temptation to smooth out the disagreement too early. If every agent gets the same instructions and the same intermediate artifacts, multiple agents just means multiple shots on goal. Useful occasionally, but the differences that would make the output better never had a chance to matter.

## Where This Pattern Fails

This workflow is not free, and it is worth naming where it breaks down.

The most common failure is convergent blind spots — two models trained on similar data reaching similar wrong conclusions independently. Agreement raises confidence, but it does not eliminate shared gaps. Security audits run this way still need human review; they are better-structured starting points, not guarantees.

Synthesis can also become a new bottleneck. When both drafts diverge significantly, merging them requires real editorial judgment. The workflow produces better raw material; it does not automate the hard decisions.

And not every task deserves two full passes. A routine bug fix or a quick commit message does not benefit from competing drafts. The overhead justifies itself when output quality matters enough to warrant it — sprint plans, architectural decisions, published content. The pattern scales with stakes.

## From Setup Thinking to Collaboration Thinking

The repository got narrower from the outside: it centers Claude, reflects one person's workflow, and is explicit about being personal infrastructure rather than a universal template.

From the inside, the ambition shifted in a more interesting direction. The point is no longer distributing consistent configuration across many tools. It is encoding repeatable workflows where multiple AI systems do what strong collaborators do: arrive with different instincts, test each other's work, and make the final output harder to fool.

What was worth keeping from the original agent-config was not the symlinks or the Makefiles. It was the discovery that Codex's most valuable contribution to the workflow was not following the same instructions as Claude — it was disagreeing with Claude in ways that made the synthesis better.

That is the real evolution: from setup thinking to collaboration thinking.

*If you use more than one AI model in your workflow, where are you still treating difference as a compatibility problem instead of a source of better judgment?*

