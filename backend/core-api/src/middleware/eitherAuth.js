/**
 * eitherAuth — allows requests authenticated via HMAC (game) OR API token (website/worker).
 * Usage: app.use('/registration', eitherAuth());
 */
import hmacVerify from './hmacVerify.js';
import authToken from './authToken.js';

export default function eitherAuth() {
    const hv = hmacVerify();
    const at = authToken();

    return (req, res, next) => {
        // If HMAC headers present, try HMAC first
        const hasHmac = !!(req.get('X-Sig') || req.get('x-sig'));
        if (hasHmac) {
            return hv(req, res, (err) => {
                if (!err) return next();
                return at(req, res, next);
            });
        }
        // Otherwise, try API token flow
        return at(req, res, next);
    };
}