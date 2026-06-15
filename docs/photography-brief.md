# Photography Brief — ROOTED Documentary Site
All images below are currently CSS gradient placeholders. Replace before launch.
Find them in source by grepping: `grep -r "data-replace" src/`

---

## IMAGE 1 — Hero background
**File:** `public/images/hero-meadow.jpg` (or `.avif`)
**Component:** `src/components/Hero.astro`
**Aspect ratio:** 16:9
**Min dimensions:** 2400 × 1350px
**Target file size:** <200KB after compression (use AVIF → WebP → JPEG fallback stack)
**data-replace:** true

**Shot description:**
Wide-angle meadow landscape at golden hour. Connecticut native wildflowers and grasses
in the foreground — goldenrod, black-eyed Susan, wild bergamot preferred. Warm amber
light raking across the field. Sky visible at top third. No human subjects in frame.
The mood is abundant, alive, and unhurried.

**Technical note:** When real photo is added, replace the `.hero-bg` div with:
```html
<img
  src="/images/hero-meadow.avif"
  alt="Native meadow in golden hour light, Connecticut"
  width="1920"
  height="1080"
  fetchpriority="high"
  class="hero-bg-img"
/>
```
Remove the `role="img"` div. Add `fetchpriority="high"` — never `loading="lazy"` on the hero.

---

## IMAGE 2 — Film premise / editorial still
**File:** `public/images/film-still-01.jpg`
**Component:** `src/components/FilmPremise.astro`
**Aspect ratio:** 4:3
**Min dimensions:** 1200 × 900px
**Target file size:** <150KB
**data-replace:** true

**Shot description:**
Film still or meadow footage frame. A close-up or medium shot that feels cinematic —
not a stock photo. Candidates: a tight shot of native seed heads, a person's hands
releasing seeds, a macro of a bee on a native flower, or a wide shot of a meadow at
dawn with mist. The image should feel like it belongs in a documentary, not a garden
catalog.

---

## IMAGES 3–6 — Team portraits (4 total)
**Files:**
- `public/images/team-nick-lyon.jpg`
- `public/images/team-wylie-overstreet.jpg`
- `public/images/team-mel-finn.jpg`
- `public/images/team-william-sweet.jpg`

**Component:** `src/components/Team.astro`
**Aspect ratio:** 1:1 (square source; displayed as circle via CSS border-radius: 50%)
**Min dimensions:** 300 × 300px (displayed at 96px, but 2× for retina)
**Target file size:** <50KB each
**data-replace:** true

**Shot descriptions:**
1. **Nick Lyon** — Producer. Professional headshot or candid on set. Neutral or outdoor background.
2. **Wylie Overstreet** — Director. Can use an existing press photo from his YouTube channel. Outdoor preferred.
3. **Mel Finn** — Writer. Professional headshot. Neutral background.
4. **William Sweet** — Creator. Outdoor or documentary-context shot preferred.

**Swap instructions:** Replace each `.team-portrait` div with:
```html
<img
  src="/images/team-[name].jpg"
  alt="[Name], [Role] — ROOTED documentary"
  width="96"
  height="96"
  class="team-portrait"
  loading="lazy"
/>
```

---

## Photo compression guidance

Before adding any photo to `public/images/`:
1. Export from original at 2× the display size (retina)
2. Run through Squoosh (squoosh.app) — target AVIF at quality 60–70, under 200KB
3. Export WebP fallback at quality 75
4. Use the `<picture>` element for hero:
```html
<picture>
  <source srcset="/images/hero-meadow.avif" type="image/avif" />
  <source srcset="/images/hero-meadow.webp" type="image/webp" />
  <img src="/images/hero-meadow.jpg" alt="..." width="1920" height="1080" fetchpriority="high" />
</picture>
```
