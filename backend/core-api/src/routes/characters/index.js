import { Router } from 'express';
import authToken from '../middleware/authToken.js';
import { listCharactersForUser, createCharacterForUser, selectCharacter, deleteCharacterForUser, savePosition } from '../services/characters/index.js';

const router = Router();

// GET /characters?userId=...
router.get('/characters', authToken(true), async (req, res, next) => {
    try {
        const userId = Number(req.query.userId);
        const data = await listCharactersForUser({ userId });
        res.json({ ok: true, data });
    } catch (e) { next(e); }
});

// POST /characters
router.post('/characters', authToken(true), async (req, res, next) => {
    try {
        const { userId, first_name, last_name, dob = null, gender = null } = req.body || {};
        const cid = await createCharacterForUser({ req, userId, payload: { first_name, last_name, dob, gender } });
        res.json({ ok: true, data: { id: cid } });
    } catch (e) { next(e); }
});

// POST /characters/select
router.post('/characters/select', authToken(true), async (req, res, next) => {
    try {
        const { userId, characterId } = req.body || {};
        const data = await selectCharacter({ userId, characterId });
        res.json({ ok: true, data });
    } catch (e) { next(e); }
});

// DELETE /characters/:id
router.delete('/characters/:id', authToken(true), async (req, res, next) => {
    try {
        const characterId = Number(req.params.id);
        const { userId } = req.body || {};
        await deleteCharacterForUser({ userId, characterId });
        res.json({ ok: true });
    } catch (e) { next(e); }
});

// (optional helper) POST /characters/state/position
router.post('/characters/state/position', authToken(true), async (req, res, next) => {
    try {
        const { characterId, position, routing_bucket = 0 } = req.body || {};
        await savePosition({ characterId, position, routing_bucket });
        res.json({ ok: true });
    } catch (e) { next(e); }
});

export default router;