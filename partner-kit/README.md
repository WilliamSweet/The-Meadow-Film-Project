# Founding Partner Kit

The share engine for coalition growth. Build-once assets you send each organization
after they register and pass review. Designed so a partner can display the badge and
post about the film with zero effort on their end — because sharing only happens when
it's easy and makes *them* look good.

## Contents

| File | What it is | Who it's for |
|---|---|---|
| `founding-partner-badge.svg` | The status badge, vector | Partner's website / print |
| `founding-partner-badge.png` | The badge, 880×880 raster | Partner's social / email |
| `founding-partner-onepager.md` | The offer + the ask | Send when courting / confirming a partner |
| `share-sheet.md` | Badge + ready captions + link | Send at launch so they post once |

## The onboarding flow (per new partner)

1. Org registers via the Tally founding-partner form → lands in your dashboard.
2. You approve (the light bottleneck that keeps "Founding Partner" meaningful).
3. Add them to `src/data/partners.ts` → `wallPartners` (logo in `public/images/partners/`).
4. Email them the badge + one-pager.
5. At launch, email the share-sheet.

## To regenerate the badge PNG from the SVG

No SVG converter is installed locally. Fastest path: open the SVG in a browser and
export, or install one (`brew install librsvg` → `rsvg-convert -w 880 -h 880 badge.svg -o badge.png`).

## The psychology (why this works)

- **Credit in the film** = scarcity + identity — the one thing they can't get elsewhere.
- **Badge + backlink** = a status object they'll display (and it markets the film for free).
- **Listed beside Tallamy / HNP** = borrowed authority + social proof.
- **Ready-made share kit** = removes all friction — the only way an org climbs from
  "partner" to "advocate."
- **July 13 deadline + review** = the bottleneck that makes membership worth displaying.
