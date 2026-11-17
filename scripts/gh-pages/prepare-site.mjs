#!/usr/bin/env node
/**
 * Prepares the adev production build for GitHub Pages.
 *
 * GitHub Pages serves files as is: no rewrites and no custom headers. On Firebase
 * (adev/firebase.json) and Beget (.htaccess) the site relied on both, so this script
 * reproduces them in the files themselves:
 *
 *  - Bazel output is full of symlinks: copy it into a plain directory.
 *  - COOP/COEP headers (required by the in-browser editor, WebContainers need
 *    cross-origin isolation): every app page loads coi-serviceworker.js, which
 *    registers a service worker that adds these headers to responses.
 *  - SPA fallback (`** -> /index.html`): 404.html is a copy of the app shell, so
 *    unknown URLs still boot the app and show its own "not found" page.
 *
 * Usage: node scripts/gh-pages/prepare-site.mjs <bazel-browser-dir> <out-dir>
 *   e.g. node scripts/gh-pages/prepare-site.mjs dist/bin/adev/dist/browser _site
 */

import {chmodSync, copyFileSync, existsSync, mkdirSync, readFileSync, readdirSync, rmSync, statSync, writeFileSync} from 'node:fs';
import {dirname, join, relative} from 'node:path';
import {fileURLToPath} from 'node:url';

const PAGES_SIZE_LIMIT = 1024 ** 3; // GitHub Pages: published site must be under 1 GB.
const SW_FILE = 'coi-serviceworker.js';
const SW_TAG = `<script src="/${SW_FILE}"></script>`;
// Prerendered app pages carry the app's <base href="/">. Raw .html assets
// (example component templates shown in the docs) don't, and must stay untouched.
const APP_PAGE = /<base\s+href=["']?\/["']?/i;

const [src, out] = process.argv.slice(2);
if (!src || !out) {
  fail('usage: prepare-site.mjs <bazel-browser-dir> <out-dir>');
}
if (!existsSync(join(src, 'index.html'))) {
  fail(`${join(src, 'index.html')} not found. Build first: pnpm bazel build //adev:build.production`);
}

rmSync(out, {recursive: true, force: true});
copyDereferenced(src, out);
copyFileSync(join(dirname(fileURLToPath(import.meta.url)), SW_FILE), join(out, SW_FILE));

let pages = 0;
for (const file of walk(out)) {
  if (!file.endsWith('.html')) continue;
  const html = readFileSync(file, 'utf8');
  if (!APP_PAGE.test(html)) continue;
  pages++;
  if (html.includes(SW_TAG)) continue;
  // Must be the first script in <head>: it registers the worker as early as possible
  // and needs document.currentScript, so it stays a classic (non-module) script.
  const patched = html.replace(/<head(\s[^>]*)?>/i, (head) => head + SW_TAG);
  if (patched === html) fail(`no <head> in ${relative(out, file)}`);
  writeFileSync(file, patched);
}
if (pages === 0) fail('no app pages found (no HTML with <base href="/">)');

const shell = existsSync(join(out, 'index.csr.html')) ? 'index.csr.html' : 'index.html';
copyFileSync(join(out, shell), join(out, '404.html'));

let files = 0;
let bytes = 0;
for (const file of walk(out)) {
  files++;
  bytes += statSync(file).size;
}
const mb = (bytes / 1024 ** 2).toFixed(1);
console.log(`prepare-site: ${pages} app pages patched, 404.html <- ${shell}, ${files} files, ${mb} MB in ${out}`);
if (bytes > PAGES_SIZE_LIMIT) fail(`site is ${mb} MB, over the 1 GB GitHub Pages limit`);

// fs.cpSync({dereference: true}) only resolves the top-level path and keeps nested
// symlinks as links, so writing to a copied page would modify Bazel's output.
// statSync follows links, so everything below ends up as real files and directories.
// Bazel outputs are read-only and copyFileSync keeps the mode, so make copies writable.
function copyDereferenced(from, to) {
  mkdirSync(to, {recursive: true});
  for (const name of readdirSync(from)) {
    const source = join(from, name);
    const target = join(to, name);
    if (statSync(source).isDirectory()) {
      copyDereferenced(source, target);
    } else {
      copyFileSync(source, target);
      chmodSync(target, 0o644);
    }
  }
}

function* walk(dir) {
  for (const entry of readdirSync(dir, {withFileTypes: true})) {
    const path = join(dir, entry.name);
    if (entry.isDirectory()) yield* walk(path);
    else if (entry.isFile()) yield path;
  }
}

function fail(message) {
  console.error(`prepare-site: ${message}`);
  process.exit(1);
}
