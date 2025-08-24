const db = require('./db');

/**
 * Economy repository.  Consolidates account and transaction
 * persistence operations.  Player accounts hold a balance and
 * transactions record transfers between accounts.  All values are
 * stored in whole cents to avoid floating point rounding issues.
 */

/**
 * Retrieve an account for a character.  If no account exists a new
 * row is created with a zero balance.  Returns an object with
 * id, character_id and balance.
 *
 * @param {string} characterId
 * @returns {Promise<{id: number, character_id: string, balance: number}>}
 */
async function getAccount(characterId) {
  const rows = await db.query(
    'SELECT id, character_id, balance FROM accounts WHERE character_id = ?',
    [characterId],
  );
  if (rows.length > 0) {
    return rows[0];
  }
  const result = await db.pool.query(
    'INSERT INTO accounts (character_id, balance) VALUES (?, ?)',
    [characterId, 0],
  );
  return { id: result[0].insertId, character_id: characterId, balance: 0 };
}

/**
 * Deposit funds into a character's account.  Returns the new balance.
 *
 * @param {string} characterId
 * @param {number} amount
 * @returns {Promise<{balance: number}>}
 */
async function deposit(characterId, amount) {
  const account = await getAccount(characterId);
  const newBalance = account.balance + amount;
  await db.query('UPDATE accounts SET balance = ? WHERE id = ?', [newBalance, account.id]);
  return { balance: newBalance };
}

/**
 * Withdraw funds from a character's account.  Does not allow negative
 * balances; withdrawals that exceed the balance will clamp to zero.
 * Returns the new balance.
 *
 * @param {string} characterId
 * @param {number} amount
 * @returns {Promise<{balance: number}>}
 */
async function withdraw(characterId, amount) {
  const account = await getAccount(characterId);
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
 * @param {{fromCharacterId: string, toCharacterId: string, amount: number, reason?: string}} params
 * @returns {Promise<{id: number, senderBalance: number}>}
 */
async function createTransaction({ fromCharacterId, toCharacterId, amount, reason }) {
  const amt = Number(amount) || 0;
  if (amt <= 0) {
    throw new Error('Amount must be positive');
  }
  // Withdraw from sender
  const { balance: senderBalance } = await withdraw(fromCharacterId, amt);
  // Deposit to receiver
  await deposit(toCharacterId, amt);
  // Record transaction
  const result = await db.pool.query(
    'INSERT INTO transactions (from_character_id, to_character_id, amount, reason) VALUES (?, ?, ?, ?)',
    [fromCharacterId, toCharacterId, amt, reason || null],
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

/**
 * List recent transactions for a character, ordered by newest first.
 *
 * @param {string} characterId
 * @param {number} limit
 * @returns {Promise<object[]>}
 */
async function listTransactions(characterId, limit = 50) {
  const rows = await db.query(
    `SELECT * FROM transactions
     WHERE from_character_id = ? OR to_character_id = ?
     ORDER BY id DESC
     LIMIT ?`,
    [characterId, characterId, limit],
  );
  return rows;
}

module.exports = {
  getAccount,
  deposit,
  withdraw,
  createTransaction,
  getTransaction,
  listTransactions,
};