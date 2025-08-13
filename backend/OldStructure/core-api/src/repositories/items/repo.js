import { db } from './db.js';

export async function listItems() {
    const rows = await db('items').select('*').orderBy('id', 'asc');
    return rows.map(r => ({ ...r, meta_schema: r.meta_schema && typeof r.meta_schema === 'string' ? JSON.parse(r.meta_schema) : r.meta_schema }));
}
export async function getItem(key) {
    const r = await db('items').where({ key }).first();
    if (!r) return null;
    return { ...r, meta_schema: r.meta_schema && typeof r.meta_schema === 'string' ? JSON.parse(r.meta_schema) : r.meta_schema };
}