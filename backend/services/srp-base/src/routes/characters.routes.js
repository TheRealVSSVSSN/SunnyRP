// src/routes/characters.routes.js
import { Router } from 'express';
import { z } from 'zod';
import { ok, fail } from '../utils/respond.js';
import * as Users from '../repositories/users.repo.js';
import * as Characters from '../repositories/characters.repo.js';

export const charactersRouter = Router();

// GET /v1/characters?owner_hex=abc
charactersRouter.get('/v1/characters', async (req, res) => {
    const Schema = z.object({ owner_hex: z.string().min(3) });
    const parsed = Schema.safeParse(req.query);
    if (!parsed.success) {
        const fieldErrors = parsed.error.errors.map(e => ({ path: e.path.join('.'), message: e.message }));
        return fail(req, res, 'INVALID_INPUT', 'Bad query', { fieldErrors });
    }
    try {
        const list = await Characters.listByOwnerHex(parsed.data.owner_hex);
        return ok(req, res, { characters: list });
    } catch {
        return fail(req, res, 'INTERNAL_ERROR', 'Failed to list characters');
    }
});

// POST /v1/characters
// body: { owner_hex, first_name, last_name, dob?, gender?, story? }
// Atomic: validates owner exists, unique name, and unique phone generation.
charactersRouter.post('/v1/characters', async (req, res) => {
    const Schema = z.object({
        owner_hex: z.string().min(3),
        first_name: z.string().min(1),
        last_name: z.string().min(1),
        dob: z.string().regex(/^\d{4}-\d{2}-\d{2}$/).optional(),
        gender: z.string().optional(),
        story: z.string().optional()
    });

    const parsed = Schema.safeParse(req.body || {});
    if (!parsed.success) {
        const fieldErrors = parsed.error.errors.map(e => ({ path: e.path.join('.'), message: e.message }));
        return fail(req, res, 'INVALID_INPUT', 'Bad body', { fieldErrors });
    }

    const { owner_hex } = parsed.data;
    try {
        const exists = await Users.existsByHexId(owner_hex);
        if (!exists) return fail(req, res, 'FAILED_PRECONDITION', 'Owner user does not exist');

        const created = await Characters.createCharacterAtomic(parsed.data);
        return ok(req, res, created, 201);
    } catch (e) {
        // Map repo error codes
        if (e && e.code === 'DUPLICATE_NAME') {
            return fail(req, res, 'CONFLICT', 'Character name already exists');
        }
        if (e && e.code === 'PHONE_EXHAUSTED') {
            return fail(req, res, 'FAILED_PRECONDITION', 'Could not allocate phone number');
        }
        return fail(req, res, 'INTERNAL_ERROR', 'Failed to create character');
    }
});

// GET /v1/characters/:id
charactersRouter.get('/v1/characters/:id', async (req, res) => {
    const Schema = z.object({ id: z.coerce.number().int().positive() });
    const parsed = Schema.safeParse(req.params);
    if (!parsed.success) {
        const fieldErrors = parsed.error.errors.map(e => ({ path: e.path.join('.'), message: e.message }));
        return fail(req, res, 'INVALID_INPUT', 'Bad params', { fieldErrors });
    }

    try {
        const char = await Characters.getById(parsed.data.id);
        if (!char) return fail(req, res, 'NOT_FOUND', 'Character not found');
        return ok(req, res, char);
    } catch {
        return fail(req, res, 'INTERNAL_ERROR', 'Failed to fetch character');
    }
});

// PATCH /v1/characters/:id (optional)
charactersRouter.patch('/v1/characters/:id', async (req, res) => {
    const ParamSchema = z.object({ id: z.coerce.number().int().positive() });
    const BodySchema = z.object({
        first_name: z.string().min(1).optional(),
        last_name: z.string().min(1).optional(),
        dob: z.string().regex(/^\d{4}-\d{2}-\d{2}$/).optional(),
        gender: z.string().optional(),
        story: z.string().optional()
    }).refine(b => Object.keys(b).length > 0, { message: 'No fields to update' });

    const p1 = ParamSchema.safeParse(req.params);
    if (!p1.success) {
        const fieldErrors = p1.error.errors.map(e => ({ path: e.path.join('.'), message: e.message }));
        return fail(req, res, 'INVALID_INPUT', 'Bad params', { fieldErrors });
    }
    const p2 = BodySchema.safeParse(req.body || {});
    if (!p2.success) {
        const fieldErrors = p2.error.errors.map(e => ({ path: e.path.join('.'), message: e.message }));
        return fail(req, res, 'INVALID_INPUT', 'Bad body', { fieldErrors });
    }

    try {
        const updated = await Characters.updateCharacter(p1.data.id, p2.data);
        if (!updated) return fail(req, res, 'NOT_FOUND', 'Character not found');
        return ok(req, res, updated);
    } catch {
        return fail(req, res, 'INTERNAL_ERROR', 'Failed to update character');
    }
});