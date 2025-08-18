const crypto = require('crypto');

/**
 * Compute an HMAC signature over the canonical string given the
 * configured style.  Supports two canonical styles: 'newline'
 * (default) and 'pipe'.
 *
 * @param {string} method HTTP method (upper case)
 * @param {string} path Normalised request path (without query)
 * @param {string} rawBody Raw request body string (empty string if no body)
 * @param {string} ts Timestamp as a string (unix seconds)
 * @param {string} nonce UUID or random string
 * @param {string} secret Shared secret used to generate the HMAC
 * @param {string} style Canonical style ('newline' or 'pipe')
 * @returns {string} Lowercase hex encoded signature
 */
function computeSignature(method, path, rawBody, ts, nonce, secret, style = 'newline') {
  let canonical;
  if (style === 'pipe') {
    canonical = `${method}|${path}|${rawBody}|${ts}|${nonce}`;
  } else {
    // default to newline style
    canonical = `${ts}\n${nonce}\n${method}\n${path}\n${rawBody}`;
  }
  return crypto
    .createHmac('sha256', secret)
    .update(canonical)
    .digest('hex');
}

/**
 * Constant‑time comparison of two strings.  Prevents timing attacks
 * against signature verification.  Returns true if the strings are
 * equal and false otherwise.  Handles null/undefined gracefully by
 * coercing to empty strings.
 *
 * @param {string|null|undefined} a
 * @param {string|null|undefined} b
 * @returns {boolean}
 */
function safeCompare(a, b) {
  const bufA = Buffer.from(a || '', 'utf8');
  const bufB = Buffer.from(b || '', 'utf8');
  if (bufA.length !== bufB.length) {
    return false;
  }
  return crypto.timingSafeEqual(bufA, bufB);
}

module.exports = { computeSignature, safeCompare };