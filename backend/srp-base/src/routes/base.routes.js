import { listCharacters, createCharacter, selectCharacter, deleteCharacter } from '../repositories/baseRepository.js';
import { idempotency, saveIdempotency } from '../middleware/idempotency.js';
import { assertValid } from '../middleware/validate.js';

export async function handleBaseRoutes(req, res, url) {
  const parts = url.pathname.split('/').filter(Boolean); // ['v1','accounts','123',...] 
  if (parts[0] !== 'v1' || parts[1] !== 'accounts') return false;
  const accountId = Number(parts[2]);
  if (!accountId) {
    throw Object.assign(new Error('invalid_account'), { status: 400 });
  }
  if (parts.length === 4 && parts[3] === 'characters' && req.method === 'GET') {
    const chars = await listCharacters(accountId);
    const body = JSON.stringify(chars);
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(body);
    return true;
  }
  if (parts.length === 4 && parts[3] === 'characters' && req.method === 'POST') {
    if (!idempotency(req, res)) return true;
    assertValid({ firstName: { type: 'string', required: true }, lastName: { type: 'string', required: true } }, req.body || {});
    const character = await createCharacter(accountId, req.body);
    const body = JSON.stringify(character);
    res.writeHead(201, { 'Content-Type': 'application/json' });
    res.end(body);
    saveIdempotency(req, res, body);
    return true;
  }
  if (parts.length === 6 && parts[3] === 'characters' && parts[5] === 'select' && req.method === 'POST') {
    const characterId = Number(parts[4]);
    const character = await selectCharacter(accountId, characterId);
    if (!character) {
      throw Object.assign(new Error('not_found'), { status: 404 });
    }
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ ok: true }));
    return true;
  }
  if (parts.length === 5 && parts[3] === 'characters' && req.method === 'DELETE') {
    const characterId = Number(parts[4]);
    const deleted = await deleteCharacter(accountId, characterId);
    res.writeHead(deleted ? 200 : 404, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ ok: deleted }));
    return true;
  }
  return false;
}
