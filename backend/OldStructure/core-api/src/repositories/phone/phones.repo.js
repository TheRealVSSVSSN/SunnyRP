import { db } from './db.js';

export async function listForChar(char_id) {
    return await db('phones').where({ char_id: Number(char_id), active: true }).orderBy('id', 'asc');
}
export async function get(id) { return await db('phones').where({ id: Number(id) }).first(); }
export async function byNumber(number) { return await db('phones').where({ number: String(number) }).first(); }
export async function create(row) {
    const [id] = await db('phones').insert(row).returning('id');
    return typeof id === 'object' ? id.id : id;
}
export async function update(id, patch) {
    await db('phones').where({ id: Number(id) }).update({ ...patch, updated_at: db.fn.now() });
    return await get(id);
}
export async function availableNumber(area) {
    function rand7() { return String(Math.floor(1000000 + Math.random() * 9000000)).padStart(7, '0'); }
    area = String(area || '415').replace(/\D/g, '').slice(0, 3) || '415';
    for (let i = 0; i < 20; i++) {
        const num = area + rand7();
        const exists = await byNumber(num);
        if (!exists) return num;
    }
    return null;
}