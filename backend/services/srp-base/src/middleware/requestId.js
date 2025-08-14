// src/middleware/requestId.js
import crypto from 'crypto';

/**
 * Adds requestId and a simple traceId to each request/response.
 */
export function requestId() {
    return (req, res, next) => {
        req.id = req.header('x-request-id') || crypto.randomUUID();
        res.locals.traceId = `trace-${crypto.randomUUID()}`;
        next();
    };
}