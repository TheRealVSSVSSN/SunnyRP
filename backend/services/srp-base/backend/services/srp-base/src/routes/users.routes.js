// src/routes/users.routes.js
import { Router } from 'express';
import { z } from 'zod';
import { ok, fail } from '../utils/respond.js';
import * as Users from '../repositories/users.repo.js';

export const usersRouter = Router();

// GET /v1/users/exists?hex_id=abc
usersRouter.get('/v1/users/exists', async (req, res) => {
    const Schema = z.object({ hex_id: z.string().min(3) });
    const parsed = Schema.safeParse(req.query);
    if (!parsed.success) {
        const fieldErrors = parsed.error.errors.map(e => ({ path: e.path.join('.'), message: e.message }));
        return fail(req, res, 'INVALID_INPUT', 'Bad query', { fieldErrors });
    }
    const { hex_id } = parsed.data;
    try {
        const exists = await Users.existsByHexId(hex_id);
        return ok(req, res, { exists });
    } catch {
        return fail(req, res, 'INTERNAL_ERROR', 'Failed to check existence');
    }
});

// POST /v1/users
// body: { hex_id, name, identifiers?: [{type,value}], rank?: 'user' }
// Returns 201 on create; 409 if already exists (strict).
usersRouter.post('/v1/users', async (req, res) => {
    const Schema = z.object({
        hex_id: z.string().min(3),
        name: z.string().min(1),
        rank: z.string().min(1).default('user'),
        identifiers: z.array(
            z.object({ type: z.string().min(2), value: z.string().min(2) })
        ).optional().default([])
    });

    const parsed = Schema.safeParse(req.body || {});
    if (!parsed.success) {
        const fieldErrors = parsed.error.errors.map(e => ({ path: e.path.join('.'), message: e.message }));
        return fail(req, res, 'INVALID_INPUT', 'Bad body', { fieldErrors });
    }

    const { hex_id, name, rank, identifiers } = parsed.data;

    try {
        const exists = await Users.existsByHexId(hex_id);
        if (exists) {
            return fail(req, res, 'CONFLICT', 'User already exists');
        }
        const user = await Users.createUser({ hex_id, name, rank, identifiers });
        return ok(req, res, user, 201);
    } catch (e) {
        return fail(req, res, 'INTERNAL_ERROR', 'Failed to create user');
    }
});

// GET /v1/users/:hex_id
usersRouter.get('/v1/users/:hex_id', async (req, res) => {
    const Schema = z.object({ hex_id: z.string().min(3) });
    const parsed = Schema.safeParse(req.params);
    if (!parsed.success) {
        const fieldErrors = parsed.error.errors.map(e => ({ path: e.path.join('.'), message: e.message }));
        return fail(req, res, 'INVALID_INPUT', 'Bad params', { fieldErrors });
    }
    try {
        const user = await Users.getByHexId(parsed.data.hex_id);
        if (!user) return fail(req, res, 'NOT_FOUND', 'User not found');
        return ok(req, res, user);
    } catch {
        return fail(req, res, 'INTERNAL_ERROR', 'Failed to fetch user');
    }
});