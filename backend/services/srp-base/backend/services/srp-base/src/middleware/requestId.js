// src/middleware/requestId.js
import crypto from 'crypto';

/**
 * Adds requestId and a traceId (honors incoming W3C traceparent if present).
 */
export function requestId() {
    return (req, res, next) => {
        req.id = req.header('x-request-id') || crypto.randomUUID();
        const traceparent = req.header('traceparent');
        res.locals.traceId = traceparent || `trace-${crypto.randomUUID()}`;
        next();
    };
}