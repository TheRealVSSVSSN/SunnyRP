// src/middleware/errorHandler.js
import { fail } from '../utils/respond.js';

/**
 * Last-chance error handler. Never leaks internals; logs happen via pino-http.
 */
export function errorHandler() {
    return (err, req, res, _next) => {
        // Optionally inspect err.name to map to more specific codes.
        return fail(req, res, 'INTERNAL_ERROR', 'Unexpected server error');
    };
}