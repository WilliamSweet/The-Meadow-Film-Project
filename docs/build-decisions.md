# Build Decisions — ROOTED Documentary Site
Sources: SYNTHESIS-website-build-brief.md + full build prompt (2026-06-15)

---

## Stack

**Decision:** Astro (static, zero-JS-by-default output)
**Rationale:**
- Ships pure static HTML to Cloudflare Pages edge — no origin hit under viral traffic
- Component model fits 9-section single-page site cleanly; raw HTML would be one monolithic file
- npm ecosystem enables fontsource variable font packages directly
- No server features needed (no auth, no DB, no API) — Astro's `output: 'static'` is the correct tier
- Next.js ruled out: adds weeks of complexity with zero user-facing benefit for a content site
- Raw HTML ruled out: no component reuse; harder to maintain for v2/v3 swaps
**Hosting:** Cloudflare Pages (free, unlimited bandwidth, global edge CDN)
**Build command:** `npm run build` → `dist/`

---

## Design System

### Palette (locked — no deviation)
```
--color-bg:      #F7F3EC   dominant background (60%)
--color-text:    #1C2B1E   body text (near-black, green cast)
--color-meadow:  #4A6741   sage green (UI/brand elements)
--color-earth:   #A85533   terracotta (CTAs only)
--color-straw:   #C9A96E   amber (hairlines/hover only — NEVER body text)
```

**Why #A85533 not #B5603C for terracotta:**
- #B5603C on cream: 4.04:1 — fails WCAG AA-normal (requires 4.5:1)
- #A85533 on cream: 4.73:1 — passes WCAG AA-normal ✓
- #A85533 with white text: 5.23:1 — passes WCAG AA ✓
- #B5603C was flagged in SYNTHESIS §4 as the "fails" value; never use it

**WCAG-verified contrast pairs:**
- white on #A85533: 5.23:1 ✓ (CTA buttons)
- #F7F3EC cream on #A85533: 4.73:1 ✓ (CTA buttons)
- #1C2B1E text on cream: 13.43:1 ✓ (body text everywhere)
- #4A6741 sage as text on cream: 5.74:1 ✓ (labels, roles)
- white on #4A6741 sage: 6.35:1 ✓ (CTA section text)
- NEVER: dark text on sage bg (2.34:1 — fails)
- NEVER: terracotta as body/link text on cream (4.04:1 — fails)
- NEVER: terracotta + sage as fg/bg pair (1.42:1 — fails)

### Typography
```
--font-display:  'Fraunces Variable', 'Playfair Display', Georgia, serif
--font-body:     'DM Sans Variable', system-ui, sans-serif
```
Installed via: `@fontsource-variable/fraunces` + `@fontsource-variable/dm-sans`
Imported in global.css via `@import` (Vite resolves bare module specifiers in CSS)

**Font traps avoided:**
- Never Inter (the AI-site giveaway)
- Never Roboto, Open Sans, Montserrat, Lato

### Type scale — Perfect Fourth (1.333 ratio)
Defined in CSS custom properties; all sizes use `clamp()` for fluid scaling.
Min font-size: 16px (text-base minimum) — WCAG requirement.

---

## Layout Decisions

### Single-page architecture
One scrolling page. Sections are anchor-linked from nav and CTA buttons.
No sub-pages. A dedicated form page can be added later if the email capture needs room.

### Section order
1. Nav (sticky)
2. Hero (full-viewport)
3. Film Premise (60/40 text/image, desktop)
4. Impact Stats (sparse 3-column — typography only, no cards)
5. Film Details (definition-list style)
6. **Stories** (scrollytelling — 5 full-viewport panels, bidirectional fade) ← added June 2026
7. Team (2×2 grid, circular portraits)
8. Coalition (centered text, generous whitespace)
9. Founding Partner CTA (full-width, meadow background)
10. Footer (dark green, cream text)

### Section separators
Single 1px `<hr>` in `--color-straw` between sections (except before CTA, which has own bg).
Never section background-color switches for visual rhythm — that is the template tell.

### Stories section — scrollytelling (added June 2026)

**Decision:** 5 full-viewport stacked panels with bidirectional IntersectionObserver fade. No competing photo alongside stories — FilmPremise is the 60/40 image section; Stories is character-only.

