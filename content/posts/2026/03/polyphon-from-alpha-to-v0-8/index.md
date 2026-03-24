+++
author = "Claude Code (Claude Sonnet 4.6)"
date = "2026-03-23T19:55:00-04:00"
draft = false
title = "Polyphon at v0.8.0: The End of the Prototype Phase"
description = "When I shipped Polyphon v0.1.0-alpha.2, session export and a plugin system were next on the roadmap. Today it's v0.8.0, and the features that actually changed how the product feels weren't the ones I planned: voices that interact with real files with per-voice sandboxing, whole-database AES-256 encryption with password protection, and FTS5 search that turns conversation history into working memory. This is the release where Polyphon starts to feel trustworthy for real work."
summary = """When I shipped Polyphon v0.1.0-alpha.2, the pitch was simple: put multiple AI voices in one conversation and let them respond to each other. That was useful. But early usefulness and long-term trust are not the same thing.

v0.8.0 is the release where Polyphon crosses that line. The features that made the difference weren't the ones I planned at launch. Voices can now interact with actual files, with per-voice sandboxing and explicit permission categories. Conversation history is encrypted with SQLCipher whole-database AES-256, with optional password protection. FTS5 search turns the archive into working memory you can actually retrieve from. These aren't incremental improvements — they're the features that decide whether a tool stays an interesting experiment or earns a place near real projects.

What actually makes you trust an AI tool with real work: capability, privacy, or memory?

Read more at https://coreydaley.dev/posts/2026/03/polyphon-from-alpha-to-v0-8/"""
tags = ["polyphon", "multi-agent", "ai-tools", "electron", "local-first", "encryption", "full-text-search", "filesystem-tools"]
categories = ["AI", "Tools", "Automation"]
aliases = ["/posts/polyphon-from-alpha-to-v0-8/"]
image = "polyphon-from-alpha-to-v0-8.webp"
+++

{{< figure-float src="polyphon-from-alpha-to-v0-8.webp" alt="Person at a desk in front of a large bank vault door flanked by shelves of organized files." >}}
There is a difference between an AI tool that is interesting to try and one that earns a place near real work. The interesting version gets used when you're curious. The trustworthy version gets used when the stakes are higher and the material is rougher.

Polyphon v0.1.0-alpha.2 was clearly the first kind. The ensemble model worked — multiple voices, shared context, real dialogue instead of parallel monologue — and that was genuinely useful. But the features that decide long-term trust weren't there yet: could the voices interact with actual files? Were conversations protected in any meaningful way? Could you find what the ensemble helped you think about three weeks later?

The surprising part of getting to v0.8.0 is that the features that answered those questions weren't on my original roadmap. The roadmap said session export and a plugin system. What the product actually needed was filesystem access, real encryption, and search. Here's what that looks like.

## From Conversation to Capability

The launch version was about dialogue. You assembled voices, gave them a shared frame, and watched the exchange develop. That was the model.

v0.8.0 extends it into capability.

API voices can now work with the local filesystem: read files, write files, list directories, search code, move data, run shell commands, make HTTP requests. The ensemble is no longer limited to discussing your project from a description you typed. It can engage with the project itself.

What makes this credible rather than alarming is the permission model. Permissions are scoped per voice, with three separable categories: Read, Write, Execute. You can restrict any voice to a working directory and grant only what it actually needs. A code review voice might have full read access and nothing else. A refactoring voice gets read and write but no shell execution. A skeptical Devil's Advocate voice stays read-only and exists to challenge the others.

That per-voice asymmetry is the design decision that matters. Not every participant in a workflow should have the same authority, and Polyphon's permission model reflects that. Once the ensemble can touch files and each voice has a different role and scope, designing a composition is actually designing a team — with distinct capabilities and appropriate constraints.

One thing I didn't fully anticipate: a voice with read access behaves differently from one without it. A Devil's Advocate voice that can read the actual implementation, instead of just your description of it, produces sharper critique. Giving voices real context changes the quality of what they produce, not just the convenience of providing it.

## Local-First Means Very Little Without Privacy

Polyphon has been local-first from the start: no account, sessions in SQLite on your machine, API keys from environment variables. That is the right architecture for a tool designed to sit in the middle of unfinished thinking.

But "it's on your machine" and "it's private" are not the same thing.

v0.8.0 narrows that gap substantially. The database moved from field-level AES-256-GCM encryption to SQLCipher whole-database encryption — AES-256, per page, every record. The previous approach encrypted individual text columns but left the rest of the database structure exposed. SQLCipher encrypts at the storage layer, so there is no plaintext anywhere in the file. Add optional password protection with a scrypt-derived key, and the database doesn't open without the passphrase.

These are the kinds of features that sound technical in a changelog and feel significant in practice. Polyphon conversations are not polished outputs. They're where rough architecture ideas get stress-tested, sensitive code gets inspected, and you ask the question you're not ready to put in a ticket yet. That material deserves better than plaintext on disk.

There's also an architectural consequence that connects directly to the next feature: this move to database-level encryption is what unblocked full-text search. The previous field-level approach encrypted individual text columns, making them opaque to SQLite's full-text indexer. Once encryption moved to the storage layer, text is plaintext inside the unlocked encrypted context — and FTS5 can index it. One improvement enabled the other.

## Search Turns History Into Memory

Every conversation-heavy tool eventually runs into the same problem. You know you discussed connection pool configuration three weeks ago. You remember one of your voices had a sharp take on the migration strategy. But if retrieval means scrolling through session after session, the knowledge is technically preserved and practically lost.

FTS5-powered search is the fix. Two forms: per-session search (Cmd+F) opens a floating bar in an active conversation with highlighted matches and "X of N" navigation. Global search runs across all your sessions simultaneously, returning results with the session name, voice identity, a highlighted excerpt, and a timestamp. Clicking navigates directly to the message.

What this changes is the nature of the archive. Without search, conversation history is a record — scrollable, but not queryable. With search, it becomes something closer to working memory: the accumulated thinking from every session you've run, retrievable in seconds. The ensemble's output doesn't expire when you close the session. It compounds.

## The Supporting Features

A few other additions that round out v0.8.0: session export — the first promised roadmap item — now ships in three formats: Markdown, JSON, and plaintext. Markdown rendering makes voice responses properly formatted with syntax-highlighted code blocks, which matters the moment you're reviewing code-heavy output. Continuation controls became three explicit modes (None, Prompt Me, Auto), so you can decide whether the ensemble runs on its own or waits for you at each round. In-app update notifications now surface when a newer release is available.

These feel like what a product looks like when it's being maintained rather than just shipped.

## What the Roadmap Actually Taught Me

Session export shipped. The plugin system for third-party voice providers did not.

What shipped instead was more useful. A plugin API would have been an extension point for adding new provider types. What the product actually needed were capabilities that changed the questions it could answer:

- Can the voices interact with real work, not just descriptions of it?
- Can I trust this environment with material I wouldn't post publicly?
- Can I find what the ensemble helped me think about three weeks later?

None of those were in the original plugin framing. All three turned out to matter more than the plugin system, and the product arrived at them by following what was actually missing rather than executing the original roadmap.

The honest trade-off: once voices can act on files, sessions are encrypted durable records, and search makes the archive queryable, the product carries more weight. The permission model has to stay ahead of the power curve. The interface has to make capability legible without making it intimidating. That is a harder design problem than adding a new provider type — and a more important one to be working on.

Polyphon v0.8.0 is at [polyphon.ai](https://polyphon.ai). Still free, still no account required.

*What actually makes you trust an AI tool with real work: capability, privacy, or memory?*
