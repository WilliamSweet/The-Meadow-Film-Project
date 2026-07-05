#!/bin/bash
# Batch 3 — Bokeh/golden light, monarch butterflies, lawn before-state, monarch video

IMAGES_DIR="/Users/williamsweet/Desktop/LTM folder/LTM-Operations/rooted-film/public/images"
VIDEO_DIR="/Users/williamsweet/Desktop/LTM folder/LTM-Operations/rooted-film/public/video"
TMP_DIR="/tmp/rooted-batch3"
mkdir -p "$TMP_DIR" "$VIDEO_DIR"

UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36"

download_image() {
  local url="$1"
  local filename="$2"
  local max_px="${3:-1920}"
  local quality="${4:-75}"
  local referer="${5:-https://commons.wikimedia.org/}"
  local out="$IMAGES_DIR/$filename"

  if [ -f "$out" ]; then
    echo "SKIP (exists): $filename"
    return 0
  fi

  local tmp="$TMP_DIR/$filename.tmp"
  echo "Downloading: $filename ..."

  http_code=$(curl -L -s -o "$tmp" -w "%{http_code}" \
    -A "$UA" \
    -H "Referer: $referer" \
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

download_video() {
  local url="$1"
  local filename="$2"
  local referer="${3:-https://commons.wikimedia.org/}"
  local out="$VIDEO_DIR/$filename"

  if [ -f "$out" ]; then
    echo "SKIP (exists): $filename"
    return 0
  fi

  echo "Downloading video: $filename ..."
  http_code=$(curl -L -s -o "$out" -w "%{http_code}" \
    -A "$UA" \
    -H "Referer: $referer" \
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
echo "=== Batch 3: Bokeh / Golden Light (Unsplash) ==="
echo ""

# Golden hour grass field — Edgar Nunley, Unsplash License
download_image \
  "https://images.unsplash.com/photo-1577156289652-098adbab44fd?fm=jpg&q=90&w=3000&auto=format&fit=crop" \
  "meadow-golden-hour-grass.webp" \
  "1920" "75" \
  "https://unsplash.com/"

# Warm golden bokeh against dark green — LIGHTCAMACT Photography, Unsplash License
download_image \
  "https://images.unsplash.com/photo-1761458514074-a8724daaeb85?fm=jpg&q=90&w=3000&auto=format&fit=crop" \
  "bokeh-golden-green.webp" \
  "1920" "75" \
  "https://unsplash.com/"

# Mowed turf / lawn — Jason Dent, Unsplash License (before-state for GSAP reveal)
download_image \
  "https://images.unsplash.com/photo-1544914379-806667cd9489?fm=jpg&q=90&w=3000&auto=format&fit=crop" \
  "before-lawn-turf.webp" \
  "1920" "75" \
  "https://unsplash.com/"

echo ""
echo "=== Batch 3: Monarch Butterfly (USFWS, Public Domain) ==="
echo ""

# Monarch on butterfly milkweed — USFWS / Courtney Celley, 5000×3333
download_image \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6e/Monarch_butterfly_on_butterfly_milkweed_%2853069280718%29.jpg/1920px-Monarch_butterfly_on_butterfly_milkweed_%2853069280718%29.jpg" \
  "pollinator-monarch-butterfly-milkweed.webp"

# Monarch on milkweed at Lake Andes NWR — USFWS / Laken Ewert, 6960×4640
download_image \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/4/46/Monarch_butterfly_on_milkweed_at_Lake_Andes_National_Wildlife_Refuge_%2853892306605%29.jpg/1920px-Monarch_butterfly_on_milkweed_at_Lake_Andes_National_Wildlife_Refuge_%2853892306605%29.jpg" \
  "pollinator-monarch-lake-andes.webp"

echo ""
echo "=== Batch 3: Monarch Video (USFWS, Public Domain) ==="
echo ""

# Monarch Butterfly on Swamp Milkweed — USFWS Midwest Region, 1920x1080, 3s, CC0
download_video \
  "https://upload.wikimedia.org/wikipedia/commons/0/09/Monarch_Butterfly_on_Swamp_Milkweed_%2829066537375%29.webm" \
  "pollinator-monarch-milkweed.webm"

echo ""
echo "=== Summary ==="
echo ""
for f in meadow-golden-hour-grass bokeh-golden-green before-lawn-turf pollinator-monarch-butterfly-milkweed pollinator-monarch-lake-andes; do
  file="$IMAGES_DIR/${f}.webp"
  [ -f "$file" ] && printf "%6s  %s\n" "$(du -sh "$file" 2>/dev/null | cut -f1)" "${f}.webp"
done
echo ""
ls -lh "$VIDEO_DIR/"*.webm 2>/dev/null | awk '{print $5, $9}'
