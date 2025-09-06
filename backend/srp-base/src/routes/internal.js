import { Router } from 'express';
import { logger } from '../util/logger.js';

const router = Router();

router.post('/rpc', (req, res) => {
  const key = req.get('x-srp-internal-key');
  if (key !== (process.env.SRP_INTERNAL_KEY || 'change_me')) {
    return res.status(401).json({ error: 'unauthorized' });
  }
  const envelope = req.body;
  if (!envelope || typeof envelope !== 'object') {
    return res.status(400).json({ error: 'invalid_envelope' });
  }
  logger.info({ envelope }, 'lua rpc');
  res.json({ ok: true });
});

export default router;
