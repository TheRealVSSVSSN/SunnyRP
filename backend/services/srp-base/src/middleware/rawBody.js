// src/middleware/rawBody.js
/**
 * Captures the exact raw body for HMAC verification before JSON parsing.
 */
export function captureRawBody() {
    return (req, res, next) => {
        const chunks = [];
        req.on('data', chunk => chunks.push(chunk));
        req.on('end', () => {
            req.rawBody = Buffer.concat(chunks).toString('utf8');
            next();
        });
    };
}
