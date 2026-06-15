# Deploy Checklist — ROOTED Documentary Site
Run this in order, every step, before considering the site live.

---

## Pre-push

- [ ] Run `npm run build` locally — zero errors
- [ ] Grep for banned AI-tell words: `grep -oi "seamless\|transformative\|innovative\|leverage\|holistic\|journey\|empower\|elevate\|tapestry\|pillar\|cornerstone\|stakeholder" dist/index.html`
- [ ] Confirm `[DATE TBD]` in FoundingPartnerCTA has been replaced with the real date
- [ ] Confirm `[PLACEHOLDER: what Founding Partners receive]` has been filled
- [ ] Replace Formspree `YOUR_FORM_ID` with real form ID, or swap to Cloudflare Worker
- [ ] Add Fathom site ID: uncomment the script tag in `src/pages/index.astro` and replace `YOUR_SITE_ID`
- [ ] Compute Fathom SRI hash: `curl -s https://cdn.usefathom.com/script.js | openssl dgst -sha384 -binary | openssl base64 -A`
- [ ] Update `<link rel="preload">` font paths in index.astro with actual hashed filenames from `dist/_astro/`
- [ ] Verify `hello@rootedfilm.com` domain email is live and receiving

---

## GitHub

- [ ] Push to a public GitHub repo (Cloudflare Pages requires access to the repo)
- [ ] Commit message: ASCII only (no smart quotes, no em dashes)
- [ ] Confirm `.gitignore` is excluding `dist/` and `node_modules/` and `.env`

---

## Cloudflare Pages — initial setup

- [ ] Go to Cloudflare Pages → Create project → Connect to GitHub repo
- [ ] Set build command: `npm run build`
- [ ] Set output directory: `dist`
- [ ] Add environment variable: `NODE_VERSION` = `20.11.0`
- [ ] Deploy — wait for build to complete and note the `.pages.dev` preview URL

---

## Cloudflare Pages — Cache Rule (MANDATORY — do this before any traffic)

Cloudflare does NOT cache HTML by default. Without this rule, every page load hits
the origin server. One press hit will exhaust your origin under default settings.

- [ ] In Cloudflare dashboard: Rules → Cache Rules → Create rule
- [ ] Rule name: `Cache HTML pages`
- [ ] When: `Response MIME type equals text/html`
- [ ] Then: `Edge TTL → Ignore cache-control header and use this TTL → 4 hours`
- [ ] Save and deploy rule

---

## Custom domain

- [ ] In Cloudflare Pages: Custom Domains → add your domain
- [ ] In Cloudflare DNS: set the root record to "DNS Only" (grey cloud, NOT proxied)
  — Note: if the domain is behind Cloudflare proxy (orange cloud), cache rules apply normally.
    Grey cloud / DNS Only is for if you're using an external nameserver. Confirm your DNS setup.
- [ ] Wait for SSL certificate to provision (usually < 5 minutes via Cloudflare)
- [ ] Confirm site loads on custom domain with HTTPS

---

## Verification

- [ ] Run security headers check: https://securityheaders.com — enter your domain
  — Expected: all five headers present (X-Frame-Options, X-Content-Type-Options,
    Referrer-Policy, Permissions-Policy, Strict-Transport-Security)
- [ ] Run Lighthouse Mobile against live URL (Chrome DevTools → Lighthouse → Mobile)
  — Target: 90+ across Performance, Accessibility, Best Practices, SEO
- [ ] Confirm skip link works: tab to first focus on the page — it should say "Skip to main content"
- [ ] Confirm form submits: test with a real email address, check the Formspree dashboard (or Worker logs)
- [ ] Confirm nav scroll behavior: scroll 80px — logo should change from cream to dark

---

## Post-launch (within 1 hour)

- [ ] Submit sitemap to Google Search Console
  — Sitemap URL: `https://yourdomain.com/sitemap.xml`
  — Note: Astro static does not auto-generate a sitemap. Add `@astrojs/sitemap` integration if needed.
- [ ] Verify Fathom is recording page views (Fathom dashboard → Real-time)
- [ ] Share `.pages.dev` staging URL with team before pointing custom domain

---

## v2 Swap (July 15 campaign launch)

- [ ] Replace hero CTA href from `#founding-partner` to the external crowdfunding URL
- [ ] Replace hero CTA text from "Become a Founding Partner" to "Support the Campaign"
- [ ] Add the 90-second trailer/sizzle reel to the Team section (pending asset)
- [ ] Update coalition section with any additional confirmed partners
- [ ] Add campaign progress bar (show pre-loaded total — never display $0)
- [ ] Re-run full deploy checklist
