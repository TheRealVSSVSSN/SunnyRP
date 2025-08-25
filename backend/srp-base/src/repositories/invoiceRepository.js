const db = require('./db');
const economyRepo = require('./economyRepository');

/**
 * Create an invoice record.
 * @param {{fromCharacterId: string, toCharacterId: string, amount: number, reason?: string, dueAt?: string}} params
 * @returns {Promise<{id:number}>}
 */
async function createInvoice({ fromCharacterId, toCharacterId, amount, reason, dueAt }) {
  const result = await db.pool.query(
    'INSERT INTO invoices (from_character_id, to_character_id, amount, reason, status, due_at, created_at, updated_at) VALUES (?, ?, ?, ?, "pending", ?, NOW(), NOW())',
    [fromCharacterId, toCharacterId, amount, reason || null, dueAt || null],
  );
  return { id: result[0].insertId };
}

/**
 * Retrieve an invoice by id.
 */
async function getInvoice(id) {
  const rows = await db.query('SELECT * FROM invoices WHERE id = ?', [id]);
  return rows[0] || null;
}

/**
 * List invoices for a character (as sender or receiver).
 */
async function listInvoices(characterId, status) {
  const rows = await db.query(
    'SELECT * FROM invoices WHERE (from_character_id = ? OR to_character_id = ?) AND (? IS NULL OR status = ?) ORDER BY id DESC',
    [characterId, characterId, status || null, status || null],
  );
  return rows;
}

/**
 * Pay an invoice. Withdraws from payer and deposits to recipient.
 */
async function payInvoice(id, payingCharacterId) {
  const invoice = await getInvoice(id);
  if (!invoice || invoice.status !== 'pending' || invoice.to_character_id !== payingCharacterId) {
    return null;
  }
  await economyRepo.withdraw(payingCharacterId, invoice.amount);
  await economyRepo.deposit(invoice.from_character_id, invoice.amount);
  await db.query('UPDATE invoices SET status = "paid", updated_at = NOW() WHERE id = ?', [id]);
  return { paid: true };
}

/**
 * Cancel an invoice by sender.
 */
async function cancelInvoice(id, fromCharacterId) {
  const invoice = await getInvoice(id);
  if (!invoice || invoice.status !== 'pending' || invoice.from_character_id !== fromCharacterId) {
    return null;
  }
  await db.query('UPDATE invoices SET status = "cancelled", updated_at = NOW() WHERE id = ?', [id]);
  return { cancelled: true };
}

/**
 * Remove invoices that are not pending and older than cutoff.
 */
async function purgeSettled(cutoff) {
  await db.query('DELETE FROM invoices WHERE status != "pending" AND updated_at < ?', [cutoff]);
}

module.exports = {
  createInvoice,
  getInvoice,
  listInvoices,
  payInvoice,
  cancelInvoice,
  purgeSettled,
};
