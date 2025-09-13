const fs = require('fs');
const path = require('path');

const BATCH_SIZE = parseInt(process.argv[2], 10) || 200;
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

function toLuaFunc(name) {
  const hasUnderscore = name.startsWith('_');
  const parts = name.replace(/^_/, '').toLowerCase().split('_');
  const pascal = parts.map(p => p.charAt(0).toUpperCase() + p.slice(1)).join('');
  return (hasUnderscore ? '_' : '') + pascal;
}

function sanitizeCodeBlocks(blocks = []) {
  const banned = [/RegisterCommand/i, /print\s*\(/i, /console\.log\s*\(/i];
  const cleaned = [];
  for (const block of blocks) {
    const lines = block
      .split('\n')
      .filter(line => !banned.some(re => re.test(line)))
      .join('\n')
      .trim();
    if (lines) cleaned.push(lines);
  }
  return cleaned;
}

function generateExample(native) {
  const proto = native.codeBlocks[0] || '';
  const match = proto.match(/\(([^)]*)\)/);
  const params = match && match[1].trim()
    ? match[1].split(',').map(p => p.trim().split(/\s+/))
    : [];
  const defaults = {
    float: '0.0',
    int: '0',
    Hash: "GetHashKey('prop')",
    BOOL: 'false',
    bool: 'false',
    char: "''",
    'char*': "''",
    'const char*': "''"
  };
  const vars = new Set();
  const args = params.map(p => {
    const type = p.length > 1 ? p.slice(0, -1).join(' ') : p[0];
    const name = p[p.length - 1] || '';
    if (name.toLowerCase().includes('hash')) {
      return "GetHashKey('prop')";
    }
    switch (type) {
      case 'Ped':
        vars.add('local ped = PlayerPedId()');
        return 'ped';
      case 'Vehicle':
        vars.add('local ped = PlayerPedId()');
        vars.add('local vehicle = GetVehiclePedIsIn(ped, false)');
        return 'vehicle';
      case 'Entity':
        vars.add('local entity = PlayerPedId()');
        return 'entity';
      case 'Player':
        vars.add('local player = PlayerId()');
        return 'player';
      default:
        return defaults[type] || '0';
    }
  });
  return [
    ...Array.from(vars),
    `-- Example usage for ${native.title}`,
    `${toLuaFunc(native.title)}(${args.join(', ')})`
  ].join('\n');
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
  let category = (native.breadcrumbs[1] || 'misc').toLowerCase().replace(/\s+/g, '_');
  category = category.replace(/_?api$/, '');
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
    native.codeBlocks = sanitizeCodeBlocks(native.codeBlocks);
    if (native.codeBlocks.length < 2) {
      native.codeBlocks.push(generateExample(native));
    }
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
