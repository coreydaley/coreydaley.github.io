+++
author = "Claude Code (Claude Sonnet 4.6)"
date = "2026-04-25T01:13:00-04:00"
draft = false
title = "Your HTML Is Lying to AI Agents"
description = "Most personal sites have two versions: the rendered page humans see, and the raw HTML machines read. CSS flexbox makes the sidebar appear left and the article appear right — but the source order tells a different story. Here's why that gap matters more than it used to, and three practical fixes any static site can adopt."
summary = """Your site has two versions. The first is the rendered page: sidebar on the left, article on the right, everything in its place. The second is what machines read — the raw HTML, in source order, before CSS gets involved. On most personal blogs, that second version leads with navigation, tag clouds, and category lists before it reaches a word of the article. That's the version every AI agent, crawler, and screen reader encounters first.

This post argues that HTML is no longer just presentation scaffolding — it's a machine-facing interface, and most of us are still designing it as if only browsers matter. The fix is three practical changes: reordering the DOM so content leads, generating llms.txt so agents can orient to your site, and publishing plain text versions of every post so there's nothing to strip. None require a new framework. All take an afternoon.

If an agent read your site top to bottom in raw HTML, what would it think matters most?

Read more at https://coreydaley.dev/posts/2026/04/your-html-is-lying-to-ai-agents/"""
tags = ["ai", "web-development", "html", "semantic-html", "llms-txt", "static-sites", "hugo", "accessibility"]
categories = ["AI", "Web Development", "Best Practices"]
image = "your-html-is-lying-to-ai-agents.webp"
aliases = ["/posts/your-html-is-lying-to-ai-agents/"]
+++

{{< figure-float src="your-html-is-lying-to-ai-agents.webp" alt="Tiny figure stands beside giant smartphone and stacked documents with robot holding magnifying glass." >}}
Your website has two versions.

The first is the rendered page. Sidebar on the left, article filling the main column, footer anchoring the bottom. This is the version you look at when you're tweaking CSS at midnight. It looks right.

The second version is what machines read: the raw HTML, in source order, before CSS has done anything. No layout. No reordering. Just tags encountered top to bottom.

On most personal blogs, that second version leads with the sidebar — navigation, category lists, tag clouds — and only then reaches the article you actually published. That is the version every AI agent, crawler, and screen reader encounters first.

## HTML Is a Machine-Facing Interface

For years, we treated HTML as raw material for browsers. Structure mattered, sure, but always in service of the visual experience. If the page renders correctly, the HTML is doing its job.

That framing breaks down once you take machine consumers seriously.

If an API returned its least important metadata first and buried the primary payload halfway down the response, we would call it a badly designed interface. Many websites do exactly this in HTML and never notice, because browsers are very good at turning structural ambiguity into polished visuals. AI agents are much less forgiving. Even sophisticated extraction tools have to infer what the page *means* — which text is article, which is navigation, which is chrome. Sometimes they guess right. Sometimes they absorb your sidebar as content or miss the opening paragraph because the template signaled the wrong thing.

What has sharpened this problem is that AI agents increasingly read with a budget. They often need only enough signal to classify, route, summarize, or decide what to fetch next. In that context, the first part of your HTML gets disproportionate weight — and if it leads with your tag cloud, you have spent that budget on the wrong thing.

The mental model shift: **HTML is a machine-facing interface contract, and most of us are still designing it as if only browsers matter.**

Accessibility had already diagnosed this problem. Screen readers navigate source order, not visual order. The skip link nearly every site includes exists precisely because sidebars tend to come first in the DOM. What is new is the scale: a broader class of software is now running into the same structural issue. The same fixes serve both audiences.

## Fix 1: Put the Content First

Most two-column blog layouts look like this in the HTML:

```html
<div class="main-container">
  <aside class="sidebar">
    <!-- navigation, categories, tags — visually on the left -->
  </aside>
  <main class="content-area">
    <!-- the article — visually on the right -->
  </main>
</div>
```

CSS flexbox makes the sidebar appear on the left and content appear on the right. But the sidebar is *first in the DOM*. Every agent reading this page hits `<aside>` before `<main>`.

The fix is a one-line HTML change and a one-line CSS addition:

```html
<div class="main-container">
  <main class="content-area" id="main-content" role="main">
    <!-- the article — now first in the DOM -->
  </main>
  <aside class="sidebar">
    <!-- navigation, categories, tags — still visually on the left -->
  </aside>
</div>
```

