import { Router } from 'express';
import promBundle from 'express-prom-bundle';
import { uptime, nowIso } from '../utils/time.js';
import { checkDb } from '../repositories/db.js';
import { config } from '../config/index.js';

const router = Router();

const metricsMiddleware = promBundle({
    includeMethod: true,
    includePath: true,
    promClient: { collectDefaultMetrics: {} },
    metricsPath: '/metrics'
});
router.use(metricsMiddleware);

router.get('/health', (req, res) => {
    res.json({
        ok: true,
        data: { status: 'ok', time: nowIso(), uptime: Math.round(uptime()), version: '1.0.0' }
    });
});

router.get('/ready', async (req, res) => {
    const dbOk = await checkDb();
    if (!dbOk) return res.status(503).json({ ok: false, error: { code: 'NOT_READY', message: 'DB unreachable' } });
    res.json({ ok: true, data: { status: 'ready', db: 'ok' } });
});

export default router;