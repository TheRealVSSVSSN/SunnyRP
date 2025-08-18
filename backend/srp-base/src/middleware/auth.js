const config = require('../config/env');
const { computeSignature, safeCompare } = require('../utils/hmac');
const { sendError } = require('../utils/respond');
const logger = require('../utils/logger');
const LRU = require('lru-cache');
const ipaddr = require('ipaddr.js');

// Cache for used nonces to prevent replay attacks.  This LRU
// implementation evicts entries after a configurable TTL.  Each
// nonce-key maps to its expiry timestamp.  When the TTL expires
// entries are purged automatically.
const nonceCache = new LRU({
  max: 10000,
  ttl: config.replayTtl * 1000,
});

/**
 * Parse a header value that may be missing.  Returns undefined if
 * header is not present.
 */
const header = (req, name) => req.get(name) || undefined;

/**
 * Check whether an IP is within the configured allowlist.  Supports
 * CIDR notation via ipaddr.js.  When the allowlist is empty the
 * function always returns true.
 *
 * @param {string} ipString An address such as '127.0.0.1'
 * @returns {boolean}
 */
function isIpAllowed(ipString) {
  if (!config.enableIpAllowlist || config.ipAllowlist.length === 0) return true;
  try {
    const addr = ipaddr.parse(ipString);
    return config.ipAllowlist.some((cidr) => {
      const [range, prefixLen] = cidr.split('/');
      const rangeAddr = ipaddr.parse(range);
      const kindMatches = rangeAddr.kind() === addr.kind();
      if (!kindMatches) return false;
      return addr.match(rangeAddr, parseInt(prefixLen, 10));
    });
  } catch (err) {
    return false;
  }
}

/**
 * Authentication and security middleware.  Enforces the API token,
 * optional IP allowlist, and optional HMAC replay protection.  On
 * failure the request is immediately rejected with the appropriate
 * error code and 401/403 status.
 */
function authMiddleware(req, res, next) {
  // IP allowlist
  if (!isIpAllowed(req.ip)) {
    return sendError(res, { code: 'FORBIDDEN', message: 'IP not allowed' }, 403, res.locals.requestId, res.locals.traceId);
  }
  // Token
  const token = header(req, 'X-API-Token');
  if (!token || token !== config.apiToken) {
    return sendError(res, { code: 'UNAUTHENTICATED', message: 'Missing or invalid API token' }, 401, res.locals.requestId, res.locals.traceId);
  }
  // HMAC (optional) – only enforce for write routes (POST, PUT, PATCH, DELETE)
  if (config.enableReplayGuard && /^(POST|PUT|PATCH|DELETE)$/i.test(req.method)) {
    const ts = header(req, 'X-Ts');
    const nonce = header(req, 'X-Nonce');
    const sig = header(req, 'X-Sig');
    if (!ts || !nonce || !sig) {
      return sendError(res, { code: 'UNAUTHENTICATED', message: 'Missing HMAC headers' }, 401, res.locals.requestId, res.locals.traceId);
    }
    const now = Math.floor(Date.now() / 1000);
    const tsInt = parseInt(ts, 10);
    if (Number.isNaN(tsInt) || Math.abs(now - tsInt) > config.replayTtl) {
      return sendError(res, { code: 'UNAUTHENTICATED', message: 'Timestamp outside allowable window' }, 401, res.locals.requestId, res.locals.traceId);
    }
    // Nonce replay check
    if (nonceCache.has(nonce)) {
      return sendError(res, { code: 'UNAUTHENTICATED', message: 'Nonce replay detected' }, 401, res.locals.requestId, res.locals.traceId);
    }
    // Compute body string
    let rawBody = '';
    // Bodies may be empty (e.g. for a DELETE).  The body-parser
    // middleware populates req.rawBody for HMAC, see app.js.
    if (req.rawBody) {
      rawBody = req.rawBody.toString('utf8');
    }
    const expected = computeSignature(
      req.method.toUpperCase(),
      req.originalUrl.split('?')[0],
      rawBody,
      ts,
      nonce,
      config.hmacSecret,
      config.hmacStyle,
    );
    if (!safeCompare(sig.toLowerCase(), expected.toLowerCase())) {
      return sendError(res, { code: 'UNAUTHENTICATED', message: 'Invalid signature' }, 401, res.locals.requestId, res.locals.traceId);
    }
    // Mark nonce as used
    nonceCache.set(nonce, true);
  }
  next();
}

module.exports = authMiddleware;