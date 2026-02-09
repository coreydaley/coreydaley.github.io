+++
author = 'ChatGPT (GPT-5)'
date = '2026-02-08T19:19:33-05:00'
draft = false
title = 'A Search UI That Feels Native: Pagefind + Custom JSON Rendering'
description = 'How the custom search page taps Pagefind’s API, shapes JSON results, and renders a UI that matches the site’s design system.'
tags = ['pagefind', 'search-ui', 'javascript', 'hugo', 'frontend', 'ux']
categories = ['Web Development', 'Tools', 'Best Practices']
+++

The search experience on this site needed to feel like the rest of the theme: clean, typographic, and aligned with the post list layout. The default Pagefind UI is great for quick setup, but it brings its own markup and styles. Instead, the search page uses the **Pagefind API directly**, pulls JSON results, and renders the results using the same post card structure used elsewhere.

You can see it in action on the [search page](/search/).

This post walks through the key ideas in `themes/coreydaley-dev/layouts/_default/search.html` and how the custom flow works. You can view the full file on GitHub: [search.html](https://github.com/coreydaley/coreydaley.github.io/blob/main/themes/coreydaley-dev/layouts/_default/search.html).

## Why Skip The Default UI

The stock Pagefind UI gives you a search box and results list out of the box, but that HTML structure doesn’t match the theme’s post list markup. The goal here was to keep the search results visually consistent: dates in the same format, taxonomy chips in the same place, separators between posts, and familiar “Read more” links.

## Load Pagefind As A Module

The page imports the core Pagefind API (not the UI bundle) directly:

- The module import loads `/pagefind/pagefind.js`.
- That gives a `pagefind.search(query)` call that returns a lightweight result list.

```html
<script type="module">
  const pagefind = await import("/pagefind/pagefind.js");
</script>
```

This is the foundation for custom rendering. You keep the search engine, but own the markup.

## Turn Results Into Clean JSON

`performSearch(query)` is the main entry point. After calling `pagefind.search(query)`, it fetches full result data with:

- `search.results.map((result) => result.data())`

```js
const search = await pagefind.search(query);
const fullResults = await Promise.all(
  search.results.map((result) => result.data()),
);
```

Those result objects include URL, metadata, excerpt, and word count. The code then **maps them into a clean JSON shape** that’s easy to render:

- `title`, `description`, and `excerpt` for content
- `tags` and `categories` split into arrays
- `date` and `wordCount` for metadata

```js
const jsonResults = fullResults.map((result) => ({
  url: result.url,
  title: result.meta.title || "Untitled",
  description: result.meta.description || "",
  excerpt: result.excerpt,
  tags: result.meta.tags ? result.meta.tags.split(", ") : [],
  categories: result.meta.categories ? result.meta.categories.split(", ") : [],
  date: result.meta.date || "",
  wordCount: result.word_count,
}));
```

This step is the big win: the JSON object is decoupled from Pagefind’s internal shape, so the rendering logic stays readable and theme-specific.

## Render Results Using The Site’s Post List Styles

`displayResults(results)` builds the HTML using the same visual components as the rest of the site:

- Each result becomes an `<article class="post-item">`.
- Dates are formatted in US English with `toLocaleDateString`.
- Categories and tags are rendered as taxonomy links, using the same iconography and classes already used across the theme.
- A `Read more →` link finishes the card.

```js
article.innerHTML = `
  ${dateStr ? `<div class="post-date">${dateStr}</div>` : ""}
  <h2 class="post-title">
    <a href="${result.url}">${result.title}</a>
  </h2>
  ${result.description ? `<p class="post-excerpt">${result.description}</p>` : ""}
  ${taxonomyHtml}
  <a href="${result.url}" class="read-more">Read more →</a>
`;
```

Because the markup matches the site’s list layout, the search results feel like native content — not a bolted-on widget.

## Small UX Details That Add Polish

A few subtle touches help the page feel responsive and intentional:

- A debounced search (300ms) avoids hammering the index as users type.
- Empty state messages (“Enter a search query…”, “No results found.”) provide guidance.
- The `q` query parameter syncs with the input so search results are linkable and shareable.

```js
searchInput.addEventListener("input", (e) => {
  const query = e.target.value;
  debouncedSearch(query);

  const newUrl = new URL(window.location);
  if (query) newUrl.searchParams.set("q", query);
  else newUrl.searchParams.delete("q");
  window.history.replaceState({}, "", newUrl);
});
```

## The Result: Pagefind Power, Theme-Native Presentation

The key idea is simple: Pagefind handles indexing and search relevance, while the site controls the UI. By converting Pagefind results into a clean JSON structure and rendering them with existing post styles, the search page keeps visual consistency without sacrificing search quality.

If you want to explore or extend this, start in `themes/coreydaley-dev/layouts/_default/search.html` and follow the `performSearch` → `displayResults` flow. That separation is what makes the implementation both flexible and easy to maintain.
