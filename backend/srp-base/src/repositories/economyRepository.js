const db = require('./db');

/**
 * Economy repository.  Consolidates account and transaction
 * persistence operations.  Player accounts hold a balance and
 * transactions record transfers between accounts.  All values are
 * stored in whole cents to avoid floating point rounding issues.
 */

/**
 * Retrieve an account for a player.  If no account exists a new
 * row is created with a zero balance.  Returns an object with
 * id, player_id and balance.
 *
 * @param {string} playerId
 * @returns {Promise<{id: number, player_id: string, balance: number}>}
 */
async function getAccount(playerId) {
  const rows = await db.query(
    'SELECT id, player_id, balance FROM accounts WHERE player_id = ?',
    [playerId],
  );
  if (rows.length > 0) {
    return rows[0];
  }
  const result = await db.pool.query(
    'INSERT INTO accounts (player_id, balance) VALUES (?, ?)',
    [playerId, 0],
  );
  return { id: result[0].insertId, player_id: playerId, balance: 0 };
}

/**
 * Deposit funds into a player's account.  Returns the new balance.
 *
 * @param {string} playerId
 * @param {number} amount
 * @returns {Promise<{balance: number}>}
 */
async function deposit(playerId, amount) {
  const account = await getAccount(playerId);
  const newBalance = account.balance + amount;
  await db.query('UPDATE accounts SET balance = ? WHERE id = ?', [newBalance, account.id]);
  return { balance: newBalance };
}

/**
 * Withdraw funds from a player's account.  Does not allow negative
 * balances; withdrawals that exceed the balance will clamp to zero.
 * Returns the new balance.
 *
 * @param {string} playerId
 * @param {number} amount
 * @returns {Promise<{balance: number}>}
 */
async function withdraw(playerId, amount) {
  const account = await getAccount(playerId);
  let newBalance = account.balance - amount;
  if (newBalance < 0) newBalance = 0;
  await db.query('UPDATE accounts SET balance = ? WHERE id = ?', [newBalance, account.id]);
  return { balance: newBalance };
}

/**
 * Create a transaction between two players.  The transaction is
 * recorded in the transactions table and balances are adjusted.
 * Returns the transaction id and sender's remaining balance.  A
 * zero or negative amount is ignored.  No overdraft is permitted –
 * withdrawals that exceed the balance will clamp to zero.
 *
 * @param {{fromPlayerId: string, toPlayerId: string, amount: number, reason?: string}} params
 * @returns {Promise<{id: number, senderBalance: number}>}
 */
async function createTransaction({ fromPlayerId, toPlayerId, amount, reason }) {
  const amt = Number(amount) || 0;
  if (amt <= 0) {
    throw new Error('Amount must be positive');
  }
  // Withdraw from sender
  const { balance: senderBalance } = await withdraw(fromPlayerId, amt);
  // Deposit to receiver
  await deposit(toPlayerId, amt);
  // Record transaction
  const result = await db.pool.query(
    'INSERT INTO transactions (from_player_id, to_player_id, amount, reason) VALUES (?, ?, ?, ?)',
    [fromPlayerId, toPlayerId, amt, reason || null],
  );
  return { id: result[0].insertId, senderBalance };
}

/**
 * Retrieve a transaction by its primary key.  Returns null if
 * not found.
 *
 * @param {number} id
 * @returns {Promise<object|null>}
 */
async function getTransaction(id) {
  const rows = await db.query('SELECT * FROM transactions WHERE id = ?', [id]);
  return rows[0] || null;
}

module.exports = {
  getAccount,
  deposit,
  withdraw,
  createTransaction,
  getTransaction,
};