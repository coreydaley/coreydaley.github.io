/**
 * Created By: Claude Code (Claude Sonnet 4.5)
 * Date: 2026-02-08T14:30:00-05:00
 */

module.exports = {
  // Content files to scan for used CSS classes
  content: [
    // Hugo templates
    'themes/**/layouts/**/*.html',
    'layouts/**/*.html',

    // Hugo content files
    'content/**/*.md',
    'content/**/*.html',

    // Built site (for dynamically generated content)
    'public/**/*.html',

    // JavaScript files that might add classes
    'themes/**/static/**/*.js',
    'static/**/*.js',
  ],

  // CSS files to purge
  css: [
    'themes/coreydaley-dev/static/css/style.css',
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
