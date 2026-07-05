#!/usr/bin/env python3
"""
Download and convert free legal images for Rooted film website.
All images are public domain or CC0/CC BY/CC BY-SA from Wikimedia Commons.
Output: WebP at quality 85, max 2400px wide (matches existing site images).
"""

import os
import time
import urllib.request
import urllib.error
from pathlib import Path
from PIL import Image
import io

IMAGES_DIR = Path(__file__).parent.parent / "public" / "images"
IMAGES_DIR.mkdir(parents=True, exist_ok=True)

# Max width for output WebP (matches existing hero-meadow.webp at 2400px)
MAX_WIDTH = 2400
WEBP_QUALITY = 85

ASSETS = [
    # ── Meadow Landscapes ─────────────────────────────────────────────────────
    {
        "url": "https://upload.wikimedia.org/wikipedia/commons/9/90/Blooming_Mountain_Meadow_%2852582038680%29.jpg",
        "filename": "meadow-mountain-wildflowers.webp",
        "license": "Public domain",
        "credit": "USFWS Mountain Prairie / Jenn Majkowski",
        "source": "https://commons.wikimedia.org/wiki/File:Blooming_Mountain_Meadow_(52582038680).jpg",
        "description": "High-elevation mountain meadow with goldenrod, fireweed, wildflowers — Red Rock Lakes NWR, Montana",
    },
    {
        "url": "https://upload.wikimedia.org/wikipedia/commons/d/d9/Flowers_fill_the_landscape_during_Hill_Country_Springs._%2824745528149%29.jpg",
        "filename": "meadow-hill-country-spring.webp",
        "license": "Public domain",
        "credit": "USDA NRCS Texas",
        "source": "https://commons.wikimedia.org/wiki/File:Flowers_fill_the_landscape_during_Hill_Country_Springs._(24745528149).jpg",
        "description": "Texas Hill Country spring wildflowers blanketing landscape",
    },
    {
        "url": "https://upload.wikimedia.org/wikipedia/commons/8/87/A_common_scene_down_a_hill_country_highway._%2824817546050%29.jpg",
        "filename": "meadow-hill-country-highway.webp",
        "license": "Public domain",
        "credit": "USDA NRCS Texas",
        "source": "https://commons.wikimedia.org/wiki/File:A_common_scene_down_a_hill_country_highway._(24817546050).jpg",
        "description": "Wildflowers along Texas Hill Country highway — wide landscape",
    },
    {
        "url": "https://upload.wikimedia.org/wikipedia/commons/c/ca/Early_Autumn_%282%29_%2821926610576%29.jpg",
        "filename": "meadow-goldenrod-autumn-pa.webp",
        "license": "CC0",
        "credit": "Nicholas A. Tonelli",
        "source": "https://commons.wikimedia.org/wiki/File:Early_Autumn_(2)_(21926610576).jpg",
        "description": "Goldenrod, grass, eastern red-cedars — Blue Mountain, Monroe County PA",
    },
    {
        "url": "https://upload.wikimedia.org/wikipedia/commons/2/26/Norfolk_Botanical_Garden_Meadow_NBG_LR.jpg",
        "filename": "meadow-botanical-garden.webp",
        "license": "CC BY-SA 4.0",
        "credit": "PumpkinSky",
        "attribution": "Photo: PumpkinSky / CC BY-SA 4.0",
        "source": "https://commons.wikimedia.org/wiki/File:Norfolk_Botanical_Garden_Meadow_NBG_LR.jpg",
        "description": "Native meadow planting at Norfolk Botanical Garden — 6000×4000",
    },

    # ── Native Wildflowers ────────────────────────────────────────────────────
    {
        "url": "https://upload.wikimedia.org/wikipedia/commons/5/5c/Black-eyed_Susan_flowers_in_a_meadow_%28Unsplash%29.jpg",
        "filename": "native-blackeyed-susan-meadow.webp",
        "license": "CC0",
        "credit": "Rick Hinchcliff",
        "source": "https://commons.wikimedia.org/wiki/File:Black-eyed_Susan_flowers_in_a_meadow_(Unsplash).jpg",
        "description": "Black-eyed Susan (Rudbeckia) flowers in a meadow — CC0",
    },
    {
        "url": "https://upload.wikimedia.org/wikipedia/commons/3/30/Rudbeckia_Black-Eyed_Susan_at_Fresh_Meadows_Wildlife_Sanctuary%2C_Cheshire%2C_Connecticut_%2853854759000%29.jpg",
        "filename": "native-blackeyed-susan-connecticut.webp",
        "license": "CC BY-SA 2.0",
        "credit": "Ethan Long",
        "attribution": "Photo: Ethan Long / CC BY-SA 2.0",
        "source": "https://commons.wikimedia.org/wiki/File:Rudbeckia_Black-Eyed_Susan_at_Fresh_Meadows_Wildlife_Sanctuary,_Cheshire,_Connecticut_(53854759000).jpg",
        "description": "Black-eyed Susan at Fresh Meadows Wildlife Sanctuary, Cheshire CT — site-specific",
    },
    {
        "url": "https://upload.wikimedia.org/wikipedia/commons/1/10/Common_Milkweed_%28Asclepias_syriaca%29_-_London%2C_Ontario_2015-07-09.jpg",
        "filename": "native-milkweed-common.webp",
        "license": "CC BY-SA 4.0",
        "credit": "Ryan Hodnett",
        "attribution": "Photo: Ryan Hodnett / CC BY-SA 4.0",
        "source": "https://commons.wikimedia.org/wiki/File:Common_Milkweed_(Asclepias_syriaca)_-_London,_Ontario_2015-07-09.jpg",
        "description": "Common milkweed (Asclepias syriaca) in bloom — 6000×3375",
    },
    {
        "url": "https://upload.wikimedia.org/wikipedia/commons/0/06/Goldenrod_gradient_%2854778516633%29.jpg",
        "filename": "native-goldenrod-gradient.webp",
        "license": "Public domain",
        "credit": "U.S. Fish and Wildlife Service — Midwest Region",
        "source": "https://commons.wikimedia.org/wiki/File:Goldenrod_gradient_(54778516633).jpg",
        "description": "Goldenrod gradient landscape — cinematic texture, 9400×6267 original",
    },
    {
        "url": "https://upload.wikimedia.org/wikipedia/commons/1/10/Canada_goldenrod_%2854750246021%29.jpg",
        "filename": "native-goldenrod-canada.webp",
        "license": "Public domain",
        "credit": "U.S. Fish and Wildlife Service — Midwest Region",
        "source": "https://commons.wikimedia.org/wiki/File:Canada_goldenrod_(54750246021).jpg",
        "description": "Canada goldenrod field — 6242×4161 original",
    },
    {
        "url": "https://npgallery.nps.gov/GetAsset/A42A59F8-155D-4519-3E54D5CA5A5D8A72/proxyhires.jpg",
        "filename": "native-milkweed-showy-nps.webp",
        "license": "Public domain",
        "credit": "National Park Service / Wind Cave National Park",
        "source": "https://npgallery.nps.gov/AssetDetail/a42a59f8-155d-4519-3e54-d5ca5a5d8a72",
        "description": "Showy milkweed (Asclepias speciosa) in bloom — Wind Cave NP",
    },

    # ── Pollinators ──────────────────────────────────────────────────────────
    {
        "url": "https://upload.wikimedia.org/wikipedia/commons/0/02/Regal_fritillary_%28Argynnis_idalia%29_nectaring_on_butterly_milkweed_%2854311189433%29.jpg",
        "filename": "pollinator-fritillary-milkweed.webp",
        "license": "Public domain",
        "credit": "USFWS Mountain Prairie / Tom Koerner",
        "source": "https://commons.wikimedia.org/wiki/File:Regal_fritillary_(Argynnis_idalia)_nectaring_on_butterly_milkweed_(54311189433).jpg",
        "description": "Regal fritillary butterfly nectaring on butterfly milkweed — 4619×3442",
    },
    {
        "url": "https://upload.wikimedia.org/wikipedia/commons/b/bc/Bee_pollinating_showy_milkweed_%2841006814580%29.jpg",
        "filename": "pollinator-bee-milkweed.webp",
        "license": "Public domain",
        "credit": "U.S. Fish and Wildlife Service — Midwest Region",
        "source": "https://commons.wikimedia.org/wiki/File:Bee_pollinating_showy_milkweed_(41006814580).jpg",
        "description": "Bee pollinating showy milkweed — 4928×3264",
    },
    {
        "url": "https://upload.wikimedia.org/wikipedia/commons/b/b4/Bumble_bee_on_blanket_flower_%2854015967359%29.jpg",
        "filename": "pollinator-bumblebee-blanketflower.webp",
        "license": "Public domain",
        "credit": "U.S. Fish and Wildlife Service — Midwest Region",
        "source": "https://commons.wikimedia.org/wiki/File:Bumble_bee_on_blanket_flower_(54015967359).jpg",
        "description": "Bumble bee on blanket flower (Gaillardia) at Big Stone NWR — 5472×3648",
    },
    {
        "url": "https://upload.wikimedia.org/wikipedia/commons/4/45/Orange-belted_bumble_bee_on_stiff_goldenrod_%2854795861338%29.jpg",
        "filename": "pollinator-bumblebee-goldenrod.webp",
        "license": "Public domain",
        "credit": "U.S. Fish and Wildlife Service — Midwest Region",
        "source": "https://commons.wikimedia.org/wiki/File:Orange-belted_bumble_bee_on_stiff_goldenrod_(54795861338).jpg",
        "description": "Orange-belted bumble bee on stiff goldenrod — 4000×2666",
    },
    {
        "url": "https://upload.wikimedia.org/wikipedia/commons/2/29/American_lady_on_purple_coneflower_%2874770%29.jpg",
        "filename": "pollinator-butterfly-coneflower-1.webp",
        "license": "CC BY-SA 4.0",
        "credit": "Rhododendrites",
        "attribution": "Photo: Rhododendrites / CC BY-SA 4.0",
        "source": "https://commons.wikimedia.org/wiki/File:American_lady_on_purple_coneflower_(74770).jpg",
        "description": "American lady butterfly on purple coneflower (echinacea) — 4366×3233",
    },
    {
        "url": "https://upload.wikimedia.org/wikipedia/commons/c/c6/Red_admiral_butterfly_on_purple_coneflower_in_New_York_%2811147%29.jpg",
        "filename": "pollinator-butterfly-coneflower-2.webp",
        "license": "CC BY-SA 4.0",
        "credit": "Rhododendrites",
        "attribution": "Photo: Rhododendrites / CC BY-SA 4.0",
        "source": "https://commons.wikimedia.org/wiki/File:Red_admiral_butterfly_on_purple_coneflower_in_New_York_(11147).jpg",
        "description": "Red admiral butterfly on purple coneflower, New York — 4737×3588",
    },
    {
        "url": "https://upload.wikimedia.org/wikipedia/commons/b/b1/Wildflowers_at_the_North_Fork_Crooked_Wild_and_Scenic_River_%2828146833852%29.jpg",
        "filename": "meadow-wildflowers-northfork.webp",
        "license": "Public domain",
        "credit": "Bureau of Land Management Oregon / Bob Wick",
        "source": "https://commons.wikimedia.org/wiki/File:Wildflowers_at_the_North_Fork_Crooked_Wild_and_Scenic_River_(28146833852).jpg",
        "description": "Native wildflowers at North Fork Crooked Wild and Scenic River, Oregon — portrait format",
    },
]


