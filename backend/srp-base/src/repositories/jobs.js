import { query } from '../db/index.js';

export async function listCharacterJobs(characterId) {
  const rows = await query(
    `SELECT job_name AS job, grade, is_secondary AS secondary
     FROM character_jobs
     WHERE character_id = ?
     ORDER BY is_secondary ASC, job_name ASC`,
    [characterId]
  );
  return rows.map((r) => ({ job: r.job, grade: r.grade, secondary: Boolean(r.secondary) }));
}

export async function setPrimaryJob(characterId, job, grade) {
  await query(`INSERT IGNORE INTO jobs (name, label) VALUES (?, ?)`, [job, job]);
  await query(
    `INSERT INTO character_jobs (character_id, job_name, grade, is_secondary)
     VALUES (?, ?, ?, 0)
     ON DUPLICATE KEY UPDATE grade = VALUES(grade)`,
    [characterId, job, grade]
  );
}

export async function setSecondaryJob(characterId, job, grade) {
  await query(`INSERT IGNORE INTO jobs (name, label) VALUES (?, ?)`, [job, job]);
  await query(
    `INSERT INTO character_jobs (character_id, job_name, grade, is_secondary)
     VALUES (?, ?, ?, 1)
     ON DUPLICATE KEY UPDATE grade = VALUES(grade)`,
    [characterId, job, grade]
  );
}

export async function removeSecondaryJob(characterId, job) {
  await query(
    `DELETE FROM character_jobs
     WHERE character_id = ? AND job_name = ? AND is_secondary = 1`,
    [characterId, job]
  );
}
