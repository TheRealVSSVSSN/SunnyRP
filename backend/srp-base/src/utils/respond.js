/**
 * Response helpers for the standard SunnyRP envelope.  All API
 * endpoints should use these helpers to ensure consistent JSON
 * structures on success and error.  A requestId and traceId may be
 * supplied to aid in correlation across services.
 */

/**
 * Send a successful response.
 *
 * @param {express.Response} res HTTP response
 * @param {any} data Payload to send under the `data` key
 * @param {string} [requestId] Optional request ID for correlation
 * @param {string} [traceId] Optional trace ID for correlation
 */
function sendOk(res, data, requestId, traceId) {
  const body = { ok: true, data };
  if (requestId) body.requestId = requestId;
  if (traceId) body.traceId = traceId;
  res.status(200).json(body);
}

/**
 * Send an error response.  The error object should include a `code`
 * string and a `message`.  Additional details may be provided under
 * the `details` property.  The HTTP status code is supplied
 * separately so that error codes can remain decoupled from HTTP
 * semantics.
 *
 * @param {express.Response} res HTTP response
 * @param {{code: string, message: string, details?: any}} error
 * @param {number} statusCode HTTP status code (e.g. 400, 401)
 * @param {string} [requestId]
 * @param {string} [traceId]
 */
function sendError(res, error, statusCode, requestId, traceId) {
  const body = { ok: false, error };
  if (requestId) body.requestId = requestId;
  if (traceId) body.traceId = traceId;
  res.status(statusCode).json(body);
}

module.exports = { sendOk, sendError };