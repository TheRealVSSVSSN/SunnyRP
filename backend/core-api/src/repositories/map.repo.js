import { db } from './db.js';

export async function createZone({ name, type, data, blip = null, created_by = null }) {
    const [id] = await db('map_zones').insert({ name, type, data: JSON.stringify(data), blip: blip ? JSON.stringify(blip) : null, created_by }).returning('id');
    return typeof id === 'object' ? id.id : id;
}
export async function listZones() {
    const rows = await db('map_zones').select('*').orderBy('id', 'asc');
    return rows.map(r => ({
        ...r,
        data: typeof r.data === 'string' ? JSON.parse(r.data) : r.data,
        blip: r.blip ? (typeof r.blip === 'string' ? JSON.parse(r.blip) : r.blip) : null
    }));
}
export async function findZoneByName(name) {
    const r = await db('map_zones').where({ name }).first();
    if (!r) return null;
    return {
        ...r,
        data: typeof r.data === 'string' ? JSON.parse(r.data) : r.data,
        blip: r.blip ? (typeof r.blip === 'string' ? JSON.parse(r.blip) : r.blip) : null
    };
}
export async function deleteZoneByName(name) {
    await db('map_zones').where({ name }).delete();
}