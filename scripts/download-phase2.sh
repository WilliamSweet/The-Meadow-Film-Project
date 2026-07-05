#!/bin/bash
# Phase 2 — Rooted Film asset downloads
# CT photography, botanical illustrations, paper textures, videos
# All sources verified free/licensed. See CREDITS.md for attribution.

IMAGES_DIR="/Users/williamsweet/Desktop/LTM folder/LTM-Operations/rooted-film/public/images"
VIDEO_DIR="/Users/williamsweet/Desktop/LTM folder/LTM-Operations/rooted-film/public/video"
TMP_DIR="/tmp/rooted-phase2"
mkdir -p "$TMP_DIR" "$VIDEO_DIR"

UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36"

# ─── Download + convert image to WebP ─────────────────────────────────────────
download_image() {
  local url="$1"
  local filename="$2"
  local max_px="${3:-1920}"
  local quality="${4:-75}"
  local out="$IMAGES_DIR/$filename"

  if [ -f "$out" ]; then
    echo "SKIP (exists): $filename"
    return 0
  fi

  local ext="${url##*.}"
  # Strip query strings from extension detection
  ext="${ext%%\?*}"
  local tmp="$TMP_DIR/${filename%.webp}.$ext"

  echo "Downloading: $filename ..."
  http_code=$(curl -L -s -o "$tmp" -w "%{http_code}" \
    -A "$UA" \
    -H "Referer: https://commons.wikimedia.org/" \
    --connect-timeout 30 \
    --max-time 120 \
    "$url")

  if [ "$http_code" != "200" ] || [ ! -s "$tmp" ]; then
    echo "  FAILED (HTTP $http_code): $filename"
    rm -f "$tmp"
    return 1
  fi

  python3 - <<PYEOF
from PIL import Image
import sys, os

src = "$tmp"
dst = "$out"
max_px = $max_px
quality = $quality

try:
    img = Image.open(src)
    if img.mode in ("RGBA", "P", "L", "LA"):
        img = img.convert("RGB")
    w, h = img.size
    if w > max_px and w >= h:
        img = img.resize((max_px, int(h * max_px / w)), Image.LANCZOS)
    elif h > max_px and h > w:
        img = img.resize((int(w * max_px / h), max_px), Image.LANCZOS)
    img.save(dst, "WEBP", quality=quality, method=6)
    size_kb = os.path.getsize(dst) // 1024
    print(f"  Saved: {os.path.basename(dst)} ({img.width}x{img.height}, {size_kb} KB)")
except Exception as e:
    print(f"  Convert error: {e}", file=sys.stderr)
    sys.exit(1)
PYEOF

  rm -f "$tmp"
  sleep 6
}

# ─── Download video (no conversion — store as-is) ─────────────────────────────
download_video() {
  local url="$1"
  local filename="$2"
  local out="$VIDEO_DIR/$filename"

  if [ -f "$out" ]; then
    echo "SKIP (exists): $filename"
    return 0
  fi

  echo "Downloading video: $filename ..."
  http_code=$(curl -L -s -o "$out" -w "%{http_code}" \
    -A "$UA" \
    -H "Referer: https://commons.wikimedia.org/" \
    --connect-timeout 30 \
    --max-time 300 \
    "$url")

  if [ "$http_code" != "200" ] || [ ! -s "$out" ]; then
    echo "  FAILED (HTTP $http_code): $filename"
    rm -f "$out"
    return 1
  fi

  size_kb=$(du -k "$out" | cut -f1)
  echo "  Saved: $filename (${size_kb} KB)"
  sleep 4
}

echo ""
echo "=== Phase 2: CT Photography ==="
echo ""

# Connecticut bee on aster — Ethan Long, CC BY-SA 2.0
download_image \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/Honey_Bee_on_Aster_%2854512757554%29.jpg/1920px-Honey_Bee_on_Aster_%2854512757554%29.jpg" \
  "pollinator-bee-aster-connecticut.webp"

# Connecticut skipper on hyssop — Ethan Long, CC BY-SA 2.0
download_image \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/Skipper_on_hyssop_%2854513454223%29.jpg/1920px-Skipper_on_hyssop_%2854513454223%29.jpg" \
  "pollinator-skipper-hyssop-connecticut.webp"

# Tall grass in wind — CC0 via Unsplash/Wikimedia
download_image \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/2/23/Tall_Grass_in_the_Wind_%28Unsplash%29.jpg/1920px-Tall_Grass_in_the_Wind_%28Unsplash%29.jpg" \
  "meadow-tall-grass-wind.webp"

