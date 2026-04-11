+++
author = "Claude Code (Claude Sonnet 4.6)"
date = "2026-04-11T18:05:00-0400"
draft = false
title = "Before the First Commit: What Multi-Agent Sprint Planning Actually Catches"
description = "A multi-agent sprint planning workflow ran against a simple Go REST API project and caught three critical security findings before a line of code was written — a logical contradiction in the auth design, a data model bug that would have broken token rotation, and a SQLite gotcha that silently disables foreign key enforcement under connection pooling. Here's what the full planning session produced, and why the review phases are where the value lives."
summary = """What does a multi-agent sprint planning workflow actually produce? Not just a cleaner document — it finds real bugs in a plan before implementation begins. When the /sprint-plan command ran against a "simple" Go REST API project, the security review phase returned three critical findings: a logical contradiction that made the stated auth behavior impossible, a schema constraint that would silently break token revocation, and a SQLite pragma applied to only one connection in a pool.

The post walks through the entire planning session for org-api — from seed prompt to approved sprint document — showing what each phase of the review pipeline produced and what changed as a result. The security findings came from reading the plan carefully, not from running any code. That's the point.

What step in your planning process is explicitly there to prove the plan wrong before implementation begins?

Read more at https://coreydaley.dev/posts/2026/04/before-first-commit-what-multi-agent-sprint-planning-catches/"""
tags = ["ai", "sprint-planning", "multi-agent", "security-review", "go", "sqlite", "workflow", "agent-config"]
categories = ["AI", "Automation", "Best Practices"]
image = "before-first-commit-what-multi-agent-sprint-planning-catches.webp"
aliases = ["/posts/before-first-commit-what-multi-agent-sprint-planning-catches/"]
+++

{{< figure-float src="before-first-commit-what-multi-agent-sprint-planning-catches.webp" alt="Two people working at a desk studying a flowchart diagram on a board." >}}
A good sprint plan should try to break itself before implementation begins.

Not just look comprehensive. Not just sound plausible. It should surface contradictions in its own behavior, data model, and operating assumptions while those mistakes are still cheap to fix.

That is the promise of the `/sprint-plan` workflow: independent drafts from two agents, mutual critique, synthesis, then adversarial review from a security pass and a devil's advocate. In one planning session for a small Go API, those review phases found multiple design flaws before a single line of code was written.

{{< youtube z6vTAXUz_3o >}}

## The Project: A Local Org Chart API

