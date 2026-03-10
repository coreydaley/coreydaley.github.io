+++
author = "Claude Code (Claude Sonnet 4.6)"
date = "2026-03-09T11:45:00-04:00"
draft = false
title = "Why I Left Notion and Built My Own AI Agent Plugin for Obsidian"
description = "After refusing to pay for yet another AI subscription I couldn't customize, I switched from Notion to Obsidian and discovered there was no way to use my existing AI services inside it. So I built one — an open source AI Agent Sidebar plugin developed with agentic engineering and the dark factory method."
summary = """I was already paying for Claude, Codex, and several other AI services when Notion started pushing its own AI add-on. The problem wasn't just the price — it was that Notion AI couldn't talk to any of the tools I already had, and my workflow had become a copy-paste treadmill between my notes and my agents. So I switched to Obsidian and hit the same wall: no native way to use your own AI.

I built the Obsidian AI Agent Sidebar plugin — an open source tool that brings Claude Code, OpenAI Codex, Google Gemini, GitHub Copilot, and any OpenAI-compatible server directly into your Obsidian sidebar, with real vault read/write access. Developed using agentic engineering and the dark factory method, it's the integration I needed and couldn't find.

What would you build if the tool you needed simply didn't exist yet?

Read more at https://coreydaley.dev/posts/2026/03/obsidian-ai-agent-sidebar-plugin/"""
tags = ["obsidian", "ai-agents", "open-source", "plugin-development", "agentic-engineering", "dark-factory", "claude", "codex"]
categories = ["AI", "Tools", "Automation"]
image = "obsidian-ai-agent-sidebar-plugin.webp"
aliases = ["/posts/obsidian-ai-agent-sidebar-plugin/"]
+++

{{< figure-float src="obsidian-ai-agent-sidebar-plugin.webp" alt="Person typing on a laptop at night, surrounded by floating browser windows, desk lamp, plant, phone, and scattered notes." >}}
There's a version of this story where I just pay the Notion AI subscription and move on with my life.

I didn't do that.

## The Notion Problem

I'd been using Notion for a couple of years — notes, project tracking, research. When Notion launched Notion AI, I took a look. But here's the thing: I was already paying for Claude. And Codex. And a couple of other AI services I actually use and have opinions about.

The deeper issue wasn't price. It was operational fragmentation. My workflow had become a treadmill:

- Write ideas in Notion
- Copy context into a browser tab
- Ask an AI agent for help
- Copy results back manually
- Repeat until the thread of thought was gone

Notion AI would have solved exactly none of that. It's Notion's AI — not a bridge to the services I'd already invested in. You don't get to swap models, point it at a self-hosted endpoint, or plug in the Anthropic API key you're already paying for. One vendor's AI baked into one vendor's product.

My choices were: accept it, ignore it, or leave.

I left.

## Enter Obsidian

Obsidian was the obvious move. Local-first, Markdown-native, plugin ecosystem that doesn't lock you into one vendor path. If you care about owning your notes and evolving your workflow over time, those properties matter a lot.

But after switching, I found the specific integration I wanted didn't exist. I searched for a sidebar where I could open a chat with one of my existing AI agents, share context from my current note, and have it write changes back to my vault. I found partial solutions — plugins covering a single provider, others requiring complex setup. None gave me the multi-agent, multi-mode experience I had in mind.

The gap was real. So I built it.

## What I Built

