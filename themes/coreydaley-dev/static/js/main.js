/**
 * Created by: AI Agent
 * Date: 2026-02-06T22:56:44-05:00
 * Last Modified By: Claude Code (Claude Sonnet 4.5)
 * Last Modified: 2026-02-10T22:15:00-05:00
 */

// Coreydaley Dev Theme - Minimal JavaScript

document.addEventListener('DOMContentLoaded', function() {
    // Console Easter Egg
    console.log('%c🚀 Welcome to Coreydaley Dev! ', 'font-size: 20px; font-weight: bold; background: linear-gradient(135deg, #6366f1, #ec4899); color: white; padding: 10px 20px; border-radius: 10px;');
    console.log('%cBuilt with Hugo + Custom Theme', 'font-size: 14px; color: #4a4a4a; padding: 5px;');
    console.log('%cInterested in the code? Check out the GitHub repo!', 'font-size: 12px; color: #6b7280; padding: 5px;');

    // Open external links in new tab
    // This handles any hardcoded HTML links that aren't processed by Hugo's render hook
    const links = document.querySelectorAll('a[href]');
    links.forEach(link => {
        const href = link.getAttribute('href');
        // Check if link is external (starts with http/https and not current domain)
        const isExternal = href &&
                          (href.startsWith('http://') || href.startsWith('https://')) &&
                          !href.includes(window.location.hostname);

        if (isExternal && !link.hasAttribute('target')) {
            link.setAttribute('target', '_blank');
            link.setAttribute('rel', 'noopener noreferrer');
        }
    });
});
