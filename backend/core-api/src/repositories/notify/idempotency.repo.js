import { db } from './db.js';

export async function claim(scope, key, response, trx) {
    try {
        const data = { scope, key, response: response ? JSON.stringify(response) : null };
        await (trx || db)('idempotency_keys').insert(data);
        return { created: true };
    } catch (e) {
        if (String(e.message).includes('duplicate')) {
            const row = await (trx || db)('idempotency_keys').where({ key }).first();
            return { created: false, response: row?.response ? JSON.parse(row.response) : null };
        }
        throw e;
    }
}

export async function fulfill(scope, key, response, trx) {
    await (trx || db)('idempotency_keys').where({ key }).update({ response: JSON.stringify(response) });
}