// backend/services/srp-base/src/routes/characters.routes.js
import { Router } from 'express';
import Joi from 'joi';
import { ok, err } from '../utils/respond.js';
import * as charRepo from '../repositories/characters.repo.js';
import * as usersRepo from '../repositories/users.repo.js';

export const charactersRouter = Router();

const listQuery = Joi.object({
    owner_hex: Joi.string().trim().min(3).max(128).required(),
});

const createBody = Joi.object({
    owner_hex: Joi.string().trim().min(3).max(128).required(),
    first_name: Joi.string().trim().min(2).max(48).regex(/^[A-Za-z][A-Za-z'-]{1,47}$/).required(),
    last_name: Joi.string().trim().min(2).max(48).regex(/^[A-Za-z][A-Za-z'-]{1,47}$/).required(),
    dob: Joi.string().isoDate().allow(null).optional(),
    gender: Joi.number().integer().min(0).max(9).allow(null).optional(), // small int code; 0..9 reserved
    story: Joi.string().trim().max(2048).allow('', null).optional(),
});

charactersRouter.get('/v1/characters', async (req, res, next) => {
    try {
        const { error, value } = listQuery.validate(req.query);
        if (error) return err(res, 'INVALID_INPUT', error.message, error.details, 400);
        const list = await charRepo.listByOwner(value.owner_hex);
        ok(res, { owner_hex: value.owner_hex, characters: list });
    } catch (e) { next(e); }
});

charactersRouter.post('/v1/characters', async (req, res, next) => {
    try {
        const { error, value } = createBody.validate(req.body);
        if (error) return err(res, 'INVALID_INPUT', error.message, error.details, 400);

        // Ensure owner user exists to avoid orphaned characters
        const owner = await usersRepo.getByHex(value.owner_hex);
        if (!owner) return err(res, 'FAILED_PRECONDITION', 'Owner user does not exist', null, 412);

        const created = await charRepo.createCharacter(value);
        ok(res, created);
    } catch (e) {
        if (e && e.code === 'DUPLICATE_NAME') {
            return err(res, 'CONFLICT', 'Character name already exists', null, 409);
        }
        next(e);
    }
});

charactersRouter.delete('/v1/characters/:id', async (req, res, next) => {
    try {
        const id = Number(req.params.id);
        if (!Number.isInteger(id) || id <= 0) return err(res, 'INVALID_INPUT', 'Invalid character id', null, 400);

        const existed = await charRepo.deleteCharacter(id);
        if (!existed) return err(res, 'NOT_FOUND', 'Character not found', null, 404);
        ok(res, { deleted: true, id });
    } catch (e) { next(e); }
});