def download_and_convert(asset: dict) -> bool:
    out_path = IMAGES_DIR / asset["filename"]
    if out_path.exists():
        print(f"  SKIP (exists): {asset['filename']}")
        return True

    print(f"  Downloading: {asset['filename']} ...")
    for attempt in range(3):
        try:
            req = urllib.request.Request(
                asset["url"],
                headers={"User-Agent": "Mozilla/5.0 (compatible; RootedFilmBot/1.0)"},
            )
            with urllib.request.urlopen(req, timeout=60) as response:
                data = response.read()
            break
        except urllib.error.HTTPError as e:
            if e.code == 429:
                wait = 8 * (attempt + 1)
                print(f"  Rate limited — waiting {wait}s (attempt {attempt+1}/3)...")
                time.sleep(wait)
                if attempt == 2:
                    print(f"  FAILED after 3 attempts: {asset['url']}")
                    return False
            else:
                print(f"  ERROR {e.code}: {asset['url']}")
                return False
        except Exception as e:
            print(f"  ERROR: {e}")
            return False

    try:
        img = Image.open(io.BytesIO(data))
        # Convert RGBA → RGB (WebP supports transparency but we want consistent output)
        if img.mode in ("RGBA", "P"):
            img = img.convert("RGB")

        # Resize if wider than MAX_WIDTH
        if img.width > MAX_WIDTH:
            ratio = MAX_WIDTH / img.width
            new_h = int(img.height * ratio)
            img = img.resize((MAX_WIDTH, new_h), Image.LANCZOS)
            print(f"    Resized to {img.width}×{img.height}")
        else:
            print(f"    Kept at {img.width}×{img.height}")

        img.save(out_path, "WEBP", quality=WEBP_QUALITY, method=6)
        size_kb = out_path.stat().st_size // 1024
        print(f"    Saved: {asset['filename']} ({size_kb} KB)")
        return True
    except Exception as e:
        print(f"  CONVERT ERROR: {e}")
        return False


