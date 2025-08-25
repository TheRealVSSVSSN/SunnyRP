const db = require('./db');

async function createGame({ gameType, metadata }) {
  const createdAt = Date.now();
  const [result] = await db.query(
    'INSERT INTO diamond_casino_games (game_type, metadata, state, created_at) VALUES (?, ?, ?, ?)',
    [gameType, JSON.stringify(metadata || {}), 'pending', createdAt],
  );
  return { id: result.insertId, gameType, metadata: metadata || {}, state: 'pending', createdAt };
}

async function addBet({ gameId, characterId, amount, betData }) {
  const createdAt = Date.now();
  await db.query(
    'INSERT INTO diamond_casino_bets (game_id, character_id, bet_amount, bet_data, created_at) VALUES (?, ?, ?, ?, ?)',
    [gameId, characterId, amount, JSON.stringify(betData || {}), createdAt],
  );
  return { gameId, characterId, amount, betData: betData || {}, createdAt };
}

async function getGame(gameId) {
  const [[game]] = await db.query(
    'SELECT id, game_type AS gameType, state, metadata, result, created_at AS createdAt, resolved_at AS resolvedAt FROM diamond_casino_games WHERE id = ?',
    [gameId],
  );
  if (!game) return null;
  const [bets] = await db.query(
    'SELECT id, character_id AS characterId, bet_amount AS betAmount, bet_data AS betData, result, payout, created_at AS createdAt, resolved_at AS resolvedAt FROM diamond_casino_bets WHERE game_id = ?',
    [gameId],
  );
  return {
    ...game,
    metadata: JSON.parse(game.metadata || '{}'),
    result: game.result ? JSON.parse(game.result) : null,
    bets: bets.map((b) => ({ ...b, betData: b.betData ? JSON.parse(b.betData) : {} })),
  };
}

async function listPendingGames(beforeTs) {
  const [rows] = await db.query(
    'SELECT id, game_type AS gameType FROM diamond_casino_games WHERE state = ? AND created_at <= ?',
    ['pending', beforeTs],
  );
  return rows;
}

async function resolveGame(gameId, result) {
  const resolvedAt = Date.now();
  await db.query(
    'UPDATE diamond_casino_games SET state = ?, result = ?, resolved_at = ? WHERE id = ?',
    ['resolved', JSON.stringify(result), resolvedAt, gameId],
  );
  await db.query(
    'UPDATE diamond_casino_bets SET result = ?, resolved_at = ? WHERE game_id = ?',
    [JSON.stringify(result), resolvedAt, gameId],
  );
}

module.exports = {
  createGame,
  addBet,
  getGame,
  listPendingGames,
  resolveGame,
};
