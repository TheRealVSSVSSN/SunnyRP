import { Router } from 'express';
import { getCurrentTime } from '../util/time.js';

const router = Router();

/**
 * @openapi
 * /v1/health:
 *   get:
 *     summary: Service health
 *     tags:
 *       - System
 *     responses:
 *       '200':
 *         description: OK
 */
router.get('/health', (req, res) => {
  res.json({ status: 'ok', service: 'srp-base', time: getCurrentTime() });
});

/**
 * @openapi
 * /v1/ready:
 *   get:
 *     summary: Readiness check
 *     tags:
 *       - System
 *     responses:
 *       '200':
 *         description: Ready state
 */
router.get('/ready', (req, res) => {
  res.json({ ready: true, deps: [] });
});

/**
 * @openapi
 * /v1/info:
 *   get:
 *     summary: Service info
 *     tags:
 *       - System
 *     responses:
 *       '200':
 *         description: Info response
 */
router.get('/info', (req, res) => {
  res.json({ service: 'srp-base', version: '0.1.0', compat: { baseline: 'srp-base' } });
});

router.get('/time', (req, res) => {
  res.json({ time: getCurrentTime() });
});

export default router;
