# ROOTED / Meadow Film site — Project CLAUDE.md
Created 2026-07-05 (CLAUDE.md audit — this project had its own .git but no CLAUDE.md).

## What this is
Astro static site for the ROOTED documentary (Meadow Film). Own git repo, nested inside LTM-Operations/ (untracked by the LTM-data repo).

## Commands
```bash
npm run dev      # dev server on port 4322
npm run build    # static build to dist/
npm run preview  # preview built site
```

## Known working facts (2026-07-05)
- Forms run on Tally (Formspree retired 2026-07-05 — do not reintroduce it).
- `public/images/sleepy-cat/` — carousel auto-absorbs any photos dropped in; no code change needed.
- `src/**/partners.ts` `wallPartners` — populated manually as orgs register as founding partners.
- Badge PNG regeneration requires an SVG converter (`brew install librsvg`) — not installed as of 2026-07-05.

## Rules
- LTM global + project rules apply here as DEFAULTS (~/.claude/CLAUDE.md, LTM-data/CLAUDE.md, LTM-Operations/CLAUDE.md) — this file overrides them for site work.
- Never deploy or publish without William's explicit confirmation (LTM Bright Line #2 applies).
- Site copy is outreach-adjacent: fact claims on the site go through the claim registry (grep vault/research/claims/CLAIMS-INDEX.md) like any brief.
- UI changes: screenshot before claiming a visual change works (decisions.md ACTIVE RULES #4).
- Before structural changes to the site, read LTM-Operations/decisions.md (Meadow entries: 2026-07-05 Tally cutover, Founding Coalition redesign).
