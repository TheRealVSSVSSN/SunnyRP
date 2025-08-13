import { Router } from 'express';
import authToken from '../middleware/authToken.js';
import { getUserPermissions, grantPermission, revokePermission } from '../services/permissions/index.js';

const router = Router();

// GET /permissions/:userId
router.get('/permissions/:userId', authToken(true), async (req, res, next) => {
    try {
        const data = await getUserPermissions(Number(req.params.userId));
        res.json({ ok: true, data });
    } catch (e) { next(e); }
});

// POST /permissions/grant
router.post('/permissions/grant', authToken(true), async (req, res, next) => {
    try {
        const { userId, type, roleName, scope, allow = true } = req.body || {};
        const data = await grantPermission({ userId, type, roleName, scope, allow });
        res.json({ ok: true, data });
    } catch (e) { next(e); }
});

// DELETE /permissions/grant
router.delete('/permissions/grant', authToken(true), async (req, res, next) => {
    try {
        const { userId, type, roleName, scope } = req.body || {};
        const data = await revokePermission({ userId, type, roleName, scope });
        res.json({ ok: true, data });
    } catch (e) { next(e); }
});

export default router;