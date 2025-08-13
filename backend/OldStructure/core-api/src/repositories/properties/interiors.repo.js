import { db } from './db.js';
export async function byCode(code) { return await db('interiors').where({ code }).first(); }
export async function get(id) { return await db('interiors').where({ id }).first(); }