echo ""
echo "=== Phase 2: Botanical Illustrations ==="
echo ""
# Max 1400px on longest side — these are editorial/detail images, not full-bleed heroes
# q80 for line drawings (they compress well and need crisp lines)

# Solidago squarrosa — Addisonia color watercolor plate, Mary Emily Eaton, 1918, public domain
download_image \
  "https://upload.wikimedia.org/wikipedia/commons/4/43/Addisonia_03-102_Solidago_squarrosa.png" \
  "botanical-solidago-watercolor.webp" \
  "1400" "80"

# Solidago altissima — Britton & Brown 1913, line drawing, public domain
download_image \
  "https://upload.wikimedia.org/wikipedia/commons/4/43/Solidago_altissima_BB-1913.png" \
  "botanical-solidago-linedrawing.webp" \
  "1400" "80"

# Asclepias milkweed — Millspaugh American Medicinal Plants 1892, public domain
download_image \
  "https://upload.wikimedia.org/wikipedia/commons/b/b5/Asclepias_Cornuti-American_Medicinal_Plants-2-0743-134.png" \
  "botanical-milkweed-millspaugh.webp" \
  "1400" "80"

# Common milkweed — Alice Lounsberry Guide to Wild Flowers, public domain
download_image \
  "https://upload.wikimedia.org/wikipedia/commons/e/e6/Common_Milkweed-Guide_Wild_Flowers-409-44.png" \
  "botanical-milkweed-lounsberry.webp" \
  "1400" "80"

# Rudbeckia laciniata — NRCS/USDA line drawing, public domain
download_image \
  "https://upload.wikimedia.org/wikipedia/commons/9/9b/Rudbeckia_laciniata-linedrawing.png" \
  "botanical-rudbeckia-nrcs.webp" \
  "1400" "80"

# Rudbeckia hirta — Britton & Brown 1913 line drawing, public domain
download_image \
  "https://upload.wikimedia.org/wikipedia/commons/0/01/Rudbeckia_hirta-linedrawing.png" \
  "botanical-rudbeckia-bb1913.webp" \
  "1400" "80"

echo ""
echo "=== Phase 2: Paper / Grain Textures ==="
echo ""
# Max 1920px. CC BY 2.0 — credit: Pink Sherbet Photography

download_image \
  "https://upload.wikimedia.org/wikipedia/commons/b/b8/Dark_Damaged_Old_Vintage_Book_Paper_Pages_Free_High_Resolution_Wallpaper_Texture_Creative_Commons_%288077075546%29.jpg" \
  "texture-vintage-book-pages.webp"

download_image \
  "https://upload.wikimedia.org/wikipedia/commons/5/58/Free_antique_damaged_wrinkled_stained_book_inside_cover_texture_for_layers_%282986258435%29.jpg" \
  "texture-antique-book-cover.webp"

download_image \
  "https://upload.wikimedia.org/wikipedia/commons/1/1c/Free_dark_vintage_paper_page_texture_for_layers_%282982207584%29.jpg" \
  "texture-dark-vintage-paper.webp"

download_image \
  "https://upload.wikimedia.org/wikipedia/commons/9/96/Brown_Paper_Bag_Texture_Free_Creative_COmmons_%286816220224%29.jpg" \
  "texture-brown-kraft-paper.webp"

echo ""
echo "=== Phase 2: Videos ==="
echo ""

# Grass and sunshine — CC BY-SA 4.0, HendrixHammer, 12.8s, 1920x1080
download_video \
  "https://upload.wikimedia.org/wikipedia/commons/8/8c/Grass_and_sunshine.webm" \
  "meadow-grass-sunshine.webm"

# Wind blowing grass and plants — CC BY-SA 4.0, GolhaMedia, 25s, 1920x1080
download_video \
  "https://upload.wikimedia.org/wikipedia/commons/9/96/Wind_blowing_into_grass_and_plants_on_a_sunny_day_2024-05-09.webm" \
  "meadow-grass-wind.webm"

echo ""
echo "=== Summary ==="
echo ""
echo "Images:"
ls -lh "$IMAGES_DIR"/*.webp 2>/dev/null | awk '{printf "%s  %s\n", $5, $9}' | \
  grep -E "botanical-|texture-|meadow-tall-|pollinator-(bee-aster|skipper)"
echo ""
echo "Videos:"
ls -lh "$VIDEO_DIR"/ 2>/dev/null | awk '{printf "%s  %s\n", $5, $9}'
