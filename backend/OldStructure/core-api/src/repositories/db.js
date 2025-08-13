import knex from 'knex';
import knexfile from '../../knexfile.js';

export const db = knex(knexfile);

export async function checkDb() {
    try {
        await db.raw('SELECT 1+1 AS result');
        return true;
    } catch (e) {
        return false;
    }
}