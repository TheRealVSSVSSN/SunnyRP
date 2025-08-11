import { Router } from 'express';
import authToken from '../middleware/authToken.js';
import rateLimit from '../middleware/rateLimit.js';
import {
    getVehicles, registerVehicle, storeVehicleSvc, retrieveVehicleSvc, updateVehicleStateSvc,
    grantKeySvc, revokeKeySvc, hasKeySvc, listKeysSvc, transferTitleSvc, impoundSvc, adminDeleteSvc
} from '../services/vehicles.service.js';

const router = Router();
const vLimiter = rateLimit({ windowMs: 2000, max: 120 });

router.get('/vehicles', authToken(true), async (req, res, next) => {
    try {
        const charId = req.query.charId ? parseInt(req.query.charId, 10) : null;
        const state = req.query.state || null;
        const data = await getVehicles({ charId, state });
        res.json({ ok: true, data });
    } catch (e) { next(e); }
});

router.post('/vehicles/register', authToken(true), vLimiter, async (req, res, next) => {
    try {
        const body = req.body || {};
        if (!body.owner_char_id || !body.model) { const e = new Error('BAD_REQUEST'); e.statusCode = 400; throw e; }
        const data = await registerVehicle(body);
        res.json({ ok: true, data });
    } catch (e) { next(e); }
});

router.post('/vehicles/store', authToken(true), vLimiter, async (req, res, next) => {
    try { const data = await storeVehicleSvc(req.body || {}); res.json({ ok: true, data }); }
    catch (e) { next(e); }
});

router.post('/vehicles/retrieve', authToken(true), vLimiter, async (req, res, next) => {
    try { const data = await retrieveVehicleSvc(req.body || {}); res.json({ ok: true, data }); }
    catch (e) { next(e); }
});

router.post('/vehicles/state', authToken(true), async (req, res, next) => {
    try { const data = await updateVehicleStateSvc(req.body || {}); res.json({ ok: true, data }); }
    catch (e) { next(e); }
});

router.get('/vehicles/keys', authToken(true), async (req, res, next) => {
    try { const data = await listKeysSvc(parseInt(req.query.vehicleId, 10)); res.json({ ok: true, data }); }
    catch (e) { next(e); }
});

router.post('/vehicles/keys/grant', authToken(true), vLimiter, async (req, res, next) => {
    try { const data = await grantKeySvc(req.body || {}); res.json({ ok: true, data }); }
    catch (e) { next(e); }
});

router.post('/vehicles/keys/revoke', authToken(true), vLimiter, async (req, res, next) => {
    try { const data = await revokeKeySvc(req.body || {}); res.json({ ok: true, data }); }
    catch (e) { next(e); }
});

router.post('/vehicles/keys/has', authToken(true), async (req, res, next) => {
    try { const data = await hasKeySvc(req.body || {}); res.json({ ok: true, data }); }
    catch (e) { next(e); }
});

router.post('/vehicles/transfer', authToken(true), vLimiter, async (req, res, next) => {
    try {
        if (process.env.SRP_VEH_ALLOW_TITLE_TRANSFER === 'false') { const e = new Error('FORBIDDEN'); e.statusCode = 403; throw e; }
        const data = await transferTitleSvc(req.body || {}); res.json({ ok: true, data });
    } catch (e) { next(e); }
});

router.post('/vehicles/impound', authToken(true), vLimiter, async (req, res, next) => {
    try { const data = await impoundSvc(req.body || {}); res.json({ ok: true, data }); }
    catch (e) { next(e); }
});

router.delete('/vehicles/:id', authToken(true), vLimiter, async (req, res, next) => {
    try { const data = await adminDeleteSvc(parseInt(req.params.id, 10)); res.json({ ok: true, data }); }
    catch (e) { next(e); }
});

export default router;