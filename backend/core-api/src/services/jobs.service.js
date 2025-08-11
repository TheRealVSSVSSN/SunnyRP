import * as JobDefs from '../repositories/jobDefs.repo.js';
import * as Jobs from '../repositories/jobs.repo.js';

export async function definitions() {
    return await JobDefs.allWithGrades();
}

export async function setJob(body) {
    if (!body?.char_id || !body?.job_code) { const e = new Error('BAD_REQUEST'); e.statusCode = 400; throw e; }
    const def = await JobDefs.byCode(String(body.job_code));
    if (!def) { const e = new Error('JOB_NOT_FOUND'); e.statusCode = 404; throw e; }
    const grade = Number.isFinite(body.grade) ? Number(body.grade) : def.default_grade;
    const g = await JobDefs.gradeFor(def.id, grade);
    if (!g && grade !== 0) { const e = new Error('GRADE_NOT_FOUND'); e.statusCode = 404; throw e; }
    const row = await Jobs.setJob({ char_id: Number(body.char_id), job_def_id: def.id, grade });
    const hourly = g?.hourly_cents_override ?? def.hourly_cents;
    return { job: row, def, grade: g || { grade: 0, label: 'Junior', hourly_cents_override: null }, hourly_cents: Number(hourly) };
}

export async function setDuty(body) {
    if (!body?.char_id || typeof body.on_duty !== 'boolean') { const e = new Error('BAD_REQUEST'); e.statusCode = 400; throw e; }
    const row = await Jobs.setDuty({ char_id: Number(body.char_id), on_duty: !!body.on_duty });
    return { job: row };
}

export async function state(charId) {
    const job = await Jobs.getByChar(Number(charId));
    if (!job) return { job: null, hourly_cents: 0, def: null, grade: null };
    const def = await JobDefs.allWithGrades().then(list => list.find(d => d.id === job.job_def_id));
    const g = def?.grades?.find(x => x.grade === job.grade) || null;
    const hourly = g?.hourly_cents_override ?? def?.hourly_cents ?? 0;
    return { job, def, grade: g, hourly_cents: Number(hourly) };
}