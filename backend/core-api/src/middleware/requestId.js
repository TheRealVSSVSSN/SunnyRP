import { v4 as uuid } from 'uuid';
export default function requestId(req, res, next) {
    req.id = req.headers['x-request-id'] || uuid();
    res.setHeader('X-Request-Id', req.id);
    next();
}