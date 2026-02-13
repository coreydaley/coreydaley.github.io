+++
author = "GitHub Copilot"
date = "2026-02-03T21:02:25-05:00"
draft = false
title = "Building with AI: Copilot and Claude"
description = "Discover how Claude and GitHub Copilot work together to streamline website development. Claude handles architectural decisions and structural changes like creating custom Hugo layouts and navigation systems, while GitHub Copilot excels at code completion and routine tasks. This post explores the division of labor between these AI tools, their complementary strengths, and how their collaboration creates a powerful development workflow that balances high-level planning with efficient implementation for building and maintaining this Hugo-powered blog."
summary = "Building websites has changed dramatically—I'm no longer staring at code for hours. Instead, I'm collaborating with Claude and GitHub Copilot to build this Hugo blog. Here's what I've learned: Claude is my architect. When I need structural changes or new layouts, Claude generates complete solutions and explains every decision. GitHub Copilot is my coding assistant, finishing my thoughts as I type and handling routine tasks. Together, they create a powerful workflow where Claude handles the big picture and Copilot speeds up execution. The result? I spend less time debugging and more time creating. If you're curious about AI-assisted development or wondering which tool does what, this post breaks down how they complement each other. Are you using AI tools in your workflow? How do you divide the work?"
tags = ["ai", "claude", "github-copilot", "hugo", "web-development", "productivity"]
categories = ["AI", "Web Development"]
+++

Building a website used to mean hours of staring at HTML files, wrestling with CSS, and debugging JavaScript until your eyes glazed over. But today, I'm working differently. I'm building this [Hugo](https://gohugo.io/)-based blog with the help of two AI assistants: **[GitHub Copilot](https://github.com/features/copilot)** and **[Claude](https://claude.ai/)**. Here's how it's going.

## The Setup

This site runs on Hugo (v0.155.1 extended) with the github-style theme. It's deployed automatically to [GitHub Pages](https://pages.github.com/) via [GitHub Actions](https://github.com/features/actions) whenever I push to the `main` branch. Simple, fast, and developer-friendly.

But here's where it gets interesting: I'm not writing most of the code myself. Instead, I'm collaborating with AI.

## Claude: The Architect

When I need to make structural changes—like adding a new Tutorials section, creating custom layouts, or overhauling the navigation—I turn to **Claude**. Claude doesn't just write code; it understands context. I can describe what I want in plain English, and it generates Hugo templates, updates multiple files, and even explains what it changed and why.

For example, when I wanted to create a "Popular Content" section on the homepage that pulls from both Posts and Tutorials, I simply asked. Claude:

1. Updated the `overview.html` partial to combine both content types
2. Limited the display to the 2 most recent items
3. Added metadata (content type, tags, creation date) to each item
4. Used relative URLs throughout

All in one go. No trial and error. No hunting through Hugo documentation for hours.

## Copilot: The Helper

While Claude handles the big architectural decisions, **GitHub Copilot** lives in [VS Code](https://code.visualstudio.com/) and helps with the smaller stuff—autocompleting function names, suggesting HTML structures, and filling in repetitive patterns. It's like having a pair programmer who knows what you're about to type before you do.

Copilot really shines when I'm writing Markdown content or tweaking CSS. It'll suggest entire paragraphs, code blocks, or style rules based on the context of what I'm working on. It's not perfect, but it's fast, and it keeps me in the flow.

## The Workflow

Here's how a typical session looks:

1. **I describe what I want** to Claude in natural language
2. **Claude generates the code**, often touching multiple files at once
3. **I review the changes** and test locally with `hugo server -D`
4. **Copilot assists with tweaks** as I refine details
5. **I push to GitHub**, and the site updates automatically

It's collaborative, iterative, and surprisingly efficient.

## What This Means

I'm not a Hugo expert. I don't have every template syntax memorized. But I don't need to be. The AI handles the boilerplate, the cross-file coordination, and the "how do I do this in Hugo" questions. I focus on what I want the site to do, and the tools figure out the how.

This isn't about replacing developers. It's about amplifying what we can do. I'm building faster, experimenting more, and spending less time stuck on implementation details.

## The Results

In the time it would have taken me to manually set up one new section, I've:

- Created a complete Tutorials section with custom archetypes and layouts
- Overhauled the navigation system
- Standardized all URLs to be relative
- Built a dynamic "Popular Content" section
- Written two blog posts (including this one)

All with AI assistance. All in a matter of hours.

## What's Next?

I'm just getting started. The site works, the content is live, and I'm learning how to work with AI as a creative tool—not just a code generator. There's still plenty to explore:

- Using AI to help generate tutorial content
- Automating SEO optimizations based on suggestions
- Creating custom theme modifications based on natural language descriptions

The future of web development isn't about memorizing syntax. It's about describing what you want and having the tools to make it happen. And that future is already here.

---

If you're building something and haven't tried working with AI yet, I'd recommend giving it a shot. You might be surprised at how much it changes the way you work.
