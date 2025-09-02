import { query } from '../db/index.js';

export async function listChat(limit = 50) {
  return query(
    `SELECT id, character_id AS characterId, message, created_at AS createdAt
     FROM chat_messages
     ORDER BY id DESC
     LIMIT ?`,
    [limit]
  );
}

export async function addChat(characterId, message) {
  const res = await query(
    `INSERT INTO chat_messages (character_id, message) VALUES (?, ?)`,
    [characterId, message]
  );
  return res.insertId;
}

export async function createVote(question, options, endsAt = null) {
  const res = await query(
    `INSERT INTO votes (question, ends_at) VALUES (?, ?)`,
    [question, endsAt]
  );
  const voteId = res.insertId;
  for (const opt of options) {
    await query(
      `INSERT INTO vote_options (vote_id, option_text) VALUES (?, ?)`,
      [voteId, opt]
    );
  }
  return voteId;
}

export async function castVote(voteId, characterId, optionId) {
  await query(
    `INSERT INTO vote_responses (vote_id, character_id, option_id)
     VALUES (?, ?, ?)
     ON DUPLICATE KEY UPDATE option_id = VALUES(option_id)`,
    [voteId, characterId, optionId]
  );
  await query(
    `UPDATE vote_options SET count = count + 1 WHERE id = ?`,
    [optionId]
  );
}

export async function getVote(voteId) {
  const votes = await query(
    `SELECT id, question, ends_at AS endsAt, created_at AS createdAt FROM votes WHERE id = ?`,
    [voteId]
  );
  if (votes.length === 0) return null;
  const options = await query(
    `SELECT id, option_text AS option, count FROM vote_options WHERE vote_id = ?`,
    [voteId]
  );
  return { id: votes[0].id, question: votes[0].question, endsAt: votes[0].endsAt, createdAt: votes[0].createdAt, options };
}
