/**
 * SRP Base
 * Created: 2025-02-14
 * Author: VSSVSSN
 */

module.exports = (req, res, next) => {
  const key = req.headers['x-srp-internal-key'];
  const expected = process.env.SRP_INTERNAL_KEY || 'change_me';
  if (key && key === expected) {
    return next();
  }
  return res.status(401).json({ error: 'unauthorized' });
};