def write_credits(results: list[tuple[dict, bool]]) -> None:
    credits_path = IMAGES_DIR / "CREDITS.md"
    lines = [
        "# Asset Credits — Rooted Film Website",
        "",
        "All images are free for use on this website. Licensing details and attribution lines are below.",
        "Licenses: CC0 and Public Domain require no attribution. CC BY-SA requires credit when displayed.",
        "",
        "---",
        "",
    ]

    groups = {
        "Public domain": [],
        "CC0": [],
        "CC BY-SA 4.0": [],
        "CC BY-SA 3.0": [],
        "CC BY-SA 2.0": [],
        "CC BY 2.0": [],
    }

    for asset, ok in results:
        if ok:
            lic = asset["license"]
            if lic not in groups:
                groups[lic] = []
            groups[lic].append(asset)

    for lic, assets in groups.items():
        if not assets:
            continue
        lines.append(f"## {lic}")
        lines.append("")
        if lic in ("CC0", "Public domain"):
            lines.append("No attribution required. Free for any use.")
        else:
            lines.append("**Attribution required** when image is displayed publicly.")
        lines.append("")
        for a in assets:
            lines.append(f"### `{a['filename']}`")
            lines.append(f"- **Description**: {a['description']}")
            lines.append(f"- **Credit**: {a['credit']}")
            lines.append(f"- **Source**: {a['source']}")
            if "attribution" in a:
                lines.append(f"- **Attribution line** (copy-paste): _{a['attribution']}_")
            lines.append("")
        lines.append("---")
        lines.append("")

    lines.append("## License Reference")
    lines.append("")
    lines.append("- **Public domain (US Gov)**: Federal government works have no copyright — 17 U.S.C. § 101")
    lines.append("- **CC0**: [creativecommons.org/publicdomain/zero/1.0/](https://creativecommons.org/publicdomain/zero/1.0/)")
    lines.append("- **CC BY-SA 4.0**: [creativecommons.org/licenses/by-sa/4.0/](https://creativecommons.org/licenses/by-sa/4.0/)")
    lines.append("- **CC BY-SA 2.0**: [creativecommons.org/licenses/by-sa/2.0/](https://creativecommons.org/licenses/by-sa/2.0/)")
    lines.append("")
    lines.append("*For CC BY-SA images: displaying on a website does not create a derivative work.*")
    lines.append("*Attribution can appear in a site footer, credits page, or inline caption.*")

    credits_path.write_text("\n".join(lines))
    print(f"\nCredits written to: {credits_path}")


if __name__ == "__main__":
    print(f"Output directory: {IMAGES_DIR}")
    print(f"Downloading {len(ASSETS)} images...\n")

    results = []
    for i, asset in enumerate(ASSETS):
        ok = download_and_convert(asset)
        results.append((asset, ok))
        # Pause between downloads to avoid rate limiting
        if ok and i < len(ASSETS) - 1:
            time.sleep(4)

    succeeded = sum(1 for _, ok in results if ok)
    failed = [(a["filename"], a["url"]) for a, ok in results if not ok]

    print(f"\n{'='*50}")
    print(f"Done: {succeeded}/{len(ASSETS)} images downloaded and converted")

    if failed:
        print(f"\nFailed ({len(failed)}):")
        for name, url in failed:
            print(f"  {name}: {url}")

    write_credits(results)
