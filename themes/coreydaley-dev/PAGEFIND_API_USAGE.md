# Pagefind JavaScript API Usage

## Manual Search with JSON Results

Here's how to use the Pagefind JavaScript API to manually search and get JSON results:

### 1. Import the Core Library

```html
<!-- Import core Pagefind (not the UI) -->
<script src="/pagefind/pagefind.js"></script>
```

### 2. Perform a Search

```javascript
// Pagefind search returns a Promise
async function performSearch(query) {
  // Search returns a Promise with results
  const search = await pagefind.search(query);

  // Results is an array of result objects
  console.log(`Found ${search.results.length} results`);

  // Each result has a data() method that returns full details
  const fullResults = await Promise.all(
    search.results.map(r => r.data())
  );

  // Now you have full JSON data
  fullResults.forEach(result => {
    console.log('URL:', result.url);
    console.log('Title:', result.meta.title);
    console.log('Description:', result.meta.description);
    console.log('Excerpt:', result.excerpt);
    console.log('Tags:', result.meta.tags);
    console.log('Date:', result.meta.date);
    console.log('---');
  });

  return fullResults;
}

// Use it
performSearch("hugo").then(results => {
  console.log('Search complete:', results);
});
```

### 3. Result Object Structure

Each result object contains:

```javascript
{
  url: "/posts/my-post/",           // Page URL
  excerpt: "...highlighted text...", // Search excerpt with <mark> tags
  meta: {                            // Custom metadata from data-pagefind-meta
    title: "Post Title",
    description: "Post description",
    tags: "tag1, tag2, tag3",
    date: "2024-01-01",
    // ... any other meta you defined
  },
  content: "Full page content...",   // Full text content
  word_count: 500,                   // Word count
  filters: {},                       // Any filters you've set up
  sub_results: []                    // Sub-results if applicable
}
```

### 4. Complete Example

```javascript
async function searchAndDisplay(query) {
  try {
    // Perform search
    const search = await pagefind.search(query);

    // Get full data for all results
    const results = await Promise.all(
      search.results.map(result => result.data())
    );

    // Process results
    const processedResults = results.map(r => ({
      title: r.meta.title || 'Untitled',
      url: r.url,
      description: r.meta.description || r.excerpt,
      tags: r.meta.tags ? r.meta.tags.split(', ') : [],
      date: r.meta.date || '',
      excerpt: r.excerpt
    }));

    return processedResults;

  } catch (error) {
    console.error('Search failed:', error);
    return [];
  }
}

// Usage
document.addEventListener('DOMContentLoaded', async () => {
  const results = await searchAndDisplay('AI development');
  console.log('Found:', results);
});
```

### 5. Using with Your Custom UI

Here's how to integrate it into your search page:

```javascript
async function customSearch(query) {
  const resultsContainer = document.getElementById('search-results');
  resultsContainer.innerHTML = '<p>Searching...</p>';

  try {
    // Perform search
    const search = await pagefind.search(query);
    const results = await Promise.all(
      search.results.map(r => r.data())
    );

    // Clear loading message
    resultsContainer.innerHTML = '';

    // Display results
    results.forEach(result => {
      const article = document.createElement('article');
      article.className = 'search-result-item';

      const tags = result.meta.tags
        ? result.meta.tags.split(', ').map(tag =>
            `<a href="/tags/${tag.toLowerCase().replace(/\s+/g, '-')}" class="search-result-tag">${tag}</a>`
          ).join('')
        : '';

      article.innerHTML = `
        <div class="search-result-url">${window.location.origin}${result.url}</div>
        <h3 class="search-result-title">
          <a href="${result.url}">${result.meta.title}</a>
        </h3>
        <p class="search-result-description">${result.excerpt}</p>
        ${tags ? `<div class="search-result-tags">${tags}</div>` : ''}
        <div class="search-result-footer">
          <a href="${result.url}" class="search-result-link">Read more →</a>
        </div>
      `;

      resultsContainer.appendChild(article);
    });

    // Show count
    if (results.length === 0) {
      resultsContainer.innerHTML = '<p>No results found.</p>';
    }

  } catch (error) {
    resultsContainer.innerHTML = `<p>Search error: ${error.message}</p>`;
  }
}

// Hook up to search input
document.getElementById('search-input').addEventListener('input', (e) => {
  const query = e.target.value;
  if (query.length >= 2) {
    customSearch(query);
  }
});
```

### 6. Filtering Results

You can also filter results by metadata:

```javascript
const search = await pagefind.search(query, {
  filters: {
    tags: 'hugo'  // Only show results with 'hugo' tag
  }
});
```

### 7. Debouncing Search (for live search)

```javascript
let searchTimeout;
function debouncedSearch(query) {
  clearTimeout(searchTimeout);
  searchTimeout = setTimeout(() => {
    customSearch(query);
  }, 300); // Wait 300ms after user stops typing
}

searchInput.addEventListener('input', (e) => {
  debouncedSearch(e.target.value);
});
```

## Key Points

1. **Import `/pagefind/pagefind.js`** (not pagefind-ui.js) for manual control
2. **`pagefind.search()` returns a Promise** - always await it
3. **Call `.data()` on each result** to get full details
4. **`.data()` also returns a Promise** - use `Promise.all()` for multiple results
5. **Metadata is in `result.meta`** - matches your `data-pagefind-meta` attributes
6. **Excerpts include `<mark>` tags** around matched terms

## Complete Working Example

See your `layouts/_default/search.html` for a complete implementation using the Pagefind UI.

To switch to manual API mode, replace the UI import with:
```html
<script src="/pagefind/pagefind.js"></script>
```

And use the async functions above instead of `new PagefindUI()`.
