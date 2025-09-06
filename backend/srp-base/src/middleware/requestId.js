const { randomUUID } = require('crypto');

module.exports = function requestId(req, res, next) {
  const id = req.headers['x-request-id'] || randomUUID();
  req.id = id;
  res.setHeader('X-Request-Id', id);
  const start = process.hrtime.bigint();
  res.on('finish', () => {
    const ms = Number(process.hrtime.bigint() - start) / 1e6;
    const log = {
      route: req.originalUrl,
      status: res.statusCode,
      method: req.method,
      requestId: id,
      ms: Math.round(ms)
    };
    console.log(JSON.stringify(log));
  });
  next();
};
