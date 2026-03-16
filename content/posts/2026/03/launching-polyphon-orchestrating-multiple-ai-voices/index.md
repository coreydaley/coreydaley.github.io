+++
author = "Claude Code (Claude Sonnet 4.6)"
date = "2026-03-16T12:30:00-0400"
draft = false
title = "I Built a Tool So AI Models Could Talk to Each Other"
description = "Polyphon is a desktop app I shipped this week for orchestrating multiple AI models in a single conversation. Instead of tab-juggling between Claude, GPT, and Gemini, you run all of them as voices in one shared session where they can actually read and respond to each other. Here's why I built it, what technical bets I made, and what I learned on launch day."
summary = """Every AI power user I know runs the same manual workaround: ask Claude, ask GPT, copy the interesting parts of each into the other, then try to synthesize what you learned. The models are good. The coordination is not.

I just shipped Polyphon v0.1.0-alpha.2 — a free, local-first desktop app that puts multiple AI voices in the same conversation so they can actually respond to each other. You're the conductor. They're the ensemble. Save a group of voices as a composition and reuse it whenever you need that ensemble again.

What should a multi-agent conversation feel like when you're not building a pipeline — when you just want to think out loud with several models at once?

Read more at https://coreydaley.dev/posts/2026/03/launching-polyphon-orchestrating-multiple-ai-voices/"""
tags = ["polyphon", "multi-agent", "electron", "ai-tools", "local-first", "desktop-app", "ai-orchestration"]
categories = ["AI", "Tools", "Automation"]
image = "launching-polyphon-orchestrating-multiple-ai-voices.webp"
aliases = ["/posts/launching-polyphon-orchestrating-multiple-ai-voices/"]
+++

{{< figure-float src="launching-polyphon-orchestrating-multiple-ai-voices.webp" alt="Orchestra conductor leading violinists with floating AI, cloud, and tech icons above." >}}
The most annoying part of using multiple AI models is not the models. It's the choreography.

If you regularly compare Claude against GPT, or bring in a local model, or bounce between an API-backed tool and a CLI-based one, you know the routine: repeat the prompt across tabs, wait for parallel replies, copy the strongest ideas into a scratchpad, then do the synthesis work yourself. The outputs can be excellent. The workflow to get them is still glue work — just manual enough to be discouraging, just repetitive enough that you skip it when you're busy.

That friction was what Polyphon is designed to eliminate.

## The Mental Model

Polyphon is built around three concepts. A **voice** is any AI participant — a hosted API model, a CLI binary on your machine, a local model through Ollama, a custom endpoint. A **session** is a shared conversation where multiple voices can respond across rounds and read each other's replies, which is what enables dialogue rather than parallel monologue. A **composition** is a saved ensemble configuration, so the group of voices that works well for a type of task is ready to load the next time you need it.

You are not just launching providers. You are arranging perspectives.

## What a Composition Looks Like in Practice

Here's a composition I use for technical decisions: Claude (Anthropic API) for reasoning through tradeoffs, Codex CLI for scrutinizing the implementation angle, and a local Llama 3 model via Ollama for faster first-pass drafts.

Send a prompt about whether to use an ORM or raw SQL for a new project. Claude reasons through coupling and schema flexibility. Codex flags edge cases in migration strategy. The local model throws out options without overthinking. Then I direct a follow-up at Claude — asking it to respond specifically to Codex's point. That exchange produces something none of the three models would have said alone.

That's the loop Polyphon makes native instead of improvised.

## Two Ways to Run a Conversation

Polyphon has two distinct modes, and they're genuinely different experiences.

**Directed mode** keeps you in the loop at every turn. You direct messages to specific voices using an `@mention` — ask Claude to respond to what Codex just said, then ask the local model to play devil's advocate, then pull the thread together yourself. You're the one deciding who speaks next and what they respond to. This is the right mode when the conversation needs steering, when you want to control the synthesis, or when you're working through something where you want your own judgment at every step.

**Broadcast with auto-continuation** is different. You send a prompt to all voices simultaneously, and then — if you configure the composition for it — the voices keep responding to each other across rounds without you having to prompt each turn. You set a round limit (up to 3 by default) so it can't spiral indefinitely, and you watch the exchange develop. This is closer to letting the ensemble play: you started it, you can intervene, but you're not conducting every note.

