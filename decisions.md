
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
