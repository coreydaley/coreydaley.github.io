/**
 * Created by: AI Agent
 * Date: 2026-02-06T22:56:44-05:00
 * Last Modified By: Claude Code (Claude Sonnet 4.5)
 * Last Modified: 2026-02-13T14:55:00-05:00
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

    // Sticky header on scroll
    const header = document.querySelector('.site-header');
    let lastScrollTop = 0;
    const scrollThreshold = 50; // Start shrinking after 50px scroll

    function handleScroll() {
        const scrollTop = window.pageYOffset || document.documentElement.scrollTop;

        if (scrollTop > scrollThreshold) {
            header.classList.add('header-scrolled');
        } else {
            header.classList.remove('header-scrolled');
        }

        lastScrollTop = scrollTop;
    }

    // Throttle scroll events for performance
    let scrollTimeout;
    window.addEventListener('scroll', function() {
        if (scrollTimeout) {
            window.cancelAnimationFrame(scrollTimeout);
        }
        scrollTimeout = window.requestAnimationFrame(handleScroll);
    }, { passive: true });

    // Special date avatar swapping
    function checkSpecialDateAvatar() {
        const avatar = document.getElementById('site-avatar');
        if (!avatar) return;

        const now = new Date();
        const month = now.getMonth() + 1; // getMonth() returns 0-11
        const day = now.getDate();
        const dayOfWeek = now.getDay(); // 0 = Sunday, 4 = Thursday, 5 = Friday

        // Check for New Year's Day (January 1)
        if (month === 1 && day === 1) {
            avatar.src = '/images/avatar-new-years.png';
            return;
        }

        // Check for Independence Day (July 4)
        if (month === 7 && day === 4) {
            avatar.src = '/images/avatar-independence-day.png';
            return;
        }

        // Check for Christmas (December 25)
        if (month === 12 && day === 25) {
            avatar.src = '/images/avatar-christmas.png';
            return;
        }

        // Check for St. Patrick's Day (March 17)
        if (month === 3 && day === 17) {
            avatar.src = '/images/avatar-st-patricks.png';
            return;
        }

        // Check for Birthday (March 1)
        if (month === 3 && day === 1) {
            avatar.src = '/images/avatar-birthday.png';
            return;
        }

        // Check for Valentine's Day (February 14)
        if (month === 2 && day === 14) {
            avatar.src = '/images/avatar-valentines.png';
            return;
        }

        // Check for Cinco de Mayo (May 5)
        if (month === 5 && day === 5) {
            avatar.src = '/images/avatar-cinco-de-mayo.png';
            return;
        }

        // Check for Memorial Day (last Monday of May)
        // Last Monday is always between May 25-31
        if (month === 5 && dayOfWeek === 1 && day >= 25 && day <= 31) {
            avatar.src = '/images/avatar-memorial.png';
            return;
        }

        // Check for Labor Day (1st Monday of September)
        // 1st Monday is always between Sept 1-7
        if (month === 9 && dayOfWeek === 1 && day >= 1 && day <= 7) {
            avatar.src = '/images/avatar-labor.png';
            return;
        }

        // Check for Halloween (October 31)
        if (month === 10 && day === 31) {
            avatar.src = '/images/avatar-halloween.png';
            return;
        }

        // Check for Veterans Day (November 11)
        if (month === 11 && day === 11) {
            avatar.src = '/images/avatar-veterans.png';
            return;
        }

        // Check for Thanksgiving (4th Thursday of November)
        // 4th Thursday is always between Nov 22-28
        if (month === 11 && dayOfWeek === 4 && day >= 22 && day <= 28) {
            avatar.src = '/images/avatar-thanksgiving.png';
            return;
        }

        // Check for Friday the 13th
        if (day === 13 && dayOfWeek === 5) {
            avatar.src = '/images/avatar-friday-13.png';
            return;
        }
    }

    // Run on page load
    checkSpecialDateAvatar();
});
