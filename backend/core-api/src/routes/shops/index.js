import { Router } from 'express';
import authToken from '../middleware/authToken.js';
import rateLimit from '../middleware/rateLimit.js';
import * as Shop from '../services/shops/index.js';
import { getEnv } from '../config/env.js';

const r = Router();
const limiter = rateLimit({ windowMs: 1000, max: 240 });

function actor(req){ return { user_id:Number(req.header('X-SRP-UserId')||0), char_id:Number(req.header('X-SRP-CharId')||0) }; }

r.get('/shops/catalog', authToken(true), async (req, res, next) => {
  try {
    const out = await Shop.catalog(req.query);
    res.json({ ok: !!out, data: out });
  } catch (e) { next(e); }
});

r.post('/shops/purchase', authToken(true), limiter, async (req, res, next) => {
  try {
    const globals = { defaultTax: getEnv('SHOP_DEFAULT_TAX', 8.5), apiToken: getEnv('API_TOKEN') };
    const out = await Shop.purchase(req.body || {}, actor(req), globals);
    res.json(out);
  } catch (e) { next(e); }
});

export default r;