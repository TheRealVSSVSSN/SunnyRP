import { db } from './db.js';

export async function ensureAccountRow(character_id, type, starting = 0) {
    const exist = await db('accounts').where({ character_id, type }).first();
    if (!exist) await db('accounts').insert({ character_id, type, balance: starting });
}

export async function initStartingAccounts(character_id, startCash = 0, startBank = 0) {
    await ensureAccountRow(character_id, 'cash', startCash);
    await ensureAccountRow(character_id, 'bank', startBank);
}

export async function getBalances(character_id) {
    const rows = await db('accounts').where({ character_id });
    const balances = { cash: 0, bank: 0, dirty: 0 };
    for (const r of rows) balances[r.type] = Number(r.balance);
    return balances;
}

export async function getOrCreate(charId, trx) {
  const q = () => db('accounts').where({ char_id: charId }).first();
  let row = await (trx || db)(q);
  if (!row) {
    const insert = { char_id: charId, cash_cents: 0, bank_cents: 0 };
    const [id] = await (trx || db)('accounts').insert(insert).returning('id');
    row = await (trx || db)('accounts').where({ char_id: charId }).first();
  }
  return row;
}

export async function delta(charId, pocket, amountCents, trx) {
  await getOrCreate(charId, trx);
  const col = pocket === 'cash' ? 'cash_cents' : 'bank_cents';
  const row = await (trx || db)('accounts').where({ char_id: charId }).forUpdate().first();
  const next = Number(row[col]) + Number(amountCents);
  if (next < 0) {
    const e = new Error('INSUFFICIENT_FUNDS'); e.statusCode = 400; throw e;
  }
  await (trx || db)('accounts').where({ char_id: charId }).update({ [col]: next, updated_at: db.fn.now() });
  return { cash_cents: pocket === 'cash' ? next : Number(row.cash_cents), bank_cents: pocket === 'bank' ? next : Number(row.bank_cents) };
}

export async function balances(charId) {
  const row = await db('accounts').where({ char_id: charId }).first();
  return row ? { cash_cents: Number(row.cash_cents), bank_cents: Number(row.bank_cents) } : { cash_cents: 0, bank_cents: 0 };
}
