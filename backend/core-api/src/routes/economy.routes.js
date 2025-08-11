import { Router } from 'express';
import authToken from '../middleware/authToken.js';
import rateLimit from '../middleware/rateLimit.js';
import * as Econ from '../services/economy.service.js';
import * as Ledger from '../repositories/ledger.repo.js';

const router = Router();
const limiter = rateLimit({ windowMs: 2000, max: 180 });

router.post('/economy/transfer', authToken(true), limiter, async (req, res, next) => {
    try { const r = await Econ.transfer(req.body || {}, req.headers); res.json(r); }
    catch (e) { next(e); }
});

router.post('/economy/payroll/run', authToken(true), limiter, async (req, res, next) => {
    try {
        if (!req.body?.char_id || !req.body?.gross_cents) { const e = new Error('BAD_REQUEST'); e.statusCode = 400; throw e; }
        const r = await Econ.runPayroll(req.body, req.headers); res.json(r);
    } catch (e) { next(e); }
});

// Admin/ops: view ledger (filters)
router.get('/economy/ledger', authToken(true), async (req, res, next) => {
    try {
        const q = { kind: req.query.kind, charId: req.query.charId, transfer_id: req.query.transferId };
        const data = await Ledger.adminList(q, Math.min(Number(req.query.limit || 200), 500), Number(req.query.offset || 0));
        res.json({ ok: true, data });
    } catch (e) { next(e); }
});

export default router;