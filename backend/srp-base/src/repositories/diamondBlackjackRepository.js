const db = require('./db');

async function recordHand({ characterId, tableId, bet, payout, dealerHand, playerHand, playedAt }) {
  const ts = playedAt || Date.now();
  await db.query(
    'INSERT INTO diamond_blackjack_hands (character_id, table_id, bet, payout, dealer_hand, player_hand, played_at) VALUES (?, ?, ?, ?, ?, ?, ?)',
    [characterId, tableId, bet, payout, dealerHand, playerHand, ts],
  );
  return { characterId, tableId, bet, payout, dealerHand, playerHand, playedAt: ts };
}

async function listHandsByCharacter(characterId, limit = 50) {
  const [rows] = await db.query(
    'SELECT table_id AS tableId, bet, payout, dealer_hand AS dealerHand, player_hand AS playerHand, played_at AS playedAt FROM diamond_blackjack_hands WHERE character_id = ? ORDER BY played_at DESC LIMIT ?',
    [characterId, limit],
  );
  return rows;
}

module.exports = { recordHand, listHandsByCharacter };
