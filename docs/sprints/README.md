# Sprint Planning

This directory holds sprint planning documents for coreydaley.github.io.

## Workflow

Sprint documents are created via `/superplan` (multi-agent planning) and executed
via `/sprint`. Each sprint goes through 8 phases before the final document is approved.

## Structure

```
docs/sprints/
├── README.md              ← this file
├── SPRINT-001.md          ← finalized sprint (ready to execute)
└── drafts/
    ├── SPRINT-001-INTENT.md                      ← concentrated intent
    ├── SPRINT-001-CLAUDE-DRAFT.md                ← Claude's initial draft
    ├── SPRINT-001-CODEX-DRAFT.md                 ← Codex's competing draft
    ├── SPRINT-001-CLAUDE-DRAFT-CODEX-CRITIQUE.md ← Codex critique of Claude
    ├── SPRINT-001-MERGE-NOTES.md                 ← synthesis decisions
    ├── SPRINT-001-DEVILS-ADVOCATE.md             ← Codex skeptic review
    └── SPRINT-001-SECURITY-REVIEW.md             ← Claude security audit
```

## Sprint Format

Each `SPRINT-NNN.md` contains:
- **Overview** — why and high-level approach
- **Use Cases** — concrete human/agent scenarios
- **Architecture** — structure, URLs, template logic
- **Implementation Plan** — phases with tasks and file targets
- **Files Summary** — table of all affected files
- **Definition of Done** — explicit, verifiable completion criteria
- **Risks & Mitigations** — known failure modes
- **Security Considerations** — trust boundaries and threat model

## Sprint Numbering

Sprints are numbered sequentially: SPRINT-001, SPRINT-002, etc.
To find the next sprint number: `ls docs/sprints/SPRINT-*.md | tail -1`

## Conventions

- All sprint documents use Markdown
- Do not add file comment headers to Markdown files (breaks Hugo frontmatter parser)
- Sprint documents are not Hugo content — they live in `docs/`, not `content/`
