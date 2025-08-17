// backend/services/srp-base/src/routes/config.routes.js
import { Router } from 'express';
import Joi from 'joi';
import { ok, err } from '../utils/respond.js';
import * as cfgRepo from '../repositories/config.repo.js';
import * as auditRepo from '../repositories/audit.repo.js';
import { requireScopes } from '../middleware/requireScopes.js';

export const configRouter = Router();

const postSchema = Joi.object({
    value: Joi.object().unknown(true).required(),
    updated_at: Joi.string().isoDate().optional(),
});

configRouter.get('/v1/config/live', async (_req, res, next) => {
    try {
        const rec = await cfgRepo.getLive();
        ok(res, rec || { value: {}, updated_at: null });
    } catch (e) { next(e); }
});

configRouter.post('/v1/config/live', requireScopes(['config:write']), async (req, res, next) => {
    try {
        const { error, value } = postSchema.validate(req.body);
        if (error) return err(res, 'INVALID_INPUT', error.message, error.details, 400);

        const result = await cfgRepo.upsertLive(value.value, value.updated_at || null);
        await auditRepo.append(
            'config_live_update',
            { actor: req?.auth?.subject || 'unknown', ip: req.ip, path: req.originalUrl },
            result,
        );
        ok(res, result);
    } catch (e) {
        if (e?.code === 'CONFIG_WRITE_CONFLICT') {
            return err(res, 'CONFLICT', 'Write conflict: config was updated by someone else', null, 409);
        }
        next(e);
    }
});