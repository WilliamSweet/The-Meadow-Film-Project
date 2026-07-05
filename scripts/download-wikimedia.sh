#!/bin/bash
# Download remaining Wikimedia Commons images via thumbnail CDN (bypasses rate limits)
# Uses 1920px-wide thumbnails. Converts to WebP quality 75.
# Skips files that already exist.

IMAGES_DIR="/Users/williamsweet/Desktop/LTM folder/LTM-Operations/rooted-film/public/images"
TMP_DIR="/tmp/rooted-downloads"
mkdir -p "$TMP_DIR"

UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36"

download_and_convert() {
  local url="$1"
  local filename="$2"
  local out="$IMAGES_DIR/$filename"

  if [ -f "$out" ]; then
    echo "SKIP (exists): $filename"
    return 0
  fi

  local ext="${url##*.}"
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

try:
    img = Image.open(src)
    if img.mode in ("RGBA", "P", "L"):
        img = img.convert("RGB")
    # Keep max 1920px wide for these supplement images
    if img.width > 1920:
        ratio = 1920 / img.width
        img = img.resize((1920, int(img.height * ratio)), Image.LANCZOS)
    img.save(dst, "WEBP", quality=75, method=6)
    size_kb = os.path.getsize(dst) // 1024
    print(f"  Saved: {os.path.basename(dst)} ({img.width}x{img.height}, {size_kb} KB)")
except Exception as e:
    print(f"  Convert error: {e}")
    sys.exit(1)
PYEOF

  rm -f "$tmp"
  sleep 8
}

echo "=== Downloading Wikimedia assets via thumbnail CDN ==="
echo ""

# Thumbnail URL format: /commons/thumb/{a}/{ab}/{filename}/{W}px-{filename}
# W=1920 for landscape images, W=1080 for portrait/square

download_and_convert \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/A_common_scene_down_a_hill_country_highway._%2824817546050%29.jpg/1920px-A_common_scene_down_a_hill_country_highway._%2824817546050%29.jpg" \
  "meadow-hill-country-highway.webp"

download_and_convert \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/2/26/Norfolk_Botanical_Garden_Meadow_NBG_LR.jpg/1920px-Norfolk_Botanical_Garden_Meadow_NBG_LR.jpg" \
  "meadow-botanical-garden.webp"

download_and_convert \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Black-eyed_Susan_flowers_in_a_meadow_%28Unsplash%29.jpg/1920px-Black-eyed_Susan_flowers_in_a_meadow_%28Unsplash%29.jpg" \
  "native-blackeyed-susan-meadow.webp"

download_and_convert \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/Rudbeckia_Black-Eyed_Susan_at_Fresh_Meadows_Wildlife_Sanctuary%2C_Cheshire%2C_Connecticut_%2853854759000%29.jpg/1080px-Rudbeckia_Black-Eyed_Susan_at_Fresh_Meadows_Wildlife_Sanctuary%2C_Cheshire%2C_Connecticut_%2853854759000%29.jpg" \
  "native-blackeyed-susan-connecticut.webp"

download_and_convert \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/Common_Milkweed_%28Asclepias_syriaca%29_-_London%2C_Ontario_2015-07-09.jpg/1920px-Common_Milkweed_%28Asclepias_syriaca%29_-_London%2C_Ontario_2015-07-09.jpg" \
  "native-milkweed-common.webp"

download_and_convert \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/0/06/Goldenrod_gradient_%2854778516633%29.jpg/1920px-Goldenrod_gradient_%2854778516633%29.jpg" \
  "native-goldenrod-gradient.webp"

download_and_convert \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/Canada_goldenrod_%2854750246021%29.jpg/1920px-Canada_goldenrod_%2854750246021%29.jpg" \
  "native-goldenrod-canada.webp"

download_and_convert \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/0/02/Regal_fritillary_%28Argynnis_idalia%29_nectaring_on_butterly_milkweed_%2854311189433%29.jpg/1920px-Regal_fritillary_%28Argynnis_idalia%29_nectaring_on_butterly_milkweed_%2854311189433%29.jpg" \
  "pollinator-fritillary-milkweed.webp"

download_and_convert \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/b/bc/Bee_pollinating_showy_milkweed_%2841006814580%29.jpg/1920px-Bee_pollinating_showy_milkweed_%2841006814580%29.jpg" \
  "pollinator-bee-milkweed.webp"

download_and_convert \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/Bumble_bee_on_blanket_flower_%2854015967359%29.jpg/1920px-Bumble_bee_on_blanket_flower_%2854015967359%29.jpg" \
  "pollinator-bumblebee-blanketflower.webp"

download_and_convert \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/Orange-belted_bumble_bee_on_stiff_goldenrod_%2854795861338%29.jpg/1920px-Orange-belted_bumble_bee_on_stiff_goldenrod_%2854795861338%29.jpg" \
  "pollinator-bumblebee-goldenrod.webp"

download_and_convert \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/American_lady_on_purple_coneflower_%2874770%29.jpg/1920px-American_lady_on_purple_coneflower_%2874770%29.jpg" \
  "pollinator-butterfly-coneflower-1.webp"

download_and_convert \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c6/Red_admiral_butterfly_on_purple_coneflower_in_New_York_%2811147%29.jpg/1920px-Red_admiral_butterfly_on_purple_coneflower_in_New_York_%2811147%29.jpg" \
  "pollinator-butterfly-coneflower-2.webp"

download_and_convert \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b1/Wildflowers_at_the_North_Fork_Crooked_Wild_and_Scenic_River_%2828146833852%29.jpg/1080px-Wildflowers_at_the_North_Fork_Crooked_Wild_and_Scenic_River_%2828146833852%29.jpg" \
  "meadow-wildflowers-northfork.webp"

echo ""
echo "=== Result ==="
echo "Files in public/images/:"
ls -lh "$IMAGES_DIR"/*.webp | awk '{print $5, $9}' | grep -v "david-kaye\|doug-tallamy\|fullbleed\|hero-meadow\|litchfield\|mel-finn\|nick-lyon\|ryan-dressler\|sara-weaner\|sleepy-cat\|victor-demasi\|william-sweet\|wylie"
