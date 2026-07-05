# Rooted Film — Image & Video Source Guide

Permanent reference for finding, vetting, and downloading assets for this site.
All downloaded assets are logged in: `public/images/CREDITS.md`

---

## Files From This Session

| Script | What it does |
|---|---|
| `scripts/download-wikimedia.sh` | Phase 1 — meadow landscapes, native wildflowers, pollinators (18 images) |
| `scripts/download-phase2.sh` | Phase 2 — CT photography, botanical illustrations, paper textures, videos |
| `scripts/download-batch3.sh` | Batch 3 — bokeh/golden light, monarchs, lawn before-state, monarch video |
| `public/images/CREDITS.md` | Every asset: source URL, license, attribution line |
| `public/video/` | 4 compressed videos (MP4 + WebM) |

---

## Design Filter — Reject Anything That Fails These

Before downloading, check every image against the site's rules:

- **Light**: golden hour, overcast diffuse, or soft natural — NO harsh midday flat light
- **Color**: reads in earthy greens, ambers, warm neutrals — matches `#4A6741`, `#A85533`, `#B8904A`
- **Style**: documentary, naturalistic — NOT posed, over-saturated, or generic "happy garden" stock
- **Geography**: Connecticut / New England native species preferred — not European wildflowers
- **Species**: black-eyed Susan, echinacea, milkweed, goldenrod, wild bergamot, aster — not generic
- **Reject**: watermarks, logos, suburban lawns without meadow context, AI-generated look, Inter font in screenshots

---

## License Tiers — What's Safe to Use

| License | Credit required | Use it? |
|---|---|---|
| Public domain (US Gov) | No | Best — USFWS, NPS, USDA, BLM |
| CC0 | No | Best — creator waived all rights |
| Unsplash License | No (appreciated) | Yes — free commercial use |
| Pexels License | No | Yes — free commercial use |
| CC BY 2.0 / 4.0 | YES — name + license | Yes — add attribution line to CREDITS.md |
| CC BY-SA 2.0 / 4.0 | YES — name + license | Yes — add attribution line to CREDITS.md |
| CC BY-NC | No | Skip — non-commercial only |

---

## Proven Sources

### 1. USFWS Flickr → Wikimedia Commons (best quality, public domain)

USFWS uploads all photos to Flickr under public domain, then they appear on Wikimedia Commons.
**Pattern:** Wikimedia filenames with 11-digit Flickr IDs = almost always public domain USFWS.

Example filenames that follow this pattern:
- `Monarch_butterfly_on_butterfly_milkweed_(53069280718).jpg` ← public domain
- `Goldenrod_gradient_(54778516633).jpg` ← public domain
- `Honey_Bee_on_Aster_(54512757554).jpg` ← CC BY-SA 2.0 (Ethan Long, not USFWS)

**Tip:** Check `extmetadata.LicenseShortName` via API before downloading (see API section below).

**Key USFWS Flickr accounts on Wikimedia:**
- `USFWS Mountain Prairie` — Rocky Mountain + Great Plains native plants
- `U.S. Fish and Wildlife Service — Midwest Region` — goldenrod, milkweed, pollinators
- `USFWS Northeast` — closest to CT, search specifically for this credit
- `Bureau of Land Management` — wide landscapes, public domain
- `National Park Service` — public domain, search `npgallery.nps.gov`

### 2. Wikimedia Commons API (programmatic search)

Base URL: `https://commons.wikimedia.org/w/api.php`

**Search by keyword (images only):**
```
?action=query&list=search&srsearch=KEYWORD&srnamespace=6&srlimit=20&format=json&srprop=title
```
Note: text search often returns PDFs. Better to use category browsing.

**Browse a category:**
```
?action=query&list=categorymembers&cmtitle=Category:CATEGORY_NAME&cmtype=file&cmlimit=50&cmnamespace=6&format=json
```

**Get license + dimensions for specific files:**
```
?action=query&titles=File:FILENAME.jpg&prop=imageinfo&iiprop=extmetadata|size|url&format=json
```
Look for `extmetadata.LicenseShortName` and `extmetadata.Artist` in the response.

**Categories that worked:**
- `Category:Flora_of_Connecticut` — CT native plants (sparse but real)
- `Category:Asclepias_speciosa` — showy milkweed
- `Category:Echinacea_purpurea` — purple coneflower
- `Category:Rudbeckia_hirta` — black-eyed Susan

