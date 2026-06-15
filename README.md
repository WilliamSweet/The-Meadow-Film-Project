# ROOTED — Documentary Film Website

Single-page Astro site for the ROOTED documentary film crowdfunding campaign.
Deploy target: Cloudflare Pages. Stack: Astro 4 (static output) + fontsource variable fonts.

---

## Running locally

```bash
npm install
npm run dev
```

Opens at http://localhost:4321

---

## Building for production

```bash
npm run build
```

Output goes to `dist/`. This is what Cloudflare Pages deploys.

---

## Deploying to Cloudflare Pages

1. Push to a public GitHub repo.
2. In Cloudflare Pages: Create project → Connect to GitHub → select this repo.
3. Build settings:
   - Build command: `npm run build`
   - Output directory: `dist`
4. Environment variable: `NODE_VERSION` = `20.11.0`
5. Deploy.

**CRITICAL after deploy — Cache Rule:**
Cloudflare does NOT cache HTML by default. Create a Cache Rule before any traffic arrives:
- Rules → Cache Rules → Create rule
- When: Response MIME type = `text/html`
- Then: Edge TTL → 4 hours

Without this rule, viral traffic hits the origin on every page load.

Full deploy sequence: `docs/deploy-checklist.md`

---

## Before launch — fill these placeholders

All must be resolved before go-live. See `docs/copy-todo.md` for details.

1. `src/components/FoundingPartnerCTA.astro` — Founding Partner benefit sentence
2. `src/components/FoundingPartnerCTA.astro` — Closing date (replace `[DATE TBD]`)
3. `src/components/FoundingPartnerCTA.astro` — Formspree form ID (or Cloudflare Worker endpoint)
4. `src/pages/index.astro` — Fathom analytics site ID (uncomment the script tag)
5. `src/pages/index.astro` — Font preload paths (update after `npm run build`, inspect `dist/_astro/`)

**Replace Formspree with Cloudflare Worker** before launch.
The HTML comment in `FoundingPartnerCTA.astro` explains the async pattern:
Worker accepts POST → writes address to queue → sends confirmation email async.
Never synchronous send inside the request handler.

---

## Replacing placeholder images

CSS gradient placeholders throughout. Replace with real photography before launch.
All placeholders tagged with `data-replace="true"`. Find them:

```bash
grep -r "data-replace" src/
```

Photo specs and shot descriptions: `docs/photography-brief.md`

---

## v2 — July 15 campaign launch swaps

When the crowdfunding campaign opens:
1. `src/components/Nav.astro` — CTA href → external crowdfunding URL
2. `src/components/Hero.astro` — CTA text → "Support the Campaign", href → same URL
3. Add the sizzle reel/trailer to the Team section
4. Update coalition partners list in `src/components/Coalition.astro`
5. Add campaign progress bar (never display $0 — pre-load the opening total)

---

## Project structure

```
rooted-film/
├── docs/
│   ├── content-inventory.md      all copy sourced from existing Wix site
│   ├── build-decisions.md        design system and stack decisions
│   ├── deploy-checklist.md       pre-launch sequence
│   ├── photography-brief.md      image specs and shot descriptions
│   └── copy-todo.md              every placeholder, numbered
├── public/
│   ├── _headers                  Cloudflare Pages security headers
│   ├── robots.txt
│   └── favicon.svg
├── src/
│   ├── components/
│   │   ├── Nav.astro             sticky nav with scroll behavior
│   │   ├── Hero.astro            full-viewport hero
│   │   ├── FilmPremise.astro     60/40 text/image editorial section
│   │   ├── ImpactStats.astro     three statistics, sparse grid
│   │   ├── FilmDetails.astro     definition list: runtime, director, etc.
│   │   ├── Team.astro            2x2 team grid
│   │   ├── Coalition.astro       founding coalition text list
│   │   ├── FoundingPartnerCTA.astro  email capture form (Formspree placeholder)
│   │   └── Footer.astro          dark footer with legal language
│   ├── pages/
│   │   └── index.astro           main page, assembles all sections
│   └── styles/
│       └── global.css            design tokens, reset, fonts, utilities
├── .node-version                 20.11.0
├── astro.config.mjs
└── package.json
```
