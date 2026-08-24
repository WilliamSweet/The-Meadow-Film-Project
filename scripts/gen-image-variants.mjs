#!/usr/bin/env node
/**
 * Build width variants for every photo in public/images.
 *
 * Why this exists: Astro only optimizes images that live in src/. Anything in
 * public/ is copied through byte-for-byte, which is how this site ended up
 * sending a 2400px-wide hero to a 390px phone. Rather than move every image
 * into src/ and rewrite every component, this generates the variants at build
 * time and the components reference them through srcsetFor() in src/lib/images.ts.
 *
 * Output: public/images/_r/<name>-<width>.webp
 * Run: npm run images   (also wired as a prebuild step)
 *
 * Idempotent — an existing variant newer than its source is left alone, so
 * repeat builds cost nothing.
 */
import sharp from 'sharp';
import fs from 'node:fs';
import path from 'node:path';

const SRC_DIR = 'public/images';
const OUT_DIR = 'public/images/_r';
const WIDTHS = [480, 768, 1024, 1440, 1920];
const QUALITY = 74;

// Small images gain nothing from variants — logos, portraits already under
// this width are served as-is.
const MIN_SOURCE_WIDTH = 700;

const EXT = new Set(['.webp', '.jpg', '.jpeg', '.png']);

// public/images holds a lot of shots that no component references. Building
// variants for those would triple the deploy for files nobody ever requests,
// so the source list is whatever src/ and public/js actually point at.
function referencedImages() {
  const found = new Set();
  const scan = (dir) => {
    for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
      const p = path.join(dir, e.name);
      if (e.isDirectory()) {
        scan(p);
      } else if (/\.(astro|ts|js|mjs|md)$/.test(e.name)) {
        const text = fs.readFileSync(p, 'utf8');
        for (const m of text.matchAll(/\/images\/[A-Za-z0-9._/-]+/g)) {
          found.add(m[0].replace(/^\/images\//, ''));
        }
      }
    }
  };
  scan('src');
  if (fs.existsSync('public/js')) scan('public/js');
  return found;
}

function walk(dir) {
  return fs.readdirSync(dir, { withFileTypes: true }).flatMap((e) => {
    const p = path.join(dir, e.name);
    if (e.isDirectory()) return e.name === '_r' ? [] : walk(p);
    return EXT.has(path.extname(e.name).toLowerCase()) ? [p] : [];
  });
}

// A variant name has to survive nested folders (shoot-2026-08-05/foo.webp),
// so the relative path is flattened with a dash.
export function variantBase(relPath) {
  return relPath.replace(/\.[^.]+$/, '').replace(/\//g, '-');
}

let made = 0;
let skipped = 0;
let bytesOut = 0;

fs.mkdirSync(OUT_DIR, { recursive: true });

const referenced = referencedImages();

// Intrinsic dimensions for every referenced image, so components can emit
// width/height attributes. This is not cosmetic: an <img> whose CSS leaves one
// axis on `auto` has zero area until it loads, and a zero-area element never
// intersects the viewport, so a lazy image in that state never loads at all.
// Known dimensions give the browser an aspect ratio up front and break the
// deadlock — and stop the page jumping as images arrive.
const manifest = {};

for (const file of walk(SRC_DIR)) {
  const rel = path.relative(SRC_DIR, file);
  if (!referenced.has(rel)) continue;
  const meta = await sharp(file).metadata();
  if (meta.width && meta.height) {
    manifest[`/images/${rel}`] = { width: meta.width, height: meta.height };
  }
  if (!meta.width || meta.width < MIN_SOURCE_WIDTH) continue;

  const base = variantBase(rel);
  const srcMtime = fs.statSync(file).mtimeMs;

  for (const w of WIDTHS) {
    if (w > meta.width) continue;
    const out = path.join(OUT_DIR, `${base}-${w}.webp`);
    if (fs.existsSync(out) && fs.statSync(out).mtimeMs > srcMtime) {
      skipped++;
      bytesOut += fs.statSync(out).size;
      continue;
    }
    const buf = await sharp(file)
      .resize({ width: w, withoutEnlargement: true })
      .webp({ quality: QUALITY })
      .toBuffer();
    fs.writeFileSync(out, buf);
    made++;
    bytesOut += buf.length;
  }
}

fs.writeFileSync('src/lib/image-manifest.json', JSON.stringify(manifest, null, 2) + '\n');

console.log(
  `images: ${made} variant(s) written, ${skipped} already current, ` +
    `${(bytesOut / 1024 / 1024).toFixed(1)} MB total in ${OUT_DIR}; ` +
    `${Object.keys(manifest).length} dimensions in src/lib/image-manifest.json`
);
