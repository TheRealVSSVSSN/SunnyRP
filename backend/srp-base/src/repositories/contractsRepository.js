const db = require('./db');

async function listContractsForPlayer(playerId) {
  const rows = await db.query(
    'SELECT id, sender_id, receiver_id, amount, info, paid, accepted, created_at, updated_at FROM contracts WHERE sender_id = ? OR receiver_id = ? ORDER BY id DESC',
    [playerId, playerId],
  );
  return rows.map((row) => ({
    id: row.id,
    sender_id: row.sender_id,
    receiver_id: row.receiver_id,
    amount: row.amount,
    info: row.info,
    paid: !!row.paid,
    accepted: row.accepted === null ? null : !!row.accepted,
    created_at: row.created_at,
    updated_at: row.updated_at,
  }));
}

async function createContract({ senderId, receiverId, amount, info }) {
  const result = await db.query(
    'INSERT INTO contracts (sender_id, receiver_id, amount, info) VALUES (?, ?, ?, ?)',
    [senderId, receiverId, amount, info],
  );
  return { id: result.insertId };
}

async function getContract(id) {
  const rows = await db.query(
    'SELECT id, sender_id, receiver_id, amount, info, paid, accepted FROM contracts WHERE id = ?',
    [id],
  );
  return rows[0] || null;
}

async function markAccepted(id) {
  await db.query('UPDATE contracts SET paid = 1, accepted = 1, updated_at = CURRENT_TIMESTAMP WHERE id = ?', [id]);
}

async function markDeclined(id) {
  await db.query('UPDATE contracts SET accepted = 0, updated_at = CURRENT_TIMESTAMP WHERE id = ?', [id]);
}

module.exports = {
  listContractsForPlayer,
  createContract,
  getContract,
  markAccepted,
  markDeclined,
};
