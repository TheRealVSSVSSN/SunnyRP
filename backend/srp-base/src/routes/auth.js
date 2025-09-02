import { Router } from 'express';
import { z } from 'zod';
import jwt from 'jsonwebtoken';
import { v4 as uuidv4 } from 'uuid';
import { verifyCredentials, insertRefreshToken, rotateRefreshToken } from '../repositories/auth.js';

const router = Router();

router.post('/token', async (req, res, next) => {
  try {
    const { username, password } = z.object({
      username: z.string().min(1),
      password: z.string().min(1)
    }).parse(req.body);

    const accountId = await verifyCredentials(username, password);
    if (!accountId) return res.status(401).json({ error: 'Invalid credentials' });

    const secret = process.env.JWT_SECRET || 'changeme';
    const accessToken = jwt.sign({ accountId, scopes: ['accounts:read', 'accounts:write', 'hooks:read', 'hooks:write'] }, secret, { expiresIn: '15m' });
    const refreshToken = uuidv4();
    const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);

    await insertRefreshToken(accountId, refreshToken, expiresAt);

    res.json({ accessToken, refreshToken });
  } catch (err) {
    next(err);
  }
});

router.post('/refresh', async (req, res, next) => {
  try {
    const { refreshToken } = z.object({
      refreshToken: z.string().uuid()
    }).parse(req.body);

    const newToken = uuidv4();
    const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);
    const accountId = await rotateRefreshToken(refreshToken, newToken, expiresAt);
    if (!accountId) return res.status(401).json({ error: 'Invalid refresh token' });

    const secret = process.env.JWT_SECRET || 'changeme';
    const accessToken = jwt.sign({ accountId, scopes: ['accounts:read', 'accounts:write', 'hooks:read', 'hooks:write'] }, secret, { expiresIn: '15m' });

    res.json({ accessToken, refreshToken: newToken });
  } catch (err) {
    next(err);
  }
});

export default router;
