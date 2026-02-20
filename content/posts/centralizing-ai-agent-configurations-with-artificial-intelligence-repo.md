+++
author = "Claude Code (Claude Sonnet 4.6)"
date = "2026-02-19T20:26:46-05:00"
draft = false
title = "Centralizing AI Agent Configurations with the ai-config Repository"
description = "Discover how to manage Claude, Codex, and GitHub Copilot configurations from a single source of truth. The coreydaley/ai-config GitHub repository provides a centralized home for agent instructions, reusable skills, custom commands, subagents, and prompts—with a simple Makefile-based setup that symlinks everything into place across your AI tools."
summary = "If you're juggling Claude Code, Codex, and GitHub Copilot, you know the pain of keeping each one's configuration files in sync. My ai-config repo solves that with a single source of truth: agent instructions, reusable skills, custom commands, subagents, and prompts all live in one place, and a single `make symlinks` command wires them up across every tool. Each directory is purpose-built—skills for reusable capabilities, commands for CLI tools, subagents for delegation, prompts for task-specific guidance. The setup even backs up any files it would overwrite, so you never lose existing config. Whether you're just starting to extend your AI tools or already deep into custom workflows, having everything version-controlled and centralized is a game changer. Are you managing your AI agent configurations in a single repository, or do you keep them scattered across tools?"
tags = ["ai", "developer-tools", "claude-code", "github-copilot", "codex", "workflow", "automation", "open-source"]
categories = ["AI", "Tools", "Automation"]
image = "/images/posts/centralizing-ai-agent-configurations.webp"
+++

{{< figure-float src="/images/posts/centralizing-ai-agent-configurations.webp" alt="Three robots labeled Claude, Codex, and Copilot building with colorful wooden blocks on a workshop table" >}}

If you use more than one AI coding agent—Claude Code, GitHub Copilot CLI, OpenAI Codex—you've probably run into the configuration sprawl problem. Skills live in one place, custom instructions in another, and every agent has its own conventions for where to find them. My [ai-config repository](https://github.com/coreydaley/ai-config) is my answer to that problem: a single, version-controlled home for everything that shapes how my AI agents think and behave.

## What the Repository Does

At its core, the repo is a centralized store for five categories of AI configuration:

- **Agent Configurations** — instructions and behavioral guidelines specific to Claude, Codex, and Copilot
- **Reusable Skills** — specialized capabilities that any agent can leverage
- **Custom Commands** — CLI tools and utilities agents can call
- **Subagents** — specialized agents that primary agents can delegate work to
- **Custom Prompts** — task-specific prompts that don't fit neatly into the other categories

Each category lives in its own top-level directory, documented by its own README. The structure is intentionally simple so adding new resources stays friction-free.

## The Directory Layout

```
ai-config/
├── agents/      # Per-agent and shared (GLOBAL.md) configuration
├── skills/      # Reusable capabilities shared across agents
├── commands/    # CLI commands and scripts agents can invoke
├── subagents/   # Specialized agents for delegated work
├── prompts/     # Task-specific prompts
└── scripts/     # Symlink setup utilities
```

The `agents/` directory is where the personality of each tool lives—custom instructions, capability notes, tool integrations, and context that shapes how that agent responds. A `GLOBAL.md` file at the root of `agents/` holds settings that apply across all three agents.

## Getting Set Up: One Command

The repository ships with a `Makefile` that wires everything up with a single command:

```bash
make symlinks
```

Under the hood this runs four scripts that create symlinks from your home directory (or wherever each agent looks for configuration) into the repository:

```bash
make symlink-agents      # Agent configs
make symlink-skills      # Shared skills
make symlink-commands    # Custom commands
make symlink-subagents   # Subagent definitions
```

The scripts handle the one thing that always trips up symlink setups: what to do when a file already exists at the destination. Rather than silently overwriting or bailing out with an error, each script **backs up the existing file** by renaming it with a `.old` extension before creating the new symlink. You never lose existing configuration, and the new symlink takes effect immediately.

## Why This Architecture Works

### Version Control Across All Agents

Because everything lives in a single Git repository, changes to agent instructions are tracked, reviewable, and reversible. If a new prompt breaks something, `git diff` shows you exactly what changed and `git revert` gets you back in seconds.

### Consistency Without Duplication

The `GLOBAL.md` file in `agents/` lets you define settings once and have them prepended to every agent's configuration. Common instructions—like how to format commit messages, which directories are off-limits, or what coding standards to follow—live in one place rather than being copy-pasted and inevitably drifting out of sync.

### Composable Skills and Commands

The `skills/` and `commands/` directories encourage you to think of agent capabilities as building blocks. When you solve a problem once—say, a prompt that reliably structures database migrations—you capture it in a skill file and every agent benefits. The same logic applies to custom commands: write the shell script once, symlink it everywhere.

### Delegation via Subagents

The `subagents/` directory enables a pattern that has become central to how I work: primary agents delegating specialized tasks to purpose-built subagents. Instead of one agent handling everything, you can define a "research subagent," a "test-writing subagent," or a "documentation subagent," each with its own focused instructions. The primary agent stays lean and routes work appropriately.

## Compatibility Caveat

Not every resource in the repository works with every agent. Claude, Codex, and Copilot each have different conventions for reading skills and commands, and some capabilities are agent-specific. The repository's README is upfront about this: always verify compatibility before relying on a resource in production. This is an honest reflection of where multi-agent tooling stands today—there's no universal standard yet, which is part of what makes organizing things this way valuable: when standards do converge, your configuration is already centralized and easy to migrate.

## Getting Started

```bash
# Clone the repository
git clone https://github.com/coreydaley/ai-config.git
cd ai-config

# Review the structure and READMEs, then wire everything up
make symlinks
```

After that, each agent will pick up the shared configuration, skills, and commands. From there, the workflow is additive: when you solve a new problem or develop a new pattern, drop it in the right directory and it's immediately available everywhere.

---

*As AI agents become more deeply embedded in how we write, code, and create, the question of how to manage their configuration at scale becomes increasingly important. Are you keeping your AI agent configurations centralized in a repository, or do you manage each tool's settings separately—and how's that working for you?*
