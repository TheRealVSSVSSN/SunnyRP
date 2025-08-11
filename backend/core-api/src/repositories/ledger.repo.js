import { db } from './db.js';

export async function write(entry, trx) {
    const row = { ...entry, meta: entry.meta ? JSON.stringify(entry.meta) : null };
    const [id] = await (trx || db)('ledger').insert(row).returning('id');
    return typeof id === 'object' ? id.id : id;
}

export async function listByChar(charId, limit = 100, offset = 0) {
    return await db('ledger')
        .where(function () { this.where({ from_type: 'char', from_ref: String(charId) }).orWhere({ to_type: 'char', to_ref: String(charId) }); })
        .orderBy('id', 'desc')
        .limit(limit).offset(offset);
}

export async function adminList(where = {}, limit = 200, offset = 0) {
    let q = db('ledger').orderBy('id', 'desc');
    if (where.kind) q = q.where({ kind: where.kind });
    if (where.charId) q = q.where(function () { this.where({ from_type: 'char', from_ref: String(where.charId) }).orWhere({ to_type: 'char', to_ref: String(where.charId) }); });
    if (where.transfer_id) q = q.where({ transfer_id: where.transfer_id });
    return await q.limit(limit).offset(offset);
}