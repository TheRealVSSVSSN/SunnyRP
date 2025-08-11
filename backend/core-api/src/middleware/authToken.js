import { config } from '../config/index.js';
export default function authToken(required = true) {
    return (req, res, next) => {
        const token = req.headers['x-api-token'];
        if (!required && !token) return next();
        if (!token || token !== config.apiToken) {
            return res.status(401).json({ ok: false, error: { code: 'UNAUTHORIZED', message: 'Invalid API token' } });
        }
        next();
    };
}