+++
author = "Claude Code (Claude Sonnet 4.6)"
date = "2026-03-19T14:15:00-0400"
draft = false
title = "Free Doesn't Mean Open: How AI Is Unbundling the Open Source Bargain"
description = "For decades, 'free software' and 'open source' were nearly synonymous — because building something worth sharing required a community. AI has dissolved that constraint. But the story isn't that open source is dying. It's that open source used to do five jobs at once, and AI is separating those threads. Some become less necessary. Others become more critical than ever."
summary = """Open source was never really about the license. It was about economics — no single developer could build everything alone, so you shared the source and let the community help carry the load. AI is making that trade less necessary.

With Claude Code and Codex, a solo developer can now ship and maintain classes of software that once required a contributor community. A new model is taking shape: users file issues, maintainers decide what's worth building, AI does the implementation. No PRs to review, no design debates in GitHub comments. Meanwhile, tools like Obsidian prove free software doesn't require open source — and have for years. The question is no longer whether to open source, but which parts of the open source bargain still matter to you.

But here's the counterintuitive part: AI also makes some open source values more important, not less. When software can be shipped and abandoned faster than ever, forkability, auditability, and portability become user protections that matter more. The future isn't open vs. closed — it's deliberate vs. reflexive.

Read more at https://coreydaley.dev/posts/2026/03/is-open-source-dead-in-the-age-of-ai/"""
tags = ["open-source", "ai", "claude-code", "codex", "maintainer-burnout", "software-development", "community", "obsidian"]
categories = ["AI", "Best Practices", "Tools"]
image = "is-open-source-dead-in-the-age-of-ai.webp"
aliases = ["/posts/is-open-source-dead-in-the-age-of-ai/"]
+++

{{< figure-float src="is-open-source-dead-in-the-age-of-ai.webp" alt="A person in a suit works at a desk while a robotic arm with blue and orange cables reaches toward them." >}}
For most of computing history, "free software" and "open source" were nearly synonymous — not because of ideology, but because of economics. No single developer could build everything worth building. You shared the code because you needed the help.

AI is starting to change that equation. But the story isn't that open source is dying. It's something more interesting: AI is unbundling the jobs open source used to do all at once.

## What Open Source Actually Does

When people talk about open source, they often slide between meanings without noticing.

Sometimes they mean **collaboration**: other people can help build and maintain the thing. Sometimes they mean **transparency**: you can inspect what the software is doing. Sometimes they mean **portability**: if the maintainer disappears, you can fork it and keep going. Sometimes they mean **distribution**: free access drives adoption and ecosystem growth. And sometimes they mean **identity**: this is the kind of project this is, and the kind of builder I am.

For decades, those functions reinforced each other. Opening the source code often helped with all five at once. That made open source feel like an obvious default for independent developers who needed help spreading the maintenance burden. And underlying all of it was a scarcity assumption: implementation is expensive, and no one person can do it alone indefinitely.

AI is attacking that scarcity assumption directly.

## The Scarcity That Disappeared

Software takes an unreasonable amount of labor. Bugs need finding. Features need implementing. Documentation needs writing. A single maintainer burns out. The model that emerged was elegant: release the source, let people self-organize around problems they care about, and the project advances faster than any individual could sustain.

With strong AI coding tools, one person can now ship and maintain classes of software that used to require a small team or a contributor community. Not for every category of software — broad infrastructure, security-critical systems, and multi-platform ecosystems have limits where that's still not true. But for focused apps, developer utilities, and consumer tools, the constraint that made contributor communities structurally necessary is weakening fast.

Once that constraint loosens, the default question changes. It used to be: *Why wouldn't I open source this?* Now it's: *Which part of open source do I actually need?*

That is a more uncomfortable question for the culture, because it forces precision.

## But AI Also Makes Open Source More Important In Some Ways

This is the counterargument worth taking seriously, because it's correct.

AI doesn't only empower maintainers. It also increases the pace at which software gets built, shipped, and abandoned. When one developer with an AI can launch a tool that competes with an established open source project, trust gets thinner and evaluation gets harder.

In that context, some open source values become more important, not less.

**Transparency** matters more if you're running code in sensitive environments — especially code that may have been AI-generated and never deeply reviewed by a human.

**Forkability** matters more when the pace of new products accelerates the pace of abandoned products. A beloved tool gets acquired, the pricing changes, the maintainer moves on — the ability to fork and continue is user insurance against any of those outcomes.

