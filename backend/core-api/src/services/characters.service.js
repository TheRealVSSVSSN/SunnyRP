import { countByUser, listByUser, nextFreeSlot, createCharacter, characterBelongsTo, softDeleteCharacter, getCharacterState, setCharacterState } from '../repositories/characters.repo.js';
import { initStartingAccounts, getBalances } from '../repositories/accounts.repo.js';
import { config } from '../config/index.js';

function getMaxSlotsFromHeader(req) {
    // Optionally allow FiveM server to send a hint; otherwise set via env/ConVar mirror later.
    const h = req?.headers?.['x-srp-max-slots'];
    const n = h ? Number(h) : NaN;
    return Number.isFinite(n) ? n : null;
}

export async function listCharactersForUser({ userId }) {
    const rows = await listByUser(userId);
    // attach balances summary
    const out = [];
    for (const c of rows) {
        const balances = await getBalances(c.id);
        out.push({ ...c, balances });
    }
    return out;
}

export async function createCharacterForUser({ req, userId, payload }) {
    const limitHeader = getMaxSlotsFromHeader(req);
    const LIMIT = limitHeader ?? Infinity; // if you want to hard-cap via env, wire it here
    const current = await countByUser(userId);
    if (current >= LIMIT) {
        const e = new Error('CHAR_LIMIT_REACHED'); e.statusCode = 409; throw e;
    }
    const slot = await nextFreeSlot(userId);
    const cid = await createCharacter({ user_id: userId, slot, ...payload });
    // starting balances from headers (set by FiveM via ConVars)
    const startCash = Number(req?.headers?.['x-srp-start-cash'] || 0);
    const startBank = Number(req?.headers?.['x-srp-start-bank'] || 0);
    await initStartingAccounts(cid, startCash, startBank);
    return cid;
}

export async function selectCharacter({ userId, characterId }) {
    const ok = await characterBelongsTo(userId, characterId);
    if (!ok) { const e = new Error('FORBIDDEN'); e.statusCode = 403; throw e; }

    await setCharacterState(characterId, { touch: true });
    const { character, state } = await getCharacterState(characterId);
    const accounts = await getBalances(characterId);

    return {
        character,
        state,
        accounts
    };
}

export async function deleteCharacterForUser({ userId, characterId }) {
    const ok = await characterBelongsTo(userId, characterId);
    if (!ok) { const e = new Error('FORBIDDEN'); e.statusCode = 403; throw e; }
    await softDeleteCharacter(userId, characterId);
}

export async function savePosition({ characterId, position, routing_bucket }) {
    await setCharacterState(characterId, { position, routing_bucket });
}