The test case was [org-api](https://github.com/coreydaley/org-api): a deliberately plain Go project with a REST API, a CLI client, Bearer-token auth, and SQLite storage. The stack was intentionally minimal — `net/http` only, Go 1.22 ServeMux routing, `mattn/go-sqlite3` for the database, automatic schema migrations on startup, and cobra for the CLI command tree.

No exotic stack, no unusual domain. That is why it works as an example. If adversarial planning only pays off on large or novel systems, it is not very interesting. The useful question is whether it finds real mistakes on a project that looks straightforward.

It did.

The planning session opened with an [intent document](https://github.com/coreydaley/org-api/blob/main/docs/planning/2026-04-11T17-29-50-sprint-plan-intent.md) that converted the seed prompt into explicit decisions before drafting began: Go 1.22 ServeMux over gorilla/mux (zero extra dependencies, sufficient for seven routes), cobra over the stdlib flag package (the nested subcommand structure maps naturally to its command model), DELETE returning 409 Conflict when an employee has direct reports, bootstrap being idempotent. With those decisions settled, two independent implementation plans were produced.

## Two Drafts, Real Disagreements

The two draft plans did not just differ in wording — they made different architectural bets. The Claude draft pushed for TEXT UUID primary keys (external-facing IDs that expose row counts are an unnecessary information leak) and added an explicit iteration cap on chain traversal as a concrete cycle detection safety mechanism.

The [Codex draft](https://github.com/coreydaley/org-api/blob/main/docs/planning/2026-04-11T17-29-50-sprint-plan-merge-notes.md) made different calls. Token hashing: store only the SHA-256 hash, print the plaintext once at bootstrap, never persist it. Typed store errors in `internal/store/errors.go`. A JSON response envelope for API consumers. SQLite pragmas for foreign key enforcement and busy timeout handling.

The synthesis improved the plan by combining the strongest decisions from both — token hashing accepted, TEXT UUID defended, typed errors and SQLite pragmas included. But that is the important point: even after the merge, the plan still contained serious contradictions. Better synthesis was not enough. It still needed attack.

## What the Security Review Found

The [security review](https://github.com/coreydaley/org-api/blob/main/docs/planning/2026-04-11T17-29-50-sprint-plan-security-review.md) ran on the synthesized plan. Three findings came back critical.

**Finding 1: Bootstrap idempotency contradicts hash-only storage.** The plan stated in separate sections that tokens are "never persisted as plaintext" and only SHA-256 hashes are stored, and that repeated `api bootstrap --owner dev` calls return the existing token. These cannot both be true. SHA-256 is a one-way function. If only the hash is stored, there is nothing to replay. The design was promising behavior its data model could not deliver.

The fix required a design decision: store the token plaintext (appropriate for a local tool where file permissions are the real security boundary) or change the idempotency semantics (keep hashing, but explain on re-run that an active token exists and how to revoke and recreate it). The plan had to commit to one — this was not a detail to be resolved in implementation.

**Finding 2: `UNIQUE(owner)` makes token revocation and recreation impossible.** The schema enforced `UNIQUE(owner)` on the tokens table. A revoked token sets `active = 0` but the row stays. When P1 adds `org token create --owner dev` to recreate a token, it fails with a unique constraint violation. The plan had quietly deferred this contradiction into "later" while baking the constraint into the schema during P0.

The fix: remove `UNIQUE(owner)`. Allow multiple rows per owner, some revoked, one active. The bootstrap idempotency check becomes "look for an active token for this owner," not "enforce one row per owner forever." This is how the table should have been designed from the start, but the constraint had seemed like a natural safeguard.

**Finding 3: `PRAGMA foreign_keys = ON` is connection-scoped, not database-scoped.** SQLite's `PRAGMA foreign_keys = ON` applies to the connection on which it executes. `database/sql` maintains a connection pool. New pool connections do not inherit the pragma. The plan applied the pragma once at startup and documented this as sufficient. It was not — any subsequent connection from the pool would silently skip FK checks.

The fix: move the pragma into the DSN connection string: `file:org-api.db?_foreign_keys=on&_busy_timeout=5000&_journal_mode=WAL`. The `go-sqlite3` driver applies DSN parameters automatically on every new connection. This is the kind of SQLite behavior that is easy to miss precisely because it doesn't fail loudly — foreign key violations just stop being rejected.

None of these issues needed code to become real. They were already real in the plan.

## What the Devil's Advocate Added

The [devil's advocate review](https://github.com/coreydaley/org-api/blob/main/docs/planning/2026-04-11T17-29-50-sprint-plan-devils-advocate.md) ran independently. It confirmed the bootstrap contradiction from a different angle — and added three more findings.

The auth middleware's `crypto/subtle.ConstantTimeCompare` call was security theater. Once the query runs `WHERE token_hash = ?`, the database has already performed equality checking. Constant-time comparison of the computed hash against the retrieved hash protects nothing; the timing-differentiable operation had already happened. The plan was adding cryptographic ceremony without adding protection.

The nullable `manager_id` design allowed multiple root nodes. The use cases referred to "the CEO" as a singular entity. The schema would silently permit many CEOs with no enforcement — which means validation logic that assumes a single root will behave incorrectly, and the org chart can be structured in ways the product description says are impossible.

The cycle detection depth cap of 100 was an arbitrary cutoff. A hierarchy legitimately deeper than 100 levels would hit the cap and be silently rejected. "Practical org hierarchies are shallow" is an empirical observation, not an engineering guarantee — and the plan had treated it as one.

## Why This Changes the Cost Curve

Each of these issues gets more expensive after coding starts.

The bootstrap contradiction becomes an auth refactor with UX fallout — developers have already built the CLI around a behavior the storage model can't support. The `UNIQUE(owner)` trap becomes a migration problem once data exists, because you can't casually drop a constraint from a live table. The PRAGMA issue becomes the worst kind of reliability bug: it passes casual testing (the first connection has FK enforcement), fails under load when the pool spins up new connections, and produces inconsistent behavior that is hard to reproduce and diagnose.

When people say planning saves time, it can sound vague. This is what it looks like in practice: not a better outline that helps developers type faster, but a review process that surfaces the category of mistakes that otherwise harden into design debt once code, tests, data, and expectations have locked around them.

## The Role Separation That Makes It Work

The value is not "multiple agents produce more ideas." The mechanism is role separation.

Independent drafting broadens solution space without contamination — each draft reveals instincts and priorities the other missed. Mutual critique prunes errors and promotes better ideas. Synthesis adjudicates between competing judgments.

But the biggest jump comes from the specialized review phases. Security review asks: where does this plan create false confidence? Devil's advocate asks: what assumption here only works if nobody pushes on it? These are different questions from "is this a decent implementation outline?" — and they require adversarial posture, not collaborative improvement.

That distinction mattered in the org-api session. The synthesized plan already looked strong. If the workflow had ended at synthesis, it would have felt successful. It also would have shipped a bootstrap contradiction, a schema trap, and a silent FK enforcement hole. Those were waiting in the plan, not in the code.

## Not Every Project. But Sooner Than You Think.

This level of planning is not for every 50-line script. The overhead justifies itself when a project has enough moving parts that a bad assumption can propagate across schema, auth, API behavior, and developer experience simultaneously.

The org-api example hits that threshold faster than it looks. It has auth with a revocation lifecycle, a self-referential data model with traversal constraints, a CLI with its own config and error handling, and startup behavior that needs to be idempotent and safe to re-run. That's not an enterprise system. It's a small local API. But "small" and "assumption-free" are not the same thing.

A sprint plan should not read like a confident prediction of how implementation will go. It should read like a design that has already survived attack.

*What step in your planning process is explicitly there to prove the plan wrong before implementation begins?*

