const db = require('./db');

async function listTweets(limit = 50) {
  const [rows] = await db.query(
    'SELECT handle, message, time FROM (SELECT handle, message, time FROM tweets ORDER BY time DESC LIMIT ?) t ORDER BY time ASC',
    [limit],
  );
  return rows;
}

async function createTweet(handle, message, time) {
  const ts = time || Date.now();
  await db.query('INSERT INTO tweets (handle, message, time) VALUES (?, ?, ?)', [handle, message, ts]);
  return { handle, message, time: ts };
}

module.exports = { listTweets, createTweet };
