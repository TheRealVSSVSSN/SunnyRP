import { logger } from '../utils/logger.js';
export default function errorHandler(err, req, res, next) { // eslint-disable-line
    logger.error({ err, reqId: req.id }, 'Unhandled error');
    const status = err.statusCode || 500;
    res.status(status).json({ ok: false, error: { code: 'INTERNAL', message: 'Internal Server Error' } });
}