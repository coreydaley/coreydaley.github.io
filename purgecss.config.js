/**
 * Created By: Claude Code (Claude Sonnet 4.5)
 * Date: 2026-02-08T14:30:00-05:00
 * Last Modified By: Claude Code (Claude Sonnet 4.6) | Last Modified: 2026-02-19T14:36:00-05:00
 */

module.exports = {
  // Content files to scan for used CSS classes
  // Note: using explicit paths (not themes/**/) to avoid the exampleSite symlink
  // at themes/coreydaley-dev/exampleSite/themes/coreydaley-dev -> ../../ which
  // causes infinite recursion with wildcard globs.
  content: [
    // Hugo templates
    'themes/coreydaley-dev/layouts/**/*.html',
    'layouts/**/*.html',

    // Hugo content files
    'content/**/*.md',
    'content/**/*.html',

    // Built site (for dynamically generated content)
    'public/**/*.html',

    // JavaScript files that might add classes
    'themes/coreydaley-dev/static/**/*.js',
    'themes/coreydaley-dev/assets/**/*.js',
    'static/**/*.js',
  ],

  // CSS files to purge
  css: [
    'themes/coreydaley-dev/assets/css/style.css',
  ],

  // Output directory
  output: 'themes/coreydaley-dev/static/css/',

  // Safelist - classes to always keep
  safelist: {
    // Standard safelist for always-kept classes
    standard: [
      /^pagefind/,           // Pagefind search classes
      /^search-/,            // Search-related classes
      /^highlight/,          // Code highlighting
      /^chroma/,             // Hugo's Chroma syntax highlighter
      /^language-/,          // Language-specific code blocks
      /^token/,              // Code tokens
      /^data-pagefind/,      // Pagefind data attributes
    ],

    // Deep safelist - keeps class and all its children/descendants
    deep: [
      /^post-content/,       // Post content and all children
      /^code/,               // Code blocks and children
      /^pre/,                // Pre-formatted text
    ],

    // Greedy safelist - keeps class and modifiers
    greedy: [
      /^nav-/,               // Navigation classes
      /^header-/,            // Header classes
      /^footer-/,            // Footer classes
      /^sidebar-/,           // Sidebar classes
      /^taxonomy-/,          // Taxonomy (tags/categories) classes
      /^post-/,              // Post-related classes
    ],
  },

  // Reject specific selectors
  rejected: true,

  // Include information about rejected selectors
  rejectedCss: false,

  // Options for extractors
  defaultExtractor: content => {
    // Extract classes from Hugo templates and content
    // This regex matches class names in various contexts
    const broadMatches = content.match(/[^<>"'`\s]*[^<>"'`\s:]/g) || [];

    // Also match Hugo template variables that might contain classes
    const innerMatches = content.match(/[^<>"'`\s.()]*[^<>"'`\s.():]/g) || [];

    return broadMatches.concat(innerMatches);
  },

  // Variables to keep (CSS custom properties)
  variables: true,

  // Keyframes to keep
  keyframes: true,

  // Font-face to keep
  fontFace: true,
};
