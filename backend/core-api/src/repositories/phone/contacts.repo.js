import { db } from './db.js';
export async function list(phone_id) { return await db('contacts').where({ phone_id: Number(phone_id) }).orderBy('name', 'asc'); }
export async function create(row) { const [id] = await db('contacts').insert(row).returning('id'); return typeof id === 'object' ? id.id : id; }
export async function update(id, patch) { await db('contacts').where({ id: Number(id) }).update(patch); return await db('contacts').where({ id: Number(id) }).first(); }
export async function remove(id) { await db('contacts').where({ id: Number(id) }).delete(); }