The round limit is worth calling out because it's not a technical guardrail — it's a deliberate design choice. Unconstrained model-to-model conversation is a good way to spend a lot of tokens going in circles. Capping it at a small number of rounds forces the conversation to stay purposeful. If you want more, you run another round manually.

## Shaping Each Voice Independently

A composition isn't just a list of models. Each voice can be configured separately before a session starts, which is where tones and system prompt templates come in.

**Tones** control how a voice communicates — its formality, verbosity, and conversational stance. Polyphon ships five built-in presets: Professional, Collaborative, Concise, Exploratory, and Teaching. You can also create your own: give it a name, a one-line description, and a behavioral directive that gets injected into the voice's system prompt. You can assign different tones to different voices in the same composition. A composition where one voice is set to Concise and another to Exploratory will produce very different exchanges than one where they're both running defaults. That differentiation is often where the interesting tension comes from.

**System prompt templates** let you give a voice a specific role or set of constraints — and you write them yourself. Save a prompt once — "Security Reviewer: look for injection vulnerabilities, auth gaps, and data exposure risks" — and attach it to any voice in any composition. The voice gets that context injected before every session, without you retyping it. Templates are snapshotted at session creation time, so editing a template later doesn't quietly change sessions you've already started.

Together, these two knobs let you build compositions where each voice has a distinct character and a specific job. The local model that runs fast and thinks loose gets the Exploratory tone. The Claude instance doing final review gets a "Senior Engineer" system prompt and a Concise tone. The composition becomes less a group of models and more a configured team.

## Conversation Is Different from Parallel Monologue

There's a meaningful difference between collecting several answers and letting several voices share a conversational frame.

When models can read each other's replies, you get a different shape of output. One voice can challenge an assumption another made. An implementation-focused voice can turn a high-level idea into concrete steps. A more skeptical voice can push back on a confident consensus. The value isn't diversity of answers in isolation — it's the interaction *between* answers.

Opening three browser tabs gets you three independent responses. Polyphon gets you a conversation. The difference is whether the models can actually react to each other, or just respond to you.

## Local-First as a Trust Decision

Polyphon sits in the middle of thought processes that are often unfinished, sensitive, or just personal. That made trust a design constraint, not a feature.

There is no Polyphon account. Sessions live in a SQLite database on your machine. API keys are read from environment variables — never stored by the application. If you use local models or CLI tools, everything stays within your own setup. If the project stopped moving tomorrow, the conversations and compositions you built would still be yours.

I think more AI products should make this trade. For a tool whose job is to help you think, local-first changes the emotional posture of the product. It feels less like sending your rough ideas into a service and more like maintaining your own instrument.

## The Technical Bets

Polyphon is an Electron desktop app. That gets raised every time, so: I wanted one cross-platform codebase, a UI stack I already move fast in, and direct access to Node APIs. For an alpha-stage local-first tool, that mattered more than framework purity.

The data layer uses Node's built-in `node:sqlite` module with raw parameterized SQL and no ORM. Counterintuitively, writing every query by hand produced a tighter schema than ORM-assisted design would have. You can't hide behind `findAll()` — being forced to be explicit makes you think clearly about what you're actually storing and why.

The voice provider architecture follows a simple registry pattern: every provider extends either an `APIVoice` or `CLIVoice` base class and registers itself. Adding a new voice provider doesn't touch the rest of the codebase. The goal was to get the core loop right and keep the extension model simple.

## What Alpha Honestly Means

The core experience is solid: multi-voice sessions, all three provider types (API, CLI, custom endpoints), compositions, tones, system prompt templates, conductor profiles. What I mean by alpha is rougher UX than I want, and a few things not shipped yet.

Session export — saving a transcript as Markdown, JSON, or plaintext — is first on the roadmap. A plugin system for third-party voice providers is right behind it.
The version number (v0.1.0-alpha.2) is honest. Not complete. Ready enough to be useful, and useful enough to learn from.

## Shipping Day

This is the first public release. Nobody has used it yet except me, so I don't have feedback to point to — just my own experience building with it and the use cases I designed it around. What I'm genuinely curious about is what people do with it that I didn't anticipate. The composition I keep reaching for is the technical-decisions one I described above, but I suspect the interesting use cases will look different from mine.

The product I thought I was building and the product that emerges from real usage are probably not identical. That's fine. That's what early access is for.

If you want to try it: [polyphon.ai](https://polyphon.ai). Free, no account required.

*What voices would you put in your first composition, and what problem would you trust that ensemble to solve?*

