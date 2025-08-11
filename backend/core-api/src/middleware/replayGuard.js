import { verify } from '../services/replay.service.js';
import metrics from '../utils/metrics.js';

export default function replayGuard(req, res, next) {
    if (process.env.ENABLE_REPLAY_GUARD !== 'true') return next();
    try {
        const apiToken = req.header('X-API-Token');
        const out = verify(req, apiToken);
        if (!out.ok) {
            metrics.replayBlocked.inc();
            return res.status(401).json({ ok: false, error: out.reason });
        }
        next();
    } catch (e) {
        metrics.replayBlocked.inc(); return res.status(401).json({ ok: false, error: 'REPLAY_ERROR' });
    }
}