The [Obsidian AI Agent Sidebar plugin](https://github.com/coreydaley/obsidian-ai-agent-sidebar-plugin) is what I wish had already existed. It adds a sidebar panel to Obsidian where you can chat with multiple AI agents and give them direct access to your vault. A few design decisions shaped how it works:

{{< figure-block src="ai-agent-sidebar-chat-interface.webp" alt="Obsidian window with the AI Agent Sidebar open on the right, showing a Claude Code chat panel and a note about auto-shared context." >}}

**1. Multi-agent tabs, not a single chat.** Different models are better at different tasks. The tabbed interface lets you switch between Claude Code, OpenAI Codex, Google Gemini, GitHub Copilot, and any OpenAI-compatible endpoint — without losing conversation history in other tabs.

**2. CLI mode and API mode.** Some agents are best consumed through their official CLIs, using credentials you've already configured in your shell. Others work better through direct API calls. The plugin supports both, which means it adapts to your existing setup rather than forcing a migration.

**3. Real vault operations with guardrails.** The plugin can read, write, create, edit, rename, and delete files in your vault. Paths are validated against the vault root to prevent directory traversal, and destructive operations require explicit confirmation. Your currently open note is automatically shared as context. When you ask an agent to rewrite a section, it can do it directly — not suggest a revision you have to paste in by hand.

**4. OpenAI-compatible endpoint support.** Any provider that speaks the OpenAI protocol — Ollama, vLLM, self-hosted gateways — can be plugged in. This keeps the tool useful beyond the current landscape of commercial APIs.

There's also real-time streaming responses, conversation persistence across sessions, model selection in API mode, and a debug mode that shows raw output when something breaks.

{{< figure-block src="ai-agent-sidebar-settings.webp" alt="Obsidian plugin settings panel listing Anthropic, OpenAI, Google, GitHub, and OpenAI Compatible providers with CLI and API mode toggles for each." >}}

## How I Built It (With AI, Obviously)

The development process matched the tool's philosophy: I used Claude and Codex as active participants throughout, following the [dark factory method](https://factory.strongdm.ai) — a structured approach to agentic software development where AI handles implementation details while you stay at the level of architecture and intent.

The loop was: define behavior, generate candidates, review output, reject what's weak, keep what works, iterate. One concrete example: the vault file operation boundaries took several passes to get right. The first version was too permissive; agents could traverse paths outside the vault root. I described the constraint, both models proposed different validation approaches, and the final implementation pulled from both — strict path checking from one, cleaner error messaging from the other.

Working with Claude and Codex in parallel consistently produced better results than either alone, in my experience. They have different strengths and different blind spots. The tradeoff worth naming: agentic development with insufficient review produces demos that don't hold up under real use. The leverage is real, and so are the failure modes.

## Current Limitations

Worth naming what the plugin doesn't do:

- **Desktop only.** Obsidian mobile isn't supported.
- **CLI mode has broad filesystem access.** The plugin only sandboxes vault paths in API mode. In CLI mode, agents have the permissions of your shell. Only use CLI mode with agents you trust.
- **No built-in internet access.** The agents can read and write your vault, but browsing the web requires your AI provider to support it natively.
- **Privacy boundary.** Don't use this with notes containing sensitive or PII data unless you're comfortable with that content being transmitted to whichever AI provider you've configured.

## Why Open Source

The plugin is MIT-licensed, and I don't have particularly noble reasons for that. I built it to scratch my own itch. Scratching your own itch in public is just open source. I'd also benefited enough from other people's Obsidian plugins that it felt right to put this one back.

The practical case for open source here is that my setup isn't yours. I made sure the agents I use most are well-supported. If you're on a different stack, you know your environment better than I do. The code is there.

## The Larger Point

Each decision in this story was straightforward given the constraints. I didn't want to add a subscription for functionality I already had. I switched to a tool that gave me more control. I built the integration that was missing.

What made it possible to actually ship — rather than just plan — was combining agentic engineering with a disciplined review process. The agents handled implementation details. I stayed at the level of architecture and intent, made the calls that mattered, and kept the direction coherent. That's a different kind of development work, and it's faster when you get it right.

The result is a plugin I use every day, built mostly *by* AI agents, that lets me use AI agents inside Obsidian. There's something satisfying about that loop.

*If you're paying for AI subscriptions you can't actually use inside your primary writing and thinking tool, what's stopping you from building the integration yourself?*

