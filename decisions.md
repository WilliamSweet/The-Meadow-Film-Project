
## 2026-06-29 — ImpactStats: Replace Owens Corning stat with C017
Replaced `$6,675→$140` (Owens Corning corporate campus case study, Tier 2, single source) with `7–22×` (Journal of Fish and Wildlife Management, Tier 1, peer-reviewed, multiple climates and soil types). William's rationale: the Owens Corning number was from one study and could imply meadows are effortlessly cheap; the 7–22× multiplier is more honest and more defensible. Description updated; attribution line and research details updated to cite Journal of Fish and Wildlife Management. Vault claim: C017.

## 2026-08-10 — Crew added, Sleepy Cat removed, donation route published
Four changes, one pass, not yet deployed.

1. **Team.astro — new "Camera & Sound" block.** Luke Geissbühler and Brian Troy as
   Cinematographer; Matt Sutton and Nick Bohun as Production Sound Mixer. Deliberately
   portrait-free and one type-tier down: eight circular portraits would flatten the
   four authors into eight equal faces. Same title used twice per department on
   purpose — William: naming a state after each title "makes them sound small." The
   credential line does the distinguishing instead. Matt Sutton is written but he is
   NOT to be announced yet (William, 2026-08-10: "wait to add this person").

2. **Location.astro — "One of the places the film visits" → "The people in the film."**
   Sleepy Cat Farm was dropped as a filming location on 2026-07-27 and the section had
   still been presenting it publicly as one for two weeks. Replaced with a roster
   paragraph: Doug Tallamy, Sara Weaner Cooper, Steve Zatz, Maggie and Paul Dobbins.
   Section id changed `location` → `people` (nothing linked to the old anchor).
   ⚠️ The four Sleepy Cat photographs are replaced with generic library meadow frames
   as a stopgap — swap in stills from the August 5 shoot when they exist.

3. **New Support.astro + wired into index.astro** between FilmDetails and the CTA.
   Nothing on the site had ever asked an individual for money. Routes to CID's own
   page for the film (documentaries.org/films/rooted), which went live between
   2026-08-06 and 2026-08-10 — a vault note calling that page "not built yet" is now
   stale. No card details are ever taken on this site. No card-processing percentage
   is published: the signed CID agreement §6(e) deducts 5% and names no card rate,
   and two internal notes disagree (3% vs 3.5%). Check route named as the
   lower-fee alternative.

4. **Footer.astro legal line rewritten.** Was "Tax-deductible donations are available
   through our fiscal sponsor. Contact us for details" — a live donor asked to send an
   email and wait. Now names CID, its 501(c)(3) status and Massachusetts registration,
   and links to the donation page.

