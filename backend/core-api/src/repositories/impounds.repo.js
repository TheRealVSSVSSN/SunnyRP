import { db } from './db.js';

export async function listImpounds(vehicle_id) {
    return await db('impounds').where({ vehicle_id }).orderBy('id', 'desc');
}