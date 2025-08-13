import { db } from './db.js';
import crypto from 'crypto';

function hashBody(obj) {
    return crypto.createHash('sha256').update(JSON.stringify(obj || {})).digest('hex');
}

export async function getInventory({ container_type = 'char', container_id, includeNoSlot = true }) {
    const q = db('inventory').where({ container_type, container_id }).orderBy([{ column: 'slot', order: 'asc' }, { column: 'id', order: 'asc' }]);
    if (!includeNoSlot) q.andWhere('slot', '>', 0);
    const rows = await q.select('*');
    return rows.map(r => ({ ...r, metadata: r.metadata && typeof r.metadata === 'string' ? JSON.parse(r.metadata) : r.metadata }));
}

export async function getCharacterInventory(charId) {
    return getInventory({ container_type: 'char', container_id: String(charId) });
}

async function claimIdempotency(trx, key, scope, reqBody) {
    const id = String(key);
    const bodyHash = { sha256: hashBody(reqBody) };
    try {
        await trx('idempotency_keys').insert({ id, scope, request_hash: JSON.stringify(bodyHash) });
        return { claimed: true };
    } catch (e) {
        const row = await trx('idempotency_keys').where({ id }).first();
        if (!row) throw e;
        const same = row.request_hash && JSON.parse(row.request_hash).sha256 === bodyHash.sha256;
        return { claimed: false, same, cached: row.response_cache ? JSON.parse(row.response_cache) : null };
    }
}

async function saveIdemResponse(trx, key, response) {
    await trx('idempotency_keys').where({ id: key }).update({ response_cache: JSON.stringify(response) });
}

export async function addItem({ idemKey, container_type, container_id, item_key, quantity = 1, slot = 0, metadata = null, defaultMaxStack = 250 }) {
    return await db.transaction(async (trx) => {
        if (idemKey) {
            const c = await claimIdempotency(trx, idemKey, 'inventory:add', { container_type, container_id, item_key, quantity, slot, metadata });
            if (!c.claimed) return { idempotent: true, ...(c.cached || {}) };
        }

        // fetch item
        const item = await trx('items').where({ key: item_key }).first();
        if (!item) throw new Error('ITEM_NOT_FOUND');

        const maxStack = item.max_stack ?? defaultMaxStack;
        let remaining = Number(quantity);

        // If slot > 0, operate only that slot; else stack into any existing stacks, then create rows as needed.
        if (slot > 0) {
            const row = await trx('inventory').where({ container_type, container_id, slot }).first();
            if (row && row.item_key !== item_key) throw new Error('SLOT_OCCUPIED');
            const curQty = row ? row.quantity : 0;
            const toAdd = Math.min(remaining, maxStack - curQty);
            if (toAdd <= 0) throw new Error('STACK_FULL');
            if (row) {
                await trx('inventory').where({ id: row.id }).update({ quantity: curQty + toAdd, updated_at: trx.fn.now() });
            } else {
                await trx('inventory').insert({ container_type, container_id, slot, item_key, quantity: toAdd, metadata: metadata ? JSON.stringify(metadata) : null });
            }
            remaining -= toAdd;
        } else {
            // fill existing stacks
            const stacks = await trx('inventory').where({ container_type, container_id, item_key }).orderBy('slot', 'asc');
            for (const s of stacks) {
                if (remaining <= 0) break;
                const toAdd = Math.min(remaining, maxStack - s.quantity);
                if (toAdd > 0) {
                    await trx('inventory').where({ id: s.id }).update({ quantity: s.quantity + toAdd, updated_at: trx.fn.now() });
                    remaining -= toAdd;
                }
            }
            // add new stack(s) in slot=0 (or client-managed slots later)
            while (remaining > 0) {
                const toAdd = Math.min(remaining, maxStack);
                await trx('inventory').insert({ container_type, container_id, slot: 0, item_key, quantity: toAdd, metadata: metadata ? JSON.stringify(metadata) : null });
                remaining -= toAdd;
            }
        }

        const result = { ok: true };
        if (idemKey) await saveIdemResponse(trx, idemKey, result);
        return result;
    });
}

export async function removeItem({ idemKey, container_type, container_id, item_key, quantity = 1, slot = 0 }) {
    return await db.transaction(async (trx) => {
        if (idemKey) {
            const c = await claimIdempotency(trx, idemKey, 'inventory:remove', { container_type, container_id, item_key, quantity, slot });
            if (!c.claimed) return { idempotent: true, ...(c.cached || {}) };
        }

        let remaining = Number(quantity);
        if (slot > 0) {
            const row = await trx('inventory').where({ container_type, container_id, slot, item_key }).first();
            if (!row) throw new Error('NOT_FOUND_IN_SLOT');
            const take = Math.min(remaining, row.quantity);
            const left = row.quantity - take;
            if (left > 0) {
                await trx('inventory').where({ id: row.id }).update({ quantity: left, updated_at: trx.fn.now() });
            } else {
                await trx('inventory').where({ id: row.id }).delete();
            }
            remaining -= take;
        } else {
            // drain stacks oldest first
            const stacks = await trx('inventory').where({ container_type, container_id, item_key }).orderBy([{ column: 'slot', order: 'asc' }, { column: 'id', order: 'asc' }]);
            for (const s of stacks) {
                if (remaining <= 0) break;
                const take = Math.min(remaining, s.quantity);
                const left = s.quantity - take;
                if (left > 0) {
                    await trx('inventory').where({ id: s.id }).update({ quantity: left, updated_at: trx.fn.now() });
                } else {
                    await trx('inventory').where({ id: s.id }).delete();
                }
                remaining -= take;
            }
            if (remaining > 0) throw new Error('INSUFFICIENT_QUANTITY');
        }

        const result = { ok: true };
        if (idemKey) await saveIdemResponse(trx, idemKey, result);
        return result;
    });
}