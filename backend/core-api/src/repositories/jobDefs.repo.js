import { db } from './db.js';

export async function allWithGrades() {
    const defs = await db('job_defs').orderBy('code', 'asc');
    const grades = await db('job_grades').orderBy(['job_def_id', 'grade']);
    const byDef = {};
    for (const g of grades) {
        const arr = byDef[g.job_def_id] || (byDef[g.job_def_id] = []);
        arr.push({ ...g, permissions: g.permissions ? JSON.parse(g.permissions) : [] });
    }
    return defs.map(d => ({ ...d, grades: byDef[d.id] || [] }));
}
export async function byCode(code) {
    return await db('job_defs').where({ code }).first();
}
export async function gradeFor(defId, grade) {
    const g = await db('job_grades').where({ job_def_id: defId, grade }).first();
    return g ? { ...g, permissions: g.permissions ? JSON.parse(g.permissions) : [] } : null;
}