import { db } from './db.js';

export async function grantKey({ vehicle_id, char_id, granted_by }) {
    await db('vehicle_keys').insert({ vehicle_id, char_id, granted_by }).onConflict(['vehicle_id', 'char_id']).ignore();
    return { ok: true };
}

export async function revokeKey({ vehicle_id, char_id }) {
    await db('vehicle_keys').where({ vehicle_id, char_id }).delete();
    return { ok: true };
}

export async function listKeys(vehicle_id) {
    return await db('vehicle_keys').where({ vehicle_id }).orderBy('id', 'asc');
}

export async function hasKey({ vehicle_id, char_id }) {
    const row = await db('vehicle_keys').where({ vehicle_id, char_id }).first();
    return !!row;
}