```css
.sidebar {
  order: -1; /* visually repositions the sidebar before main */
}
```

The visual layout is identical. The source order now tells the truth: the article is the primary thing, the sidebar is supplementary. Adding `role="main"` to `<main>` and `aria-label="{{ .Title }}"` to the `<article>` element makes the structure legible to any consumer reading the landmarks — not just modern browsers.

This is the essential fix. The next two are supporting infrastructure.

## Fix 2: llms.txt as a Site Map

`llms.txt` is an emerging convention — think `robots.txt` but for large language models. A plain text file at the root of your domain that tells agents what the site is, what sections matter, and where to find content. The [llmstxt.org](https://llmstxt.org) spec is deliberately minimal: a Markdown file with a heading, a description, and a list of links.

One honest note up front: `llms.txt` is not a stable protocol. Not every agent will look for it. It is still worth generating — it costs almost nothing, and agents that do look for it get real value — but it is a map, not a fix. A good map does not improve the roads themselves.

For a static site, generate it automatically from your content rather than maintaining it by hand:

```toml
# hugo.toml
[outputFormats.llms]
  mediaType = "text/plain"
  isPlainText = true
  baseName = "llms"
  notAlternative = true

[outputs]
  home = ["HTML", "RSS", "llms"]
```

The template at `layouts/index.llms` rebuilds with every deploy:

```
# {{ .Site.Title }}

> {{ .Site.Params.description }}

## Blog Posts

{{ $posts := where .Site.RegularPages "Section" "posts" -}}
{{ range sort (where $posts "Draft" false) "Date" "desc" -}}
- [{{ .Title }}]({{ .Permalink }}): {{ .Description }}
{{ end }}
```

Now your `llms.txt` always reflects the current state of the site. An agent fetching it gets an up-to-date index without crawling anything.

## Fix 3: Plain Text Outputs

Even a well-structured HTML page is noisy: navigation, share buttons, related posts, footers. Extraction libraries do a reasonable job of stripping that noise, but they introduce uncertainty. Is this paragraph part of the article? Was this code block preserved?

A cleaner answer: publish a plain text version of every post at the same URL with `.txt` appended. Title, date, author, tags, body — no HTML, no chrome.

```toml
[outputFormats.txt]
  mediaType = "text/plain"
  isPlainText = true
  baseName = "index"
  rel = "alternate"

[outputs]
  page = ["HTML", "txt"]
```

The template at `layouts/_default/single.txt`:

```
Title: {{ .Title }}
Date: {{ .Date.Format "2006-01-02" }}
Author: {{ .Params.author | default .Site.Title }}
URL: {{ .Permalink }}
{{- with .Params.tags }}
Tags: {{ delimit . ", " }}
{{- end }}

---

{{ .Plain }}
```

Every post now has an `index.txt` alongside its `index.html`. Hugo also adds a `<link rel="alternate">` to the HTML head, so agents parsing the page can discover the plain text version without guessing:

```html
<link rel="alternate" type="text/plain"
  href="https://example.com/posts/2026/04/my-post/index.txt" />
```

That tag is the connective tissue: agents can start with the HTML, find the alternate, and fetch clean content directly. You can extend this pattern further with an `llms-full.txt` at the site root that concatenates every post for bulk consumption — but the per-post `.txt` files are the core.

## What This Adds Up To

These three changes sit below the content layer. They do not affect how the site looks, how posts are written, or how readers experience it. They change what the document structure *says* to consumers that are not human browsers.

- An agent fetching any post encounters the article before navigation
- An agent trying to understand the site gets a current index at `/llms.txt`
- An agent wanting clean content gets `/posts/2026/04/my-post/index.txt` without extracting it from HTML
- The HTML head on every post advertises the plain text version via `<link rel="alternate">`

None of this is AI-specific. Better source order helps screen reader users. Explicit landmarks benefit accessibility tooling. Plain text outputs are useful for feed readers, archival tools, and anything else that wants content without markup. The AI readability angle makes visible a gap that was already there.

The web was built for browsers. Browsers render polished visuals from ambiguous structures. AI agents read source order. Closing the gap between those two facts is not a large investment — and it makes your site meaningfully more useful to the systems increasingly doing the reading.

*If an agent read your site top to bottom in raw HTML, what would it think matters most?*

