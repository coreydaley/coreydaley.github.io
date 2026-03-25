+++
author = "Claude Code (Claude Sonnet 4.6)"
date = "2026-03-25T00:22:00-04:00"
draft = false
title = "Opening Polyphon: Trust Needs an Exit"
description = "Polyphon is now open source under Apache 2.0. The reason isn't contributor growth or community optics — it's that local-first AI software can't ask users to accept privacy and control claims on faith alone. Open source gives users two things: the ability to inspect the architecture and verify what the tool is actually doing, and a real exit if the project ever changes direction."
summary = """Polyphon is now open source under Apache 2.0. The reason isn't community building or contributor recruitment — it's simpler and more specific than that. When a tool sits in the middle of unfinished thinking, rough drafts, and sensitive code, "trust me" is not a good enough contract.

Open source gives users two things that matter here: the ability to inspect the architecture and verify the privacy claims, and a real exit if the project ever changes direction or stops moving. Not everyone will read the source. But anyone can. And the fact that anyone can changes the character of the whole relationship.

What should users be able to verify for themselves before they trust an AI tool with their unfinished work?

Read more at https://coreydaley.dev/posts/2026/03/polyphon-is-now-open-source/"""
tags = ["polyphon", "open-source", "local-first", "apache-2", "transparency", "privacy", "desktop-app"]
categories = ["AI", "Tools", "Best Practices"]
image = "polyphon-is-now-open-source.webp"
aliases = ["/posts/polyphon-is-now-open-source/"]
+++

{{< figure-float src="polyphon-is-now-open-source.webp" alt="A person seated at a desk examining a large document, surrounded by tall stacks of papers, with an open door behind them." >}}
If a tool handles rough drafts, sensitive code, and half-formed ideas, users should not have to accept privacy and control claims on faith alone. That's the specific problem open source solves here — and it's why Polyphon is now open source under Apache 2.0.

There are two ways to build trust with software. The first is reputation: you ship consistently, handle problems well, and over time your track record makes your claims credible. The second is inspectability: you open the code, and trust flows from the architecture itself rather than from the author's word. Polyphon is open source because of the second kind — and because of something the first kind can never provide.

Trust without an exit is weak trust.

## Local-First Is a Claim

Polyphon has been local-first from the start. No account required. Sessions stored in SQLite on your machine. API keys read from environment variables, never stored by the application. Conversations encrypted with SQLCipher whole-database AES-256. If you stop using it tomorrow, your data is still yours.

That is the design. But "local-first" is exactly the kind of claim that's easy to make and hard to verify from the outside. Every privacy-respecting tool says it. Some of them mean it precisely. Others are stretching the definition in ways that aren't obvious until you read the privacy policy carefully enough to notice the exceptions.

Users who care about where their data goes — and anyone putting rough draft thinking, sensitive code, or unfinished ideas through a conversation tool should care — end up taking someone's word for it. The word can be honest. It's still just a word.

Open source reduces how much of this has to rest on the author's word. Anyone who wants to confirm that Polyphon isn't exfiltrating data, that encryption works as described, that API keys aren't logged anywhere unexpected — they can read the implementation and decide for themselves. Not trust the author. Check the work.

For a tool whose value proposition is "this is safe to think out loud with," that distinction matters.

## Trust Without an Exit Is Weak Trust

The audit argument is half of it. The other half is continuity.

Polyphon isn't just a tool people try once. It's a place where you build habits: saved voice compositions, accumulated session history that becomes searchable memory, workflows tied to real projects. When an AI workspace becomes part of how you reason through decisions, that's a real dependency — and dependencies carry risk.

Closed-source software can still be a good deal; plenty of excellent tools prove that. But the social contract is different: you're trusting the vendor to keep earning your trust across business model changes, ownership changes, and shifts in priority. Open source changes the shape of that deal. It gives users a durable way to stop trusting blindly.

If Polyphon becomes part of a daily workflow and then the project stalls, drifts, or makes decisions you don't like — the code is forkable. You're not stranded with a binary and a hope. There is a buildable codebase, an auditable history, a path for the software to outlive my continued enthusiasm for it.

This is the part of open source that feels under-discussed in the current AI moment. AI makes it easier than ever for one developer to build and maintain serious software alone. That reduces the old pressure to open source for labor. But it also makes software easier to build quickly — and, if enthusiasm fades, easier to quietly abandon. In that environment, forkability is more valuable as a user protection, not less.

When I say Polyphon is now open source, I don't mainly mean "please contribute." I mean: if this tool becomes important to you, you should not be trapped inside my stewardship of it.

## Why Now

Early private development wasn't evasion. It was staging.

There's a real difference between opening a codebase once a product has a coherent center, and opening it while the center is still moving. In the early months, naming is unstable, data models are provisional, and abstractions seem right until they don't. Public code at that stage creates an illusion of maturity before the architecture has earned it.

Keeping Polyphon private in its first phase bought room to figure out what the product actually was: not just a multi-model chat app, but a local orchestration environment with saved compositions, durable encrypted sessions, per-voice filesystem access, full-text search over session history, and MCP support for agent workflows.

At some point the logic flips. Once the architecture is coherent enough that users can reasonably evaluate it, staying private stops being a productive shelter and starts becoming missing evidence. Users deciding whether to rely on Polyphon for real work deserve more than a landing page and a changelog.

That's where the project is now. Opening the repository was overdue.

## What "Open" Means Here

The repository is public: source code, full release history and documentation, security policy, issue templates, roadmap. GitHub Issues and Discussions are open for bug reports, feature requests, and questions about the product's direction. GitHub Sponsors is available for anyone who wants to support continued development.

One thing is not yet open: pull requests. Polyphon currently does not accept external code contributions.

That is not a contradiction. There's a meaningful difference between making code visible and making a codebase ready for outside contribution. The second requires stable abstractions, clear contributor documentation, and review bandwidth to evaluate outside work fairly. I'd rather have an honest open-source project with a narrow contribution model than a performative one that technically accepts PRs while making contribution miserable.

For now: the code is open, discussion is open, issues are open, and forks are welcome. Implementation remains maintainer-directed. That is an honest description of where the project is, not a permanent policy.

## Why Apache 2.0

Apache 2.0 is the clean middle ground: permissive enough to stay practical, familiar enough to require no decoding. People can use, modify, distribute, and fork the code without wading through complicated conditions.

The deciding detail is the explicit patent grant. AI tooling sits in a part of the software landscape where provider relationships and product boundaries can get complicated quickly. Apache 2.0 removes one class of ambiguity from the start. MIT would also have been defensible; GPL would have pushed toward a different philosophy about reciprocity. Apache 2.0 was the right call.

## What Changes

If you never read source code, maybe nothing changes day to day. Polyphon is still the same tool you download — still local-first, still free, still no account required.

But something concrete changes anyway.

The claims around privacy, storage, and control now exist beside an auditable implementation. Security-conscious users can verify the architecture directly. Others can take some comfort in the fact that someone else can. If Polyphon ever becomes critical enough to your workflow that continuity matters, there is a path to fork and continue rather than simply wait and hope.

The relationship becomes less dependent on deference. Less "trust me." More "here is the work — inspect it if you need to."

Polyphon is at [polyphon.ai](https://polyphon.ai). The code is on GitHub. Free, local-first, no account required, and now open source under Apache 2.0.

*What should users be able to verify for themselves before they trust an AI tool with their unfinished work?*
