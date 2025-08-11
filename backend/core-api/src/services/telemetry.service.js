import * as Telemetry from '../repositories/telemetry.repo.js';
import * as Alerts from '../repositories/alerts.repo.js';
import metrics from '../utils/metrics.js';

const clamp = (n, min, max) => Math.max(min, Math.min(max, n));

function severityFor(kind, v) {
    switch (kind) {
        case 'speed': return v > 80 ? 3 : v > 40 ? 2 : 1;
        case 'teleport': return v > 200 ? 3 : 2;
        case 'burst': return 2;
        default: return 1;
    }
}

export async function ingest(body, actor) {
    const endTimer = metrics.ingestLatency.startTimer();
    try {
        const { type, subcategory, severity = 0, payload } = body;
        const row = {
            user_id: actor.user_id || null,
            char_id: actor.char_id || null,
            type: String(type || 'custom'),
            subcategory: subcategory ? String(subcategory) : null,
            severity: Number(severity || 0),
            payload: payload ? JSON.stringify(payload) : null
        };
        const id = await Telemetry.insert(row);
        metrics.telemetryEvents.inc({ type: row.type, subcategory: row.subcategory || 'none' });
        return { id };
    } finally {
        endTimer();
    }
}

export async function anomaly(kind, meta, actor) {
    const sev = severityFor(kind, meta?.value || 0);
    await Telemetry.insert({
        user_id: actor.user_id || null,
        char_id: actor.char_id || null,
        type: 'anomaly',
        subcategory: kind,
        severity: sev,
        payload: JSON.stringify(meta || {})
    });
    metrics.anomalies.inc({ kind, severity: String(sev) });
    const msg = `[Anomaly/${kind.toUpperCase()}] ${meta?.note || ''}`.trim();
    const id = await Alerts.push('anomaly', sev, msg, { actor, meta });
    return { id, severity: sev };
}