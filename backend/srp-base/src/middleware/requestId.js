/**
 * SRP Base
 * Created: 2025-02-14
 * Author: VSSVSSN
 */

const { randomUUID } = require('crypto');

module.exports = (req, res, next) => {
  const id = req.headers['x-request-id'] || randomUUID();
  req.id = id;
  res.setHeader('X-Request-Id', id);
  const start = process.hrtime.bigint();
  res.on('finish', () => {
    const diff = Number(process.hrtime.bigint() - start) / 1e6;
    const log = { requestId: id, method: req.method, path: req.url, status: res.statusCode, latencyMs: +diff.toFixed(2) };
    console.log(JSON.stringify(log));
  });
  next();
};
