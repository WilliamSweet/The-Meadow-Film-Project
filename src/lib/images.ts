/**
 * srcset helper for the images that live in public/images.
 *
 * Astro cannot optimize public/ images, so scripts/gen-image-variants.mjs
 * pre-renders width variants into public/images/_r/ and this returns the
 * matching srcset. Runs at build time only (static site), so touching the
 * filesystem here is free and nothing ships to the browser.
 *
 * Usage in a component:
 *   const hero = responsive('/images/hero-meadow.webp');
 *   <img src={hero.src} srcset={hero.srcset} sizes="100vw" ... />
 *
 * If no variants exist for a path, srcset comes back undefined and the <img>
 * falls back to the original file — nothing breaks.
 */
import fs from 'node:fs';
import path from 'node:path';
import manifest from './image-manifest.json';

const VARIANT_DIR = 'public/images/_r';
const WIDTHS = [480, 768, 1024, 1440, 1920];

const dimensions = manifest as Record<string, { width: number; height: number }>;

export interface Responsive {
  src: string;
  srcset: string | undefined;
  /**
   * Intrinsic size, for the width/height attributes. Always set these on a
   * lazy image whose CSS leaves one axis on `auto`: without them the element
   * has zero area until it loads, a zero-area element never intersects the
   * viewport, and the browser therefore never loads it. That deadlock is what
   * blanked the coalition logos and the botanical illustrations.
   */
  width: number | undefined;
  height: number | undefined;
}

function variantBase(publicPath: string): string {
  return publicPath
    .replace(/^\/images\//, '')
    .replace(/\.[^.]+$/, '')
    .replace(/\//g, '-');
}

export function responsive(publicPath: string): Responsive {
  const base = variantBase(publicPath);
  const parts: string[] = [];

  for (const w of WIDTHS) {
    const file = path.join(VARIANT_DIR, `${base}-${w}.webp`);
    if (fs.existsSync(file)) parts.push(`/images/_r/${base}-${w}.webp ${w}w`);
  }

  const dim = dimensions[publicPath];

  return {
    src: publicPath,
    srcset: parts.length ? parts.join(', ') : undefined,
    width: dim?.width,
    height: dim?.height,
  };
}