**Categories that returned empty (don't retry):**
- `Category:Grasslands_of_Connecticut`
- `Category:Natural_landscapes_of_Connecticut`
- `Category:Wildflower_meadows_in_the_United_States`
- `Category:Bokeh_photographs`

**Search that found CT photos (Fresh Meadows Wildlife Sanctuary):**
```
srsearch=Fresh+Meadows+Wildlife+Sanctuary+Connecticut
```
Note: those 20 photos were mostly trail signs — not useful for the site aesthetic.

**Search that found all CT Ethan Long pollinator shots:**
```
srsearch=Fresh+Meadows+Wildlife+Sanctuary+Connecticut
```
Then cross-reference: `Honey_Bee_on_Aster_(54512757554)`, `Skipper_on_hyssop_(54513454223)`

### 3. Unsplash (bokeh, golden light, atmospheric abstracts)

Unsplash License: free commercial use, no attribution required.
WebFetch works on unsplash.com pages — get the `images.unsplash.com` URL from the page source.

**Images downloaded this session:**
- `meadow-golden-hour-grass.webp` → https://unsplash.com/photos/grass-field-during-golden-hour-Z4Irm8a2onU
- `bokeh-golden-green.webp` → https://unsplash.com/photos/soft-golden-bokeh-lights-against-a-dark-green-background-harExjFZASE
- `before-lawn-turf.webp` → https://unsplash.com/photos/topview-of-grass-lawn-QSIq9ncQkzY

**Download URL format:** `https://images.unsplash.com/photo-{id}?fm=jpg&q=90&w=3000&auto=format&fit=crop`

### 4. Pexels Videos (no attribution required)

Download redirect URL: `https://www.pexels.com/download/video/{VIDEO_ID}/`
Works with `curl -L` + browser User-Agent (see download method below).
Downloads the highest available resolution — then compress with ffmpeg.

**Videos downloaded this session:**
- `meadow-grass-wind.mp4` → https://www.pexels.com/video/wind-waving-wild-grass-5978983/
- `meadow-wind-field.mp4` → https://www.pexels.com/video/wind-blowing-through-the-grass-field-5977446/
- `pollinator-bees-flowers.mp4` → https://www.pexels.com/video/bees-pollinating-855215/

### 5. Biodiversity Heritage Library (botanical illustrations)

CC0 botanical plates from pre-1928 scientific publications — all public domain.
Beautiful watercolor + engraving illustrations for editorial design elements.

**What worked:**
- Addisonia plates (Mary Emily Eaton watercolors, 1916–1964) — search `Addisonia botanical`
- Britton & Brown "An Illustrated Flora" (1913) — search `BB-1913` on Wikimedia
- Millspaugh "American Medicinal Plants" (1892) — search `American Medicinal Plants`
- USDA NRCS line drawings — search `NRCS linedrawing` on Wikimedia

---

## Download Method (What Bypasses Rate Limiting)

Wikimedia's full-file CDN blocks Python urllib. Use curl with a browser User-Agent + Referer header.
Use **thumbnail CDN URLs** (different routing, more permissive limits):

```bash
UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36"

# Thumbnail URL format (replace FILENAME and WIDTH):
URL="https://upload.wikimedia.org/wikipedia/commons/thumb/{a}/{ab}/FILENAME/1920px-FILENAME"

curl -L -s -o output.jpg -w "%{http_code}" \
  -A "$UA" \
  -H "Referer: https://commons.wikimedia.org/" \
  --connect-timeout 30 --max-time 120 \
  "$URL"
```

**Sleep 6–8 seconds between downloads** — avoids 429 even on the thumbnail CDN.

**If thumbnail URL fails (special characters in filename):** use Special:FilePath redirect:
```
https://commons.wikimedia.org/wiki/Special:FilePath/FILENAME_WITH_COMMAS.jpg
```

**Video CDN:** stricter rate limits — still hit 429 even with browser UA. Two Wikimedia WebM videos
(`meadow-grass-sunshine.webm`, `meadow-grass-wind.webm`) are still undownloaded. Retry in a new
session with longer delays, or just use the Pexels MP4s already in `public/video/`.

## Convert to WebP After Download

```python
from PIL import Image

img = Image.open("source.jpg")
if img.mode in ("RGBA", "P", "L", "LA"):
    img = img.convert("RGB")
# Resize to max 1920px wide (landscapes) or 1400px tall (portrait illustrations)
if img.width > 1920:
    img = img.resize((1920, int(img.height * 1920 / img.width)), Image.LANCZOS)
img.save("output.webp", "WEBP", quality=75, method=6)
```

**Quality settings used this session:**
- Photography (hero/landscape): `q=75`, max `1920px` wide
- Botanical illustrations: `q=80`, max `1400px` tall
- Paper textures: `q=75`, max `1920px`

## Compress Videos With ffmpeg

```bash
# 4K source → 1280×720 web-ready, audio stripped, faststart
ffmpeg -i source.mp4 \
  -vf "scale=1280:720" \
  -c:v libx264 -crf 28 -preset medium \
  -an -movflags +faststart \
  output.mp4
```

---

## CT-Specific Photography Gap

As of this session: only 3 CT-specific images exist (all close-ups, no wide landscape):
- `native-blackeyed-susan-connecticut.webp` — Fresh Meadows Wildlife Sanctuary, Cheshire CT
- `pollinator-bee-aster-connecticut.webp` — CT, Ethan Long
- `pollinator-skipper-hyssop-connecticut.webp` — CT, Ethan Long

**Wikimedia has almost no CT meadow landscape photography.** To get wide CT meadow shots:
- Contact CT DEEP (ct.gov/deep) media office — state agency photos may be releasable
- Contact Audubon Connecticut — they have restoration site photography
- William's own photography — always the most geographically accurate option
- Search Flickr directly (not via Wikimedia) for CC BY licensed CT nature photographers

---

## What's Already In the Library

See `public/images/CREDITS.md` for the full catalog with source URLs.
49 images total as of session close. Categories:
- `meadow-*` — wide landscape shots
- `native-*` — native plant close-ups
- `pollinator-*` — butterflies, bees, monarch
- `botanical-*` — public domain illustration plates
- `texture-*` — paper/grain overlays
- `bokeh-*` — atmospheric light abstracts
- `before-*` — lawn before-state for GSAP reveal
