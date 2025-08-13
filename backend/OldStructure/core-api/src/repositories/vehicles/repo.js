import { db } from './db.js';
import crypto from 'crypto';

export function newVin() {
    return 'SRPVIN-' + crypto.randomBytes(8).toString('hex').toUpperCase();
}

export async function newUniquePlate(prefix = 'SRP') {
    let tries = 0;
    while (tries++ < 50) {
        const plate = (prefix + '-' + Math.random().toString(36).slice(2, 8)).toUpperCase().replace(/[^A-Z0-9-]/g, '').slice(0, 8);
        const exists = await db('vehicles').where({ plate }).first();
        if (!exists) return plate;
    }
    // final fallback: timestamp
    return (prefix + '-' + Date.now().toString().slice(-6)).toUpperCase().slice(0, 8);
}

export async function listByChar(charId) {
    const rows = await db('vehicles').where({ owner_char_id: charId }).orderBy('id', 'asc');
    return rows.map(deser);
}

export async function listByState(state) {
    const rows = await db('vehicles').where({ state }).orderBy('id', 'asc');
    return rows.map(deser);
}

export async function getById(id) {
    const r = await db('vehicles').where({ id }).first();
    return r ? deser(r) : null;
}

export async function createVehicle({ owner_char_id, model, display_name, plate, mods, condition }) {
    const vin = newVin();
    const usePlate = plate || await newUniquePlate(process.env.SRP_VEH_PLATE_PREFIX || 'SRP');
    const row = {
        owner_char_id, vin, plate: usePlate, model, display_name: display_name || model,
        state: 'stored', garage_id: null,
        mods: mods ? JSON.stringify(mods) : null,
        condition: condition ? JSON.stringify(condition) : JSON.stringify({ engine: 1000, body: 1000, fuel: 100, dirt: 0 }),
        last_position: null, active: false, active_entity: null
    };
    const [id] = await db('vehicles').insert(row).returning('id');
    const rid = typeof id === 'object' ? id.id : id;
    return await getById(rid);
}

export async function storeVehicle({ vehicle_id, garage_id }) {
    await db('vehicles').where({ id: vehicle_id }).update({
        state: 'stored', garage_id: garage_id || null, active: false, active_entity: null, updated_at: db.fn.now()
    });
    return await getById(vehicle_id);
}

export async function retrieveVehicle({ vehicle_id, pos }) {
    await db('vehicles').where({ id: vehicle_id }).update({
        state: 'world', garage_id: null, last_position: JSON.stringify(pos || null), updated_at: db.fn.now()
    });
    return await getById(vehicle_id);
}

export async function updateState({ vehicle_id, pos, condition, active, active_entity }) {
    const patch = { updated_at: db.fn.now() };
    if (pos) patch.last_position = JSON.stringify(pos);
    if (condition) patch.condition = JSON.stringify(condition);
    if (typeof active === 'boolean') patch.active = active;
    if (active_entity !== undefined) patch.active_entity = active_entity;
    await db('vehicles').where({ id: vehicle_id }).update(patch);
    return await getById(vehicle_id);
}

export async function transferTitle({ vehicle_id, from_char_id, to_char_id }) {
    const v = await getById(vehicle_id);
    if (!v) throw new Error('NOT_FOUND');
    if (v.owner_char_id !== from_char_id) throw new Error('NOT_OWNER');
    await db('vehicles').where({ id: vehicle_id }).update({ owner_char_id: to_char_id, updated_at: db.fn.now() });
    // wipe keys (owner will be re-granted below if needed)
    await db('vehicle_keys').where({ vehicle_id }).andWhere('char_id', '!=', to_char_id).delete();
    return await getById(vehicle_id);
}

export async function markImpounded({ vehicle_id, yard_id, reason, fee = 0 }) {
    await db('vehicles').where({ id: vehicle_id }).update({ state: 'impounded', active: false, active_entity: null, updated_at: db.fn.now() });
    const [id] = await db('impounds').insert({ vehicle_id, yard_id, reason: reason || null, fee }).returning('id');
    return { impound_id: typeof id === 'object' ? id.id : id };
}

export async function deleteVehicleAdmin(vehicle_id) {
    await db('vehicle_keys').where({ vehicle_id }).delete();
    await db('impounds').where({ vehicle_id }).delete();
    await db('vehicles').where({ id: vehicle_id }).delete();
    return { ok: true };
}

function deser(r) {
    return {
        ...r,
        mods: r.mods ? (typeof r.mods === 'string' ? JSON.parse(r.mods) : r.mods) : null,
        condition: r.condition ? (typeof r.condition === 'string' ? JSON.parse(r.condition) : r.condition) : null,
        last_position: r.last_position ? (typeof r.last_position === 'string' ? JSON.parse(r.last_position) : r.last_position) : null,
    };
}