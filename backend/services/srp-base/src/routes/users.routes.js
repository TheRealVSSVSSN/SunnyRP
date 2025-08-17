// backend/services/srp-base/src/routes/users.routes.js
import { Router } from 'express';
import Joi from 'joi';
import { ok, err } from '../utils/respond.js';
import * as usersRepo from '../repositories/users.repo.js';

export const usersRouter = Router();

const existsQuery = Joi.object({
    hex_id: Joi.string().trim().min(3).max(128).required(),
});

const createBody = Joi.object({
    hex_id: Joi.string().trim().min(3).max(128).required(),
    name: Joi.string().trim().min(1).max(128).required(),
    // normalized identifiers array for future-proofing; repo only uses known types
    identifiers: Joi.array().items(
        Joi.object({
            type: Joi.string().valid('license', 'steam', 'discord', 'fivem', 'xbl', 'live', 'ip').required(),
            value: Joi.string().trim().min(2).max(128).required(),
        })
    ).default([]),
});

usersRouter.get('/v1/users/exists', async (req, res, next) => {
    try {
        const { error, value } = existsQuery.validate(req.query);
        if (error) return err(res, 'INVALID_INPUT', error.message, error.details, 400);

        const exists = await usersRepo.existsByHex(value.hex_id);
        ok(res, { hex_id: value.hex_id, exists });
    } catch (e) { next(e); }
});

usersRouter.post('/v1/users', async (req, res, next) => {
    try {
        const { error, value } = createBody.validate(req.body);
        if (error) return err(res, 'INVALID_INPUT', error.message, error.details, 400);

        const user = await usersRepo.createOrGet(value);
        ok(res, user);
    } catch (e) { next(e); }
});

usersRouter.get('/v1/users/:hex_id', async (req, res, next) => {
    try {
        const hex_id = String(req.params.hex_id);
        const user = await usersRepo.getByHex(hex_id);
        if (!user) return err(res, 'NOT_FOUND', 'User not found', null, 404);
        ok(res, user);
    } catch (e) { next(e); }
});