**Auditability** matters more as the volume of AI-generated code increases and the fraction that any human has understood end-to-end decreases.

**Community ownership** matters more once a tool becomes critical infrastructure rather than a nice side project.

AI weakens open source as a labor-acquisition strategy. It doesn't weaken open source as a trust and resilience strategy. Those are different things, and treating them as the same thing is how you end up with conclusions that overshoot.

## A New Collaboration Model

When you don't need the community to write code, you can still give the community a meaningful role — it just looks different.

The old model: user encounters a bug → files an issue → waits → hopes a contributor picks it up → reviewer debates the approach → PR gets merged or quietly abandoned → months pass.

The new model: user encounters a bug → files an issue → maintainer decides if it's worth fixing → AI diagnoses and implements the fix → user gets it in the next release.

No PR review cycle. No contributor onboarding. No "this isn't the right approach" debate while the user is blocked. The community still shapes direction through issues, feature requests, and use-case explanations. The maintainer still has to decide what matters. But the implementation gap closes in an afternoon rather than a quarter.

There is something lost in this model. When contributors can't send code, you lose external perspectives, shared ownership, and the learning that contributors get from working inside a codebase. For community-critical tools — where legitimacy requires demonstrating that multiple parties have eyes on the work — the PR model has a trust function that isn't just overhead. The new model works better for some projects and worse for others. It's worth naming both.

For maintainers, though, the reduction in coordination cost is real. Reviewing PRs that don't quite fit the project's vision. Having the same design debate five times with five different contributors. Diplomatically declining a well-intentioned contribution you can't merge. Maintainer burnout is one of the most predictable failure modes in open source; the volunteer labor model was never designed to be sustainable indefinitely. AI doesn't eliminate maintenance — it makes it more tractable for one person.

## Free ≠ Open Source

What often gets forgotten: **giving your software away has never required releasing the source.**

Obsidian is a useful proof of concept. It's free for personal use, extraordinarily popular, has a vibrant plugin ecosystem built on public APIs, and is not open source. The company offers Obsidian Sync and Obsidian Publish as paid services to fund development. Users get a free, high-quality tool. The company retains full control over product direction. Nobody calls this a moral failure.

Obsidian isn't alone. Similar patterns exist across productivity tools, developer utilities, and consumer apps: free at the base tier, paid for advanced features or sync, source closed. The assumption that "if you care about your users, you'll open source it" was always more tribal norm than logical necessity.

The interesting shift AI creates is that once you can build and maintain a serious tool without contributors, that assumption becomes visibly optional rather than quietly backgrounded.

## The Future Is Probably Layered

Most successful projects may settle somewhere between traditional open source and fully closed — and the variety of middle positions is wider than the binary framing suggests.

Closed core, open plugin system. Source-visible with restricted contributions. Open local data formats, closed sync service. Open protocol, proprietary client. A project that starts closed while moving fast, then opens once the architecture stabilizes.

These hybrids used to feel compromised. In an AI-assisted world, they may just be precise. Builders are making deliberate choices about where they want collaboration, where they want control, and where users need guarantees. The old rhetorical shortcut — where "open source" implied all the good things at once — is getting harder to sustain.

We don't have a great name for the fully closed end of this spectrum yet. "Freeware" implies abandonment. "Source available" implies restriction rather than AI-maintenance. "Community-directed closed source" describes the shape accurately but no one is going to say that. Whatever the name, the model is clear: free to use, community input through issues, maintainer judgment over what gets built, AI doing the implementation. It's a different social contract from open source — but not obviously worse for end users.

## Is Open Source Dead?

No. But the reason to choose it is changing.

Open source is at its strongest when the choice is deliberate: because a project should outlive any one company, because a tool needs public trust, because a standard needs shared ownership, because a platform should be extensible, because users deserve an exit. Linux isn't going anywhere. OpenSSL isn't going anywhere. The cases where openness is the right answer remain real.

What AI is killing is the default assumption that open source is always the right answer for free software. Developers who used to open their repos by reflex — because they needed the help, because it was simply what you did — will increasingly have to ask themselves which part of the open source bargain they actually mean to preserve.

The ones who choose it deliberately may produce projects that are open for sharper, more durable reasons than the ones that got opened simply because building alone used to be too hard.

That sounds less like a death and more like a sorting process.

*If you started a free side project today, would you open source it for collaboration, for trust, or for user escape hatches — and does the answer change when you have AI to help you build it alone?*

