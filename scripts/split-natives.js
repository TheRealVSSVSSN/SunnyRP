const fs = require('fs');
const path = require('path');

const BATCH_SIZE = 100;
const SOURCE_FILE = path.join(__dirname, '..', 'natives.json');
const OUTPUT_ROOT = path.join(__dirname, '..', 'natives');
const LEDGER_FILE = path.join(OUTPUT_ROOT, 'ledger.json');

function loadJson(file) {
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

function saveJson(file, data) {
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, JSON.stringify(data, null, 2));
}

function sanitizeName(name) {
  return name.toLowerCase().replace(/[^a-z0-9]+/g, '_');
}

function collect(entries, trail = [], out = []) {
  for (const entry of entries) {
    const crumbs = trail.concat(entry.title);
    if (entry.content || entry.codeBlocks) {
      out.push({
        title: entry.title,
        breadcrumbs: entry.breadcrumbs || crumbs,
        content: entry.content || '',
        codeBlocks: entry.codeBlocks || [],
        urls: entry.urls || [],
        tags: entry.tags || []
      });
    }
    if (Array.isArray(entry.children) && entry.children.length) {
      collect(entry.children, crumbs, out);
    }
  }
  return out;
}

function classify(native) {
  const tags = native.tags.map(t => t.toLowerCase());
  let scope = 'shared';
  if (tags.includes('server') && !tags.includes('client')) scope = 'server';
  else if (tags.includes('client') && !tags.includes('server')) scope = 'client';
  const category = (native.breadcrumbs[1] || 'misc').toLowerCase().replace(/\s+/g, '_');
  return { scope, category };
}

function main() {
  const data = loadJson(SOURCE_FILE);
  const allNatives = collect(data);

  let ledger = { processed: [] };
  if (fs.existsSync(LEDGER_FILE)) {
    ledger = loadJson(LEDGER_FILE);
  }

  const start = ledger.processed.length;
  const slice = allNatives.slice(start, start + BATCH_SIZE);
  if (!slice.length) {
    console.log('No new natives to process.');
    return;
  }

  for (const native of slice) {
    const { scope, category } = classify(native);
    const dir = path.join(OUTPUT_ROOT, scope, category);
    fs.mkdirSync(dir, { recursive: true });
    const file = path.join(dir, `${sanitizeName(native.title)}.json`);
    saveJson(file, native);
    ledger.processed.push(native.title);
  }

  saveJson(LEDGER_FILE, ledger);
  console.log(`Processed ${slice.length} natives.`);
}

main();