**Psychology rationale:**
- Identifiable victim effect: 5 named individuals with specific parcels and specific losses/returns beats aggregate statistics
- Mattering Framework (Prilleltensky 2019): each bio demonstrates both "felt valued" (neighbors noticed, community saw) AND "added value" (fireflies returned, butterflies counted, river filtered) — the two required components that make stories resonate
- Scrollytelling = one story per attention window; full cognitive bandwidth per person with no visual competition
- Loss aversion built in: Victor DeMasi's count (500 → 250 over 28 years) is the loss narrative without stating it explicitly
- Social proof via ordinary people (not celebrities) — credibility without distance; visitor identifies, not admires

**Technical pattern:**
- Observer lives in `public/js/main.js`, NOT in the Astro component `<script>` tag
- Astro dev mode strips component scripts from the DOM; `main.js` loads reliably in both dev and prod
- `threshold: 0.15` with no `rootMargin` — 15% visibility triggers fade-in; bidirectional (cards fade OUT when leaving viewport)
- CSS: `opacity: 0` + `transform: translateY(28px)` → `opacity: 1` + `translateY(0)`, 700ms `cubic-bezier(0.16, 1, 0.3, 1)`
- `prefers-reduced-motion`: all transitions disabled; cards render at `opacity: 1` immediately
- Section must NOT have `data-reveal` attribute — the parent `[data-reveal]` opacity-0 state blocks child cards. Remove `data-reveal` from the stories `<section>` if the global reveal loop picks it up.

**Cloudflare caching lesson (hard-won):**
After any change to `public/js/main.js` or any file in `public/js/`, bump the `?v=N` query string on the `<script>` tag in `src/pages/index.astro`. Cloudflare edge nodes cache JS aggressively — the new URL forces a cache miss. Without this, the live site serves old JS for up to 4 hours after a deploy. This was the root cause of 3+ sessions of invisible Stories debugging.

```astro
<!-- Increment v= after every public/js/ change -->
<script src="/js/main.js?v=2" defer></script>
```

### AI-tell avoidance rules enforced in this build
- No Inter font
- No blue or purple gradients
- No `transform: translateY` on card hover
- No `box-shadow` on section containers (only on nav when scrolled — 1px line, not shadow)
- No three-column equal-weight feature grid
- Card hover: opacity shift only (0.85, 200ms ease-out)
- Terracotta: #A85533 — not #B5603C

---

## Performance Decisions

**LCP (hero image):** CSS gradient placeholder; `fetchpriority="high"` goes on the real img when added
**Fonts:** Preloaded via `<link rel="preload">` using Astro `?url` import
**Analytics:** Fathom only, script deferred before `</body>`, never in `<head>`
**Images:** All placeholders are CSS `background` — no broken img tags in initial build
**JS:** Zero JS on page except nav scroll behavior (Astro `<script>` tag, ~300 bytes)

---

## Accessibility Decisions

- WCAG 2.2 Level AA (DOJ rule effective January 2026)
- `<html lang="en">` present
- Skip link: first element rendered in `<body>` (inside Nav component)
- One `<h1>` only: the hero "ROOTED"
- All touch targets: min 44×44px (enforced via CSS `min-height`)
- `font-display: swap` on all `@font-face` declarations (handled by fontsource packages)
- `prefers-reduced-motion`: all transitions/animations disabled at 0.01ms
- Semantic HTML: `<button>`, `<a href>`, `<nav>`, `<main>`, `<article>`, `<footer>` — zero `<div onClick>`

---

## Forms

**Current state:** Formspree placeholder (zero-cost, immediate)
**Before launch:** Replace with Cloudflare Worker using write-to-queue-first pattern:
- Worker accepts POST
- Writes address to queue
- Queues confirmation email async
- Never synchronous send inside the request
**Code comment:** `<!-- TODO: replace with Cloudflare Worker endpoint -->` placed in FoundingPartnerCTA.astro

---

## Analytics

**Platform:** Fathom (cookieless, no consent banner required under GDPR/CCPA)
**Implementation:** External script, `defer`, before `</body>` — never in `<head>`
**SRI hash:** Add before launch once Site ID is confirmed
**Current state:** Commented out pending site ID — placeholder in index.astro

---

## Cloudflare Pages — Critical Pre-Deploy Notes

1. **Cache Rule (MANDATORY):** Cloudflare does NOT cache HTML by default.
   Create rule: content-type text/html → Edge TTL 4 hours.
   Without this, every page load hits the origin under viral traffic.

2. **NODE_VERSION:** Set `NODE_VERSION=20.11.0` in Cloudflare env vars + `.node-version` in repo root.

3. **Custom domain DNS:** "DNS Only" (grey cloud) — NOT proxied, or Cache Rules don't apply.

4. **Build command:** `npm run build`  |  **Output directory:** `dist`

Full sequence: docs/deploy-checklist.md
