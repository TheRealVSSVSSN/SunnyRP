import { db } from './db.js';
export async function setFlag(char_id, flag, value = true, meta = null) {
    const row = await db('contraband_flags').where({ char_id: Number(char_id), flag: String(flag) }).first();
    if (!row) {
        await db('contraband_flags').insert({ char_id: Number(char_id), flag: String(flag), value: !!value, meta: meta ? JSON.stringify(meta) : null });
    } else {
        await db('contraband_flags').where({ id: row.id }).update({ value: !!value, meta: meta ? JSON.stringify(meta) : null });
    }
}
export async function getFlag(char_id, flag) {
    return await db('contraband_flags').where({ char_id: Number(char_id), flag: String(flag) }).first();
}