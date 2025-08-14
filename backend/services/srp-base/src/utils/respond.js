// src/utils/respond.js
export function ok(req, res, data, code = 200) {
    return res.status(code).json({
        ok: true,
        data,
        requestId: req.id,
        traceId: res.locals.traceId
    });
}

export function fail(req, res, code, message, details) {
    const status = {
        INVALID_INPUT: 400,
        UNAUTHENTICATED: 401,
        FORBIDDEN: 403,
        NOT_FOUND: 404,
        CONFLICT: 409,
        FAILED_PRECONDITION: 422,
        RATE_LIMITED: 429,
        INTERNAL_ERROR: 500,
        DEPENDENCY_DOWN: 503
    }[code] || 500;

    return res.status(status).json({
        ok: false,
        error: {
            code,
            message,
            ...(details ? { details } : {})
        },
        requestId: req.id,
        traceId: res.locals.traceId
    });
}