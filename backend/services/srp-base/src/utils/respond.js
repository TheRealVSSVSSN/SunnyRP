// backend/services/srp-base/src/utils/respond.js
export function ok(res, data, status = 200) {
    res.status(status).json({
        ok: true,
        data,
        requestId: res.req.requestId || null,
        traceId: res.req.traceId || null,
    });
}

export function err(res, code, message, details = null, status = 400) {
    const error = { code, message };
    if (details != null) error.details = details;
    res.status(status).json({
        ok: false,
        error,
        requestId: res.req.requestId || null,
        traceId: res.req.traceId || null,
    });
}