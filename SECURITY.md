# Security Policy

## Supported Versions

Security fixes are applied to the latest version on `main` only. This is a personal blog and static site; there are no versioned releases with separate support windows.

## Scope

| Area | In Scope |
|------|----------|
| Hugo theme (`themes/coreydaley-dev/`) | Yes — template injection, XSS |
| Scripts (`scripts/`) | Yes — command injection, unsafe file handling |
| GitHub Actions workflows (`.github/workflows/`) | Yes — supply chain / secrets exposure |
| npm / Python dependencies | Yes — known CVEs |
| Blog content (posts, images) | No |
| Third-party services (GitHub Pages, Pagefind CDN) | No |

## Reporting a Vulnerability

**Do not open a public GitHub issue for security vulnerabilities.**

Report privately via [GitHub Security Advisories](https://github.com/coreydaley/coreydaley.github.io/security/advisories/new).

Please include:

- A description of the vulnerability and its potential impact
- Steps to reproduce (proof-of-concept if available)
- Suggested remediation (optional but appreciated)

You will receive an acknowledgment within **7 days** and a resolution or status update within **30 days**. If you do not hear back, follow up by opening a public issue with no vulnerability details — just a request to check your advisory.

## AI-Generated Content Disclaimer

Portions of this codebase — including theme templates, scripts, and configuration files — were written or modified with AI assistance (Claude Code, GitHub Copilot). All AI-generated code is reviewed before merging, but you should review scripts before running them in sensitive environments.

See [AGENTS.md](AGENTS.md) for full AI authorship details.
