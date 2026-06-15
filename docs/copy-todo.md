# Copy TODO — ROOTED Documentary Site
Every placeholder in the live site, numbered. All must be filled before launch.

---

## PLACEHOLDER 1 — Founding Partner benefit statement
**Location:** `src/components/FoundingPartnerCTA.astro`, line ~21
**Current text:** `[PLACEHOLDER: what Founding Partners receive — visibility, film credit, coalition listing]`
**What it needs:** One sentence. What does an organization actually get by signing on?
  Examples: listing on the film's credits and website, use of the ROOTED coalition badge,
  early access to the film for screenings, co-branded campaign materials.
**Character target:** 80–120 characters. One sentence. No hedging.

---

## PLACEHOLDER 2 — Founding Partner deadline date
**Location:** `src/components/FoundingPartnerCTA.astro`, line ~34
**Current text:** `[DATE TBD]` inside: "Founding Partner registration closes **[DATE TBD]**."
**What it needs:** The actual closing date for Founding Partner status.
  IMPORTANT: The Wix site said "July 1" — that date was wrong for the July 15 campaign.
  Confirm the real deadline with William before publishing.

---

## PLACEHOLDER 3 — Formspree endpoint
**Location:** `src/components/FoundingPartnerCTA.astro`, line ~26
**Current text:** `action="https://formspree.io/f/YOUR_FORM_ID"`
**What it needs:** Either:
  a) A real Formspree form ID (sign up at formspree.io, create a form, copy the ID), OR
  b) The Cloudflare Worker endpoint URL (preferred for launch — see build-decisions.md)
**Note:** The HTML comment above the form explains the Cloudflare Worker async pattern.

---

## PLACEHOLDER 4 — Fathom site ID
**Location:** `src/pages/index.astro`, last line (commented out)
**Current text:** `<!-- <script src="https://cdn.usefathom.com/script.js" data-site="YOUR_SITE_ID" defer></script> -->`
**What it needs:**
  a) Sign up at usefathom.com
  b) Create a site for your domain — Fathom generates a 8-character site ID
  c) Replace `YOUR_SITE_ID` with the real ID
  d) Uncomment the script tag
  e) Compute and add SRI hash (see deploy-checklist.md)

---

## PLACEHOLDER 5 — Font preload paths
**Location:** `src/pages/index.astro`, lines ~14–19 (commented out)
**Current text:** Two commented-out `<link rel="preload">` tags
**What it needs:** After running `npm run build`, check `dist/_astro/` for the actual
  WOFF2 filenames (they have content hashes, e.g. `fraunces-latin-wght-normal.ukD16Tqj.woff2`).
  Then uncomment the preload links and fill in the correct href values.
  This is an LCP performance item — handle before Lighthouse audit.

---

## PLACEHOLDER 6 — Contact email domain
**Location:** `src/components/Footer.astro`
**Current text:** `hello@rootedfilm.com`
**Status:** This is the correct email — but the domain must be set up and receiving mail
  before launch. If the domain is not yet `rootedfilm.com`, update this to the correct address.

---

## PLACEHOLDER 7 — Coalition section expansion (ongoing)
**Location:** `src/components/Coalition.astro`
**Current state:** 5 confirmed partners listed as text
**What it needs:** When the coalition reaches ~12+ confirmed partners, switch from the
  text list to a logo wall grid. Only display logos for organizations that have formally
  signed on. Do NOT display logos for organizations still in conversation.
  This is a design swap, not just a copy edit — see docs/build-decisions.md for the reasoning.