Also: Founding Partner deadline August 13 → **September 13, 2026** (William's call).

Verified live on localhost:4321 after `npm run build`: 4 crew cards render with the
right names, "Sleepy Cat" appears nowhere in the rendered DOM, donate button resolves
to the CID URL, no broken images, crew role color #4A6741 (5.74:1 on cream) and CTA
#A85533 on white (5.23:1) both hold the locked palette pairs.

NOT deployed — William asked to hold. Open: whether "Rooted" is now the public title,
given CID published the film under it while project canon still forbids it.

## 2026-08-10 (later) — Five audit fixes, and the reveal bug underneath them
Four design reviews (impeccable audit, accessibility-review, design-system, design-critique,
ux-copy) produced five fixes. Applied in order. Still not deployed.

1. **Scroll-reveal no longer gates content on a transition.** `main.js` hides every section at
   opacity 0 and fades it in on scroll. Anything rendering the page without scrolling saw
   empty cream. Two attempts before the right one:
   - First attempt: a 3s timer adding `.is-visible`, skipped if a scroll had fired. Wrong twice.
     One stray scroll event killed the net for the session, and `.is-visible` only *starts* a
     transition.
   - **Root cause, measured:** a hidden document freezes transition clocks. `.tallamy-feature`
     and `.meadow-break` held `.is-visible` with `getAnimations()` reporting
     `playState: "running", currentTime: 0` — started, frozen, permanently at opacity 0.
     No class-based fix can cure this; the transition itself is the problem.
   - **Fix:** new `[data-reveal].reveal-now` class in global.css sets the final values with
     `transition: none !important`. `main.js` applies it on `visibilityState !== 'visible'` at
     load, on `visibilitychange`, on `beforeprint`, and as a 10-second last resort. 10s not 3s
     so a visitor reading the hero never loses the fade on the rest of the page.
   - **Honest ceiling:** `loading="lazy"` images still do not fetch in a hidden document — 0 of
     27 loaded in testing. Text and layout render; below-fold images do not. Inherent to lazy
     loading. Link previews are unaffected: they use the `og:image` meta tag, already set.

2. **Three spacing tokens defined.** `--space-5` (20px), `--space-10` (40px), `--space-20`
   (80px) were called 12 times across four components and defined nowhere; a missing CSS
   variable fails silently and the browser drops the whole declaration. The Film section's
   grid gap went from `normal` to 40px. Coalition item padding now resolves.
   (`.coalition-list { gap: 0 }` is deliberate — its spacing is item padding. Not a bug.)

3. **Palette unified.** `--color-bg` and `--color-text` had been changed to #F4EFE6 / #1C1A17
   while 22 component declarations still hardcoded the old #F7F3EC / #1C2B1E — two creams and
   two near-blacks rendering side by side. All 22 now use tokens; verified zero legacy hexes
   remain and the CTA heading computes rgb(244,239,230), matching the body.

4. **Carousel ARIA corrected.** `role="tablist"`/`role="tab"` promised tab panels that do not
   exist; a screen reader announced "tab, 1 of 4" and found nothing. Removed. Dots are buttons
   with `aria-current` and a fuller label ("Show photo 1 of 4"). Added `aria-live="polite"` to
   the track so slide changes are announced. Touch targets 8px → 44px via a pseudo-element;
   the visible dot stays 8px.

5. **Dead file archived, stale docs corrected.** `IndividualSignup.astro` no longer rendered
   and still held a live Formspree endpoint (retired 2026-07-05) plus the only use of the
   nonexistent `--color-sage`. Archived to `vault/archive/rooted-film/` per Bright Line #3.
   `docs/build-decisions.md` corrected on palette, font (Newsreader not Fraunces), and forms.
   `docs/copy-todo.md` given a status table — 4 of 7 items were done or void.

Also fixed from the first audit pass: footer legal contrast 4.43:1 → 6.51:1, nav wordmark /
footer email / CTA action links to 44px tap areas on touch, donate section given `data-static`,
fifth section eyebrow removed.

**Verified live, hidden-document state:** 13 of 13 sections at opacity 1 · zero undefined tokens ·
zero legacy hardcoded colors · zero broken images · design detector returns `[]` on all seven
changed files · Film grid gap 40px · donate button resolves to the CID URL · deadline reads
September 13, 2026 · "Sleepy Cat" absent from the DOM.
**NOT verified:** the fade still looking right for a visitor with the page frontmost — the test
pane stayed hidden throughout. The visible-state code path is unchanged apart from the 10s
backstop, but William should eyeball one scroll-through before deploying.

`main.js` cache-bust bumped v=2 → v=6.

## 2026-08-24 — Mobile load-speed pass: lazy loading, responsive image variants, real cache headers

**Why William gave:** "my astro website ... is a bit slow when it loads in on phone ... I want the
same website, but make it load faster." Same design, fewer bytes — nothing visual was allowed to
change.

**What was actually wrong** (measured against the live site, not guessed):
1. `loading="eager"` on story backgrounds, coalition logos, carousel slides and every botanical —
   ~3.2 MB of below-the-fold imagery competing with the hero for a phone's bandwidth.
2. No `srcset` anywhere. A 2400px hero (295 KB) went whole to a 390px screen. `logo-hnp.png` was
   4969 px / 417 KB for a 260px slot; `favicon.png` was 512×512 / 331 KB.
3. `_headers` said `no-cache, must-revalidate` for images and JS, and the content-hashed `/_astro/`
   bundle came back `cf-cache-status: DYNAMIC` — nothing cached, so a repeat visit was as slow as
   the first.
4. 14 MB of video in `public/video/` that no component references.

**What changed:**
- Every image except the hero and the nav mark is now `loading="lazy" decoding="async"`.
- `scripts/gen-image-variants.mjs` (new) builds 480/768/1024/1440/1920 WebP variants into
  `public/images/_r/` for every image src/ actually references, and `src/lib/images.ts` (new) hands
  components the matching `srcset`. Wired as `npm run images` / `prebuild`. Astro cannot optimize
  anything in `public/`, and moving 72 images into `src/assets/` would have touched every component
  — this gets the same result without the refactor. Missing variants degrade to the original file,
  so a build that skips the step still renders correctly.
- 15 images now carry `srcset`; the hero is preloaded with matching `imagesrcset`, and the two fonts
  actually used are preloaded (they were previously discovered only after the CSS parsed).
- Four files re-encoded (originals in `.image-originals/`, also in git history): favicon 331→25 KB,
  logo-hnp 417→33 KB (WebP), pollinator icon 306→27 KB (WebP), milkweed botanical 400→101 KB.
  Side-by-side comparison at display size shows no visible difference.
- `public/_headers` rewritten: `/_astro/*` immutable for a year, images a week, HTML never.
- Fraunces dropped — it was only a fallback behind Newsreader and never rendered. `cormorant-sc`
  was an unused dependency. `public/video/` moved to `unused-assets/video/` (kept, not deleted).

**Result:** whole page at phone size, all 29 images, 4.83 MB → 1.38 MB. Before first paint the
phone now fetches one 63 KB hero variant instead of ~3.2 MB of eager imagery.

**Left alone deliberately:** GSAP/ScrollTrigger (117 KB, drives the parallax) — removing it would
change how the site moves, and the instruction was same site, faster. ~11 MB of unreferenced photos
in `public/images/` also stay; they are never requested by a visitor, so they cost deploy size only,
and `public/images/sleepy-cat/` is reserved for a carousel per this project's CLAUDE.md.

**Not verified yet:** the cache-header fix. `/images/*` on the live site returns
`max-age=14400`, which matches neither the old nor the new `_headers` file — so something in the
Cloudflare dashboard (a Cache Rule, or Development Mode) is overriding the file and needs checking
there after the next deploy.

## 2026-08-24 (same day, follow-up) — Lazy images need explicit width/height, or they never load at all

**What broke:** William, on the first pass above: "seems a lot smoother, some images arent loading
in." He was right. Switching the coalition logos and the botanical illustrations to
`loading="lazy"` blanked them.

**Why:** those images get one axis from CSS and leave the other on `auto` —
`.coalition-logo` is `height: 48px; width: auto`, `.stats-botanical` and `.story-botanical` are
`width: 22%/38%; height: auto`. With no `width`/`height` attributes the browser has no aspect ratio
before the file arrives, so the element measures **0 px on the auto axis**. A zero-area element
never intersects the viewport, so the native lazy loader never fires, so the file never arrives.
Circular: it will not load because it has no size, and it has no size because it has not loaded.
Measured live before the fix: `.coalition-logo` was `0x48`, `.story-botanical` `195x0`.

It never showed up before because those images were `loading="eager"` — an eager image loads
regardless of geometry, so the missing dimensions were invisible.

**Fix:** `scripts/gen-image-variants.mjs` now also writes `src/lib/image-manifest.json` — intrinsic
width and height for all 28 referenced images. `responsive()` returns them, and the five affected
image spots (both coalition logo slots, the two stats botanicals, the story botanical, the Tallamy
botanical) emit `width`/`height`. Same fix removes layout shift as a bonus.
`.story-bg-img` and `.carousel-img` are deliberately left without attributes: both are sized 100% on
*both* axes by CSS, so they were never at risk.

**Verified after the fix:** zero images with zero area; coalition logos measure 203x48, 118x48,
49x48, 38x48, 96x48 before their files load; all 29 images load on scroll; all 84 image URLs in the
build resolve to a file; screenshots of the coalition wall and the stats band show every logo and
both botanicals rendering.

**Testing note for next time — cost me three wrong readings.** The Browser pane reports
`document.visibilityState: "hidden"`, and Chrome suspends lazy-image loading in a hidden tab, so
"image did not load" there proves nothing. Separately, the dev server died mid-session and served
200s with empty bodies, which renders as a broken-image icon and looks exactly like a corrupt file.
Check `preview_list` for a live process and fetch + `createImageBitmap` each URL before concluding
an image is broken.
