import { db } from './db.js';

export async function heartbeat(row) {
    const existing = await db('admin_presence').where({ user_id: row.user_id, src: String(row.src) }).first();
    const data = {
        char_id: row.char_id || null,
        name: row.name || 'Unknown',
        job_code: row.job_code || null,
        position: row.position ? JSON.stringify(row.position) : null,
        health: row.health ?? null,
        in_vehicle: !!row.in_vehicle,
        last_heartbeat: db.fn.now(),
    };
    if (existing) {
        await db('admin_presence').where({ id: existing.id }).update(data);
        return existing.id;
    } else {
        const [id] = await db('admin_presence').insert({ user_id: row.user_id, src: String(row.src), ...data }).returning('id');
        return typeof id === 'object' ? id.id : id;
    }
}

export async function online(sinceSec = 60) {
    const cutoff = db.raw(`NOW() - INTERVAL '${sinceSec} seconds'`);
    return await db('admin_presence').where('last_heartbeat', '>', cutoff).orderBy('name', 'asc');
}