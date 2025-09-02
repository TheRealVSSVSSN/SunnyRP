import { query } from '../db/index.js';

async function ensureAccount(characterId) {
  const rows = await query('SELECT id, balance FROM bank_accounts WHERE character_id = ?', [characterId]);
  if (rows.length) return rows[0];
  const result = await query('INSERT INTO bank_accounts (character_id) VALUES (?)', [characterId]);
  return { id: result.insertId, balance: 0 };
}

export async function getAccount(characterId) {
  return ensureAccount(characterId);
}

export async function deposit(characterId, amount) {
  const account = await ensureAccount(characterId);
  await query('UPDATE bank_accounts SET balance = balance + ? WHERE id = ?', [amount, account.id]);
  await query(
    'INSERT INTO bank_transactions (bank_account_id, amount, type) VALUES (?, ?, ?)',
    [account.id, amount, 'deposit']
  );
  return getAccount(characterId);
}

export async function withdraw(characterId, amount) {
  const account = await ensureAccount(characterId);
  await query('UPDATE bank_accounts SET balance = balance - ? WHERE id = ?', [amount, account.id]);
  await query(
    'INSERT INTO bank_transactions (bank_account_id, amount, type) VALUES (?, ?, ?)',
    [account.id, amount, 'withdraw']
  );
  return getAccount(characterId);
}

export async function getTransactions(characterId) {
  const account = await ensureAccount(characterId);
  return query(
    'SELECT id, amount, type, description, created_at AS createdAt FROM bank_transactions WHERE bank_account_id = ? ORDER BY id DESC',
    [account.id]
  );
}
