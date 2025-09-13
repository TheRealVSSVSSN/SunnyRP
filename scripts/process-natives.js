const fs = require('fs');
const path = require('path');

const nativesPath = path.join(__dirname, '..', 'natives.json');
const ledgerPath = path.join(__dirname, '..', 'natives', 'ledger.json');

const nativesData = JSON.parse(fs.readFileSync(nativesPath, 'utf8'));
const ledger = JSON.parse(fs.readFileSync(ledgerPath, 'utf8'));
const processed = new Set(ledger.processed || []);

// Flatten natives tree to list of leaf nodes
function flatten(nodes, trail = []) {
  const list = [];
  for (const node of nodes) {
    const breadcrumbs = [...trail, node.title];
    if (node.children && node.children.length) {
      list.push(...flatten(node.children, breadcrumbs));
    } else {
      node.breadcrumbs = breadcrumbs; // ensure breadcrumbs
      list.push(node);
    }
  }
  return list;
}

const allNatives = flatten(nativesData);
const unprocessed = allNatives.filter(n => !processed.has(n.title));
const batch = unprocessed.slice(0, 500);

function luaFuncName(title) {
  const parts = title.toLowerCase().split('_');
  const camel = parts.map(p => p.charAt(0).toUpperCase() + p.slice(1)).join('');
  return title.startsWith('_') ? '_' + camel.slice(1) : camel;
}

function parseParams(signature) {
  const m = signature.match(/\((.*)\)/);
  if (!m) return [];
  if (m[1].trim() === '') return [];
  return m[1].split(',').map(p => {
    const [type, name] = p.trim().split(/\s+/);
    return { type: type || '', name: name || '' };
  });
}

function exampleValue(type, ctxLines) {
  const t = type.toLowerCase();
  switch (t) {
    case 'int':
    case 'long':
    case 'hash':
      return '0';
    case 'float':
    case 'double':
      return '0.0';
    case 'bool':
    case 'boolean':
      return 'true';
    case 'char*':
    case 'const char*':
      return "'example'";
    case 'ped':
      if (!ctxLines.includes('local ped = PlayerPedId()')) ctxLines.push('local ped = PlayerPedId()');
      return 'ped';
    case 'player':
      if (!ctxLines.includes('local player = source')) ctxLines.push('local player = source');
      return 'player';
    case 'vehicle':
      if (!ctxLines.includes('local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)')) ctxLines.push('local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)');
      return 'vehicle';
    case 'entity':
      if (!ctxLines.includes('local entity = GetEntityCoords(PlayerPedId())')) ctxLines.push('local entity = GetEntityCoords(PlayerPedId())');
      return 'entity';
    default:
      return '0';
  }
}

for (const native of batch) {
  const tags = native.tags || [];
  let scope = 'shared';
  if (tags.includes('server')) scope = 'server';
  else if (tags.includes('client')) scope = 'client';

  const sub = native.breadcrumbs[1] ? native.breadcrumbs[1].toLowerCase().replace(/[^a-z0-9]/g, '') : 'misc';
  const dir = path.join(__dirname, '..', 'natives', scope, sub);
  fs.mkdirSync(dir, { recursive: true });

  const fileName = native.title.toLowerCase().replace(/[^a-z0-9]/g, '_') + '.json';
  const filePath = path.join(dir, fileName);

  const signature = native.codeBlocks && native.codeBlocks[0] ? native.codeBlocks[0] : '';
  const ctxLines = [];
  const params = parseParams(signature);
  const exampleCall = luaFuncName(native.title) + '(' + params.map(p => exampleValue(p.type, ctxLines)).join(', ') + ')';
  const exampleBlock = (ctxLines.length ? ctxLines.join('\n') + '\n' : '') + `-- Example usage for ${native.title}\n${exampleCall}`;

  const out = {
    title: native.title,
    breadcrumbs: native.breadcrumbs,
    content: native.content || '',
    codeBlocks: signature ? [signature, exampleBlock] : [exampleBlock],
    urls: native.urls || [],
    tags
  };

  fs.writeFileSync(filePath, JSON.stringify(out, null, 2));
  ledger.processed.push(native.title);
}

fs.writeFileSync(ledgerPath, JSON.stringify(ledger, null, 2));
console.log(`Processed ${batch.length} natives`);
