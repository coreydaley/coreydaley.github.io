+++
author = "Claude Code (Claude Sonnet 4.6)"
date = "2026-03-23T19:35:00-04:00"
draft = false
title = "Polyphon's MCP Server Makes Your AI Ensemble a Native Agent Tool"
description = "Polyphon just shipped MCP server support, and it changes the product's role in a developer workflow. Instead of opening Polyphon as a UI you visit deliberately, your coding agent — Claude Code, Cursor, Codex CLI, GitHub Copilot, Windsurf, Gemini CLI — can now call into it directly and broadcast a prompt across your entire Claude + GPT-4o + Gemini ensemble in one shot. Here's what shifted, why the SessionEventSink abstraction made it possible, and when multi-model review is actually worth it."
summary = """Polyphon just shipped MCP server support, and it reframes what the tool actually is. You've been opening it as a UI. Now your coding agent — Claude Code, Cursor, Codex CLI, GitHub Copilot — can call into it directly and broadcast a prompt across your entire Claude + GPT-4o + Gemini ensemble in a single tool call.

The practical win is not just convenience. It is that you can package disagreement: three independent models, each with different priors, applied to the same question at once. Five tools, two CLI flags, one Settings toggle. The SessionEventSink abstraction is why this works without duplicating orchestration logic — desktop UI and headless agent calls run on the same engine.

Where in your workflow would paying for disagreement actually change a decision, rather than just produce a louder answer?

Read more at https://coreydaley.dev/posts/2026/03/polyphon-mcp-server/"""
tags = ["polyphon", "mcp", "multi-agent", "claude-code", "ai-tools", "ai-orchestration", "agent-workflows"]
categories = ["AI", "Tools", "Automation"]
aliases = ["/posts/polyphon-mcp-server/"]
image = "polyphon-mcp-server.webp"
+++

{{< figure-float src="polyphon-mcp-server.webp" alt="Hand pressing a button beneath a glowing arc with three AI interface screens arrayed behind it." >}}
When I shipped Polyphon a week ago, the pitch was: stop juggling tabs between Claude, GPT, and Gemini and run them all as voices in one shared session. It worked well as a UI you opened deliberately and ran like a conductor.

But the product was still a destination. You went to it. And in a day full of agent-driven coding workflows, "leave what you're doing to get a second opinion" is exactly the kind of friction that turns a useful thing optional.

MCP server support removes that seam.

With MCP, Polyphon stops being a place you go and becomes a capability your agent can invoke. Wire it in once and multi-model review is available from inside the workflow you're already running. Your coding agents — Claude Code, Cursor, Codex CLI, GitHub Copilot, Windsurf, Gemini CLI — can call into your saved compositions directly, without a context switch.

## The Best Use Case Is Not "Ask More Models"

The point is not that more output is inherently better. It is that you can package disagreement.

Single-model agents are confident by nature. That confidence is often warranted and occasionally wrong in ways that are hard to see from inside one context. A second and third model with independent priors creates pressure on the first answer. If all three converge on the same issue, that convergence carries real signal. If they diverge, the divergence itself is informative — it surfaces an assumption that was doing silent work.

That's why I keep reaching for this with code review.

Before shipping a PR, instead of asking Claude Code to review it and stopping there, I call a saved Polyphon composition with Claude, GPT-4o, and Gemini configured. I get three independent reads in one round trip: architecture, edge cases, API shape. One `polyphon_broadcast` call and they come back together.

I use it earlier in the cycle too. Before writing any code, I ask the ensemble a design question: "Given these constraints, should I use an ORM or raw SQL?" Sometimes the models converge. Sometimes the disagreement exposes a trade-off I hadn't made explicit — and that changes what I actually build.

Multi-model review is not free. It adds latency and token cost. Use it where disagreement is valuable — architectural decisions, code review, second opinions on tradeoffs — not as a reflex on every routine prompt.

## Why Polyphon Via MCP, Not Just Separate Model Tools

A reasonable question: if I already have Claude, GPT, and Gemini configured as separate MCP tools, why route through Polyphon?

The answer is what compositions give you. A composition is a saved ensemble configuration — specific models, specific voice settings, specific system prompts, specific tones. When you call `polyphon_broadcast`, you're not wiring three separate tool calls together in your agent's reasoning chain. You're calling one tool that already knows how to route to the ensemble, with all your preferences baked in, sharing a session history that persists across the conversation.

Configure the ensemble once, name it, and your agents reach for it by name. The "PR review ensemble" becomes a reusable capability your tools can invoke from anywhere.

## Local-First Still Applies

MCP mode doesn't change Polyphon's local-first posture. No account, no cloud sync, no key storage — all of that was true for the desktop UI and it's still true when an agent calls in. When your coding agent calls `polyphon_broadcast`, those prompts go from your machine to whatever model APIs you've already configured. Polyphon is the router, not an intermediary holding your data.

For a tool that handles unfinished ideas and mid-thought questions, that trust posture matters.

## What the MCP Server Exposes

The server is embedded in Polyphon — no extra daemon, no separate install. Two CLI flags control it: `--mcp-server` activates the protocol, `--headless` suppresses the GUI for use in agent scripts. There's also a toggle in Settings to auto-start the server when the app launches.

Five tools are exposed: `polyphon_list_compositions`, `polyphon_create_session`, `polyphon_broadcast`, `polyphon_ask`, and `polyphon_get_history`. That surface is small enough for an agent to use naturally, but complete enough to support both one-shot prompts and multi-turn sessions where you follow up with a specific voice.

## The Architecture Behind It: SessionEventSink

The interesting engineering decision that made this possible without duplicating logic is the **SessionEventSink** abstraction.

Originally, running a round and updating the GUI were part of the same flow. SessionEventSink separates orchestration from delivery, so the same engine can drive the desktop UI or return structured results to an MCP client. For the UI, events flow into the React renderer. For headless MCP calls, they're packaged as structured output for the calling agent.

Once that boundary exists, "desktop app" and "agent tool" stop being competing shapes and become two interfaces on the same capability. Agent-callable Polyphon and UI-driven Polyphon are the same Polyphon — same composition configurations, same voice settings, same conversation history.

## Getting Started

Add Polyphon to your MCP client's configuration. For Claude Code:

```json
{
  "mcpServers": {
    "polyphon": {
      "command": "/path/to/polyphon",
      "args": ["--mcp-server", "--headless"]
    }
  }
}
```

Or use Settings → MCP Server to auto-start it whenever the app launches. Once registered, call `polyphon_list_compositions` to see your saved ensembles and go from there.

Polyphon is still free, local-first, no account required: [polyphon.ai](https://polyphon.ai).

*Where in your workflow would paying for disagreement actually change a decision, rather than just produce a louder answer?*
