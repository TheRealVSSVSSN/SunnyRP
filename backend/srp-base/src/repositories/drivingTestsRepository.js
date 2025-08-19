const db = require('./db');

/**
 * Repository for managing driving test records.  Driving tests are stored
 * persistently in the `driving_tests` table and can be created and
 * retrieved by ID or by player CID.  Each test record captures the
 * instructor, timestamp, score, pass/fail status and a JSON encoded
 * results payload.  All queries use parameter binding to prevent SQL
 * injection.
 */
async function createTest({ cid, icid, instructor, timestamp, points, passed, results }) {
  const [row] = await db.query(
    `INSERT INTO driving_tests (cid, icid, instructor, timestamp, points, passed, results)
     VALUES (?, ?, ?, ?, ?, ?, ?)`,
    [cid, icid, instructor, timestamp, points, passed ? 1 : 0, JSON.stringify(results || {})]
  );
  return { id: row.insertId, cid, icid, instructor, timestamp, points, passed, results };
}

async function getHistory(cid, limit = 5) {
  const [rows] = await db.query(
    `SELECT id, cid, icid, instructor, timestamp, points, passed, results
     FROM driving_tests WHERE cid = ? ORDER BY id DESC LIMIT ?`,
    [cid, limit]
  );
  return rows.map(r => ({
    id: r.id,
    cid: r.cid,
    icid: r.icid,
    instructor: r.instructor,
    timestamp: r.timestamp,
    points: r.points,
    passed: !!r.passed,
    results: JSON.parse(r.results || '{}'),
  }));
}

async function getTest(id) {
  const [rows] = await db.query(
    `SELECT id, cid, icid, instructor, timestamp, points, passed, results
     FROM driving_tests WHERE id = ?`,
    [id]
  );
  if (rows.length === 0) return null;
  const r = rows[0];
  return {
    id: r.id,
    cid: r.cid,
    icid: r.icid,
    instructor: r.instructor,
    timestamp: r.timestamp,
    points: r.points,
    passed: !!r.passed,
    results: JSON.parse(r.results || '{}'),
  };
}

module.exports = {
  createTest,
  getHistory,
  getTest,
};