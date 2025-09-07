/**
 * SRP Base
 * Created: 2025-02-14
 * Author: VSSVSSN
 */

module.exports = (req, res, next) => {
  if (req.method === 'GET' || req.method === 'HEAD') return next();
  let data = '';
  req.on('data', chunk => { data += chunk; });
  req.on('end', () => {
    if (data.length > 0) {
      try {
        req.body = JSON.parse(data);
      } catch (e) {
        res.status(400).json({ error: 'invalid_json' });
        return;
      }
    } else {
      req.body = {};
    }
    next();
  });
};
