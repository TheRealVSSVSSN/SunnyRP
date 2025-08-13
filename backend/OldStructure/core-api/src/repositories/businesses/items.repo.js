import { db } from './db.js';
export async function catalog(business_id) {
    return await db('business_items').where({ business_id: Number(business_id), enabled: true }).orderBy('id', 'asc');
}
export async function get(business_id, code) {
    return await db('business_items').where({ business_id: Number(business_id), item_code: String(code) }).first();
}
export async function upsert(row) {
    const exists = await get(row.business_id, row.item_code);
    if (exists) {
        await db('business_items').where({ id: exists.id }).update({
            price_cents: row.price_cents, stock_qty: row.stock_qty, enabled: row.enabled ?? true
        });
        return exists.id;
    }
    const [id] = await db('business_items').insert(row).returning('id');
    return typeof id === 'object' ? id.id : id;
}
export async function consumeStock(business_id, code, qty) {
    const item = await get(business_id, code);
    if (!item) return { ok: false, code: 'NO_ITEM' };
    if (item.stock_qty == null) return { ok: true, left: null }; // infinite
    if (item.stock_qty < qty) return { ok: false, code: 'OUT_OF_STOCK' };
    await db('business_items').where({ id: item.id }).update({ stock_qty: item.stock_qty - qty });
    return { ok: true, left: item.stock_qty - qty };
}