// src/middleware/validate.js
import { fail } from '../utils/respond.js';

/**
 * Zod-based validator for req parts.
 * Usage: validate({ body: Schema, params: Schema })
 */
export function validate({ body, params, query } = {}) {
    return (req, res, next) => {
        try {
            if (body) req.body = body.parse(req.body);
            if (params) req.params = params.parse(req.params);
            if (query) req.query = query.parse(req.query);
            next();
        } catch (e) {
            return fail(req, res, 'INVALID_INPUT', 'Validation failed', {
                issues: e?.issues || String(e)
            });
